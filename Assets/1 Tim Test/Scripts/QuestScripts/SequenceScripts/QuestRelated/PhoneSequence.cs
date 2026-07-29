using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class PhoneSequenceQuest : MonoBehaviour
{
    [Header("Telefonnummer")]
    [SerializeField]
    private string correctPhoneNumber = "012345";

    [SerializeField]
    private bool checkAutomatically = true;

    [SerializeField]
    private bool resetAfterWrongNumber = true;

    [Header("Dialog zur Zahleneingabe")]
    [SerializeField]
    private DialogueData phoneInputDialogue;

    [Header("Dialog bei richtiger Nummer")]
    [SerializeField]
    private DialogueData correctNumberDialogue;

    [Header("Optionaler Dialog bei falscher Nummer")]
    [SerializeField]
    private DialogueData wrongNumberDialogue;

    [Header("Dialogpositionen")]
    [SerializeField]
    private Transform playerPoint;

    [SerializeField]
    private Transform cameraPoint;

    [SerializeField]
    private NPCEmotionController emotionController;

    [Header("Questabschluss")]
    [Tooltip(
        "Aktiviert: Bei richtiger Telefonnummer wird die Required Quest ID " +
        "direkt abgeschlossen. Das ist für die Telefonquest empfohlen."
    )]
    [SerializeField]
    private bool completeRequiredQuestOnCorrectNumber = true;

    [Tooltip(
        "Optionaler alter Sequenz-Checker. Er wird nur verwendet, wenn " +
        "Complete Required Quest On Correct Number deaktiviert ist."
    )]
    [SerializeField]
    private SequenceQuestChecker questChecker;

    [Header("Interaktionsfreigabe")]
    [Tooltip(
        "Ist diese Option aktiviert, kann das Telefon nur benutzt werden, " +
        "wenn die eingetragene Quest Active ist."
    )]
    [SerializeField]
    private bool requireActiveQuest = true;

    [Tooltip(
        "Diese Quest muss den Status Active besitzen und wird bei Erfolg abgeschlossen."
    )]
    [SerializeField]
    [Range(1, 16)]
    private int requiredQuestID = 9;

    [Header("Optionale Events")]
    [SerializeField]
    private UnityEvent onCorrectNumber;

    [SerializeField]
    private UnityEvent onWrongNumber;

    private readonly List<int> enteredDigits =
        new List<int>();

    private bool phoneInputActive;
    private bool inputLocked;
    private bool questCompleted;
    private Coroutine resultDialogueRoutine;

    public bool CanInteract()
    {
        if (!requireActiveQuest)
        {
            return true;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: QuestManager wurde nicht gefunden.",
                this);

            return false;
        }

        return QuestManager.Instance.IsQuestActive(
            requiredQuestID);
    }

    public void StartPhoneQuest()
    {
        if (!CanInteract())
        {
            Debug.Log(
                "PhoneSequenceQuest: Das Telefon kann erst benutzt werden, " +
                "wenn Quest " +
                requiredQuestID +
                " aktiv ist.",
                this);

            return;
        }

        if (questCompleted)
        {
            PlayDialogue(
                correctNumberDialogue);

            return;
        }

        if (phoneInputActive)
        {
            Debug.Log(
                "PhoneSequenceQuest: Die Telefoneingabe läuft bereits.",
                this);

            return;
        }

        if (!ValidateStart())
        {
            return;
        }

        enteredDigits.Clear();
        phoneInputActive = true;
        inputLocked = false;

        SequenceChoiceManager.Instance.StartSequence(
            "Telefon");

        DialogueManager.Instance.StartDialogue(
            phoneInputDialogue,
            playerPoint,
            cameraPoint,
            emotionController);

        Debug.Log(
            "PhoneSequenceQuest: Telefon-Dialog gestartet.",
            this);
    }

    private void Update()
    {
        if (!phoneInputActive ||
            inputLocked)
        {
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        SyncEnteredDigitsFromManager();

        int enteredCount =
            SequenceChoiceManager.Instance.GetCount();

        if (checkAutomatically &&
            enteredCount >= correctPhoneNumber.Length)
        {
            CheckPhoneNumber();
            return;
        }

        /*
         * Wurde der Eingabedialog mit Escape oder durch ein anderes Script
         * beendet, wird die Telefonquest wieder freigegeben.
         */
        if (DialogueManager.Instance != null &&
            !DialogueManager.Instance.IsDialogueActive)
        {
            CancelPhoneInput();
        }
    }

    public void EnterDigit(
        int digit)
    {
        if (!phoneInputActive ||
            inputLocked)
        {
            return;
        }

        if (digit < 0 ||
            digit > 9)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Ungültige Ziffer: " +
                digit,
                this);

            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: SequenceChoiceManager fehlt.",
                this);

            return;
        }

        if (SequenceChoiceManager.Instance.GetCount() >=
            correctPhoneNumber.Length)
        {
            return;
        }

        SequenceChoiceManager.Instance.AddValue(
            digit);

        SyncEnteredDigitsFromManager();

        if (checkAutomatically &&
            SequenceChoiceManager.Instance.GetCount() ==
            correctPhoneNumber.Length)
        {
            CheckPhoneNumber();
        }
    }

    public void CheckPhoneNumber()
    {
        if (!phoneInputActive ||
            inputLocked)
        {
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: SequenceChoiceManager fehlt.",
                this);

            return;
        }

        int enteredCount =
            SequenceChoiceManager.Instance.GetCount();

        if (enteredCount != correctPhoneNumber.Length)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Telefonnummer ist noch nicht vollständig. " +
                enteredCount +
                "/" +
                correctPhoneNumber.Length,
                this);

            return;
        }

        int[] correctSequence =
            ConvertNumberToSequence(
                correctPhoneNumber);

        bool isCorrect =
            SequenceChoiceManager.Instance.MatchesSequence(
                correctSequence);

        inputLocked = true;

        if (isCorrect)
        {
            HandleCorrectNumber();
        }
        else
        {
            HandleWrongNumber();
        }
    }

    private void HandleCorrectNumber()
    {
        phoneInputActive = false;
        questCompleted = true;

        bool questWasCompleted = false;

        if (completeRequiredQuestOnCorrectNumber)
        {
            if (QuestManager.Instance == null)
            {
                Debug.LogError(
                    "PhoneSequenceQuest: QuestManager fehlt.",
                    this);
            }
            else
            {
                questWasCompleted =
                    QuestManager.Instance.CompleteQuest(
                        requiredQuestID);
            }
        }
        else if (questChecker != null)
        {
            questWasCompleted =
                questChecker.CheckSequence();
        }
        else
        {
            Debug.LogError(
                "PhoneSequenceQuest: Es ist weder direkter Questabschluss " +
                "aktiviert noch ein Quest Checker eingetragen.",
                this);
        }

        Debug.Log(
            "PhoneSequenceQuest: Richtige Telefonnummer. Questabschluss: " +
            questWasCompleted,
            this);

        onCorrectNumber?.Invoke();

        StartResultDialogue(
            correctNumberDialogue);
    }

    private void HandleWrongNumber()
    {
        phoneInputActive = false;

        Debug.Log(
            "PhoneSequenceQuest: Falsche Telefonnummer: " +
            SequenceChoiceManager.Instance.GetSequenceText(),
            this);

        onWrongNumber?.Invoke();

        if (resetAfterWrongNumber)
        {
            enteredDigits.Clear();
        }

        StartResultDialogue(
            wrongNumberDialogue);
    }

    private void StartResultDialogue(
        DialogueData dialogue)
    {
        if (resultDialogueRoutine != null)
        {
            StopCoroutine(
                resultDialogueRoutine);
        }

        resultDialogueRoutine =
            StartCoroutine(
                PlayResultDialogueNextFrame(
                    dialogue));
    }

    private IEnumerator PlayResultDialogueNextFrame(
        DialogueData dialogue)
    {
        yield return null;

        PlayDialogue(
            dialogue);

        inputLocked = false;
        resultDialogueRoutine = null;
    }

    public void DeleteLastDigit()
    {
        if (!phoneInputActive ||
            inputLocked)
        {
            return;
        }

        SyncEnteredDigitsFromManager();

        if (enteredDigits.Count == 0)
        {
            return;
        }

        enteredDigits.RemoveAt(
            enteredDigits.Count - 1);

        RebuildManagerSequence();
    }

    public void ClearPhoneNumber()
    {
        if (!phoneInputActive)
        {
            return;
        }

        enteredDigits.Clear();
        inputLocked = false;

        if (SequenceChoiceManager.Instance != null)
        {
            SequenceChoiceManager.Instance.StartSequence(
                "Telefon");
        }
    }

    public void ResetPhoneInput()
    {
        CancelPhoneInput();
    }

    public void CancelPhoneInput()
    {
        enteredDigits.Clear();
        phoneInputActive = false;
        inputLocked = false;

        if (resultDialogueRoutine != null)
        {
            StopCoroutine(
                resultDialogueRoutine);

            resultDialogueRoutine = null;
        }

        if (SequenceChoiceManager.Instance != null)
        {
            SequenceChoiceManager.Instance.StartSequence(
                "Telefon");
        }

        Debug.Log(
            "PhoneSequenceQuest: Telefoneingabe wurde zurückgesetzt.",
            this);
    }

    public string GetEnteredNumber()
    {
        SyncEnteredDigitsFromManager();

        if (enteredDigits.Count == 0)
        {
            return "";
        }

        return string.Join(
            "",
            enteredDigits);
    }

    private bool ValidateStart()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: SequenceChoiceManager fehlt.",
                this);

            return false;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: DialogueManager fehlt.",
                this);

            return false;
        }

        if (phoneInputDialogue == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Phone Input Dialogue fehlt.",
                this);

            return false;
        }

        if (playerPoint == null ||
            cameraPoint == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Player Point oder Camera Point fehlt.",
                this);

            return false;
        }

        if (!IsPhoneNumberValid(correctPhoneNumber))
        {
            Debug.LogError(
                "PhoneSequenceQuest: Telefonnummer ist ungültig.",
                this);

            return false;
        }

        return true;
    }

    private void SyncEnteredDigitsFromManager()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        enteredDigits.Clear();

        int count =
            SequenceChoiceManager.Instance.GetCount();

        for (int i = 0;
             i < count;
             i++)
        {
            enteredDigits.Add(
                SequenceChoiceManager.Instance.GetValue(i));
        }
    }

    private void RebuildManagerSequence()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        SequenceChoiceManager.Instance.StartSequence(
            "Telefon");

        for (int i = 0;
             i < enteredDigits.Count;
             i++)
        {
            SequenceChoiceManager.Instance.AddValue(
                enteredDigits[i]);
        }
    }

    private void PlayDialogue(
        DialogueData dialogue)
    {
        if (dialogue == null)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Für dieses Ergebnis wurde kein Dialog eingetragen.",
                this);

            return;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: DialogueManager fehlt.",
                this);

            return;
        }

        DialogueManager.Instance.StartDialogue(
            dialogue,
            playerPoint,
            cameraPoint,
            emotionController);
    }

    private static int[] ConvertNumberToSequence(
        string phoneNumber)
    {
        int[] sequence =
            new int[phoneNumber.Length];

        for (int i = 0;
             i < phoneNumber.Length;
             i++)
        {
            sequence[i] =
                phoneNumber[i] - '0';
        }

        return sequence;
    }

    private static bool IsPhoneNumberValid(
        string phoneNumber)
    {
        if (string.IsNullOrWhiteSpace(phoneNumber))
        {
            return false;
        }

        for (int i = 0;
             i < phoneNumber.Length;
             i++)
        {
            if (!char.IsDigit(phoneNumber[i]))
            {
                return false;
            }
        }

        return true;
    }

    public void Press0() => EnterDigit(0);
    public void Press1() => EnterDigit(1);
    public void Press2() => EnterDigit(2);
    public void Press3() => EnterDigit(3);
    public void Press4() => EnterDigit(4);
    public void Press5() => EnterDigit(5);
    public void Press6() => EnterDigit(6);
    public void Press7() => EnterDigit(7);
    public void Press8() => EnterDigit(8);
    public void Press9() => EnterDigit(9);
}
