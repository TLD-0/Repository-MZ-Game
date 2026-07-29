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
    [Tooltip("Dieser Dialog wird beim Interagieren mit dem Telefon gestartet.")]
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

    [Header("Quest")]
    [SerializeField]
    private SequenceQuestChecker questChecker;

    [Header("Interaktionsfreigabe")]
    [Tooltip(
        "Ist diese Option aktiviert, kann das Telefon nur benutzt werden, " +
        "wenn die eingetragene Quest aktiv ist."
    )]
    [SerializeField]
    private bool requireActiveQuest = true;

    [Tooltip(
        "Diese Quest muss den Status Active besitzen."
    )]
    [SerializeField]
    [Range(1, 15)]
    private int requiredQuestID = 3;

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

    private void Awake()
    {
        if (questChecker == null)
        {
            questChecker = GetComponent<SequenceQuestChecker>();
        }
    }

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
            PlayDialogue(correctNumberDialogue);
            return;
        }

        if (phoneInputActive)
        {
            Debug.Log(
                "PhoneSequenceQuest: Die Telefoneingabe läuft bereits.");
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: SequenceChoiceManager fehlt.");
            return;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: DialogueManager fehlt.");
            return;
        }

        if (phoneInputDialogue == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Phone Input Dialogue fehlt.");
            return;
        }

        if (!IsPhoneNumberValid(correctPhoneNumber))
        {
            Debug.LogError(
                "PhoneSequenceQuest: Telefonnummer ist ungültig.");
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

        Debug.Log("Telefon-Dialog gestartet.");
    }

    private void Update()
    {
        if (!phoneInputActive)
            return;

        if (inputLocked)
            return;

        if (!checkAutomatically)
            return;

        if (SequenceChoiceManager.Instance == null)
            return;

        if (SequenceChoiceManager.Instance.GetCount() >=
            correctPhoneNumber.Length)
        {
            CheckPhoneNumber();
        }
    }

    /// <summary>
    /// Wird von den Zahlenbuttons aufgerufen.
    /// </summary>
    public void EnterDigit(int digit)
    {
        if (!phoneInputActive)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Die Telefoneingabe wurde noch nicht gestartet.");
            return;
        }

        if (inputLocked)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Die Eingabe ist momentan gesperrt.");
            return;
        }

        if (digit < 0 || digit > 9)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Ungültige Ziffer: " + digit);
            return;
        }

        if (enteredDigits.Count >= correctPhoneNumber.Length)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Die maximale Anzahl an Ziffern wurde erreicht.");
            return;
        }

        enteredDigits.Add(digit);
        SequenceChoiceManager.Instance.AddValue(digit);

        Debug.Log(
            "Telefonnummer: " +
            GetEnteredNumber() +
            " | " +
            enteredDigits.Count +
            "/" +
            correctPhoneNumber.Length);

        if (checkAutomatically &&
            enteredDigits.Count == correctPhoneNumber.Length)
        {
            CheckPhoneNumber();
        }
    }

    /// <summary>
    /// Kann mit einem Anrufen- oder Bestätigen-Button verbunden werden.
    /// </summary>
    public void CheckPhoneNumber()
    {
        if (!phoneInputActive || inputLocked)
        {
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: SequenceChoiceManager fehlt.");
            return;
        }

        int enteredCount =
            SequenceChoiceManager.Instance.GetCount();

        if (enteredCount != correctPhoneNumber.Length)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Telefonnummer ist noch nicht vollständig. " +
                "Aktuell: " +
                enteredCount +
                "/" +
                correctPhoneNumber.Length);

            return;
        }

        int[] correctSequence =
            ConvertNumberToSequence(correctPhoneNumber);

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

        Debug.Log(
            "Richtige Telefonnummer eingegeben: " +
            SequenceChoiceManager.Instance.GetSequenceText());

        if (questChecker == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: Quest Checker wurde nicht zugewiesen.");
        }
        else
        {
            questChecker.CheckSequence();
        }

        onCorrectNumber?.Invoke();

        StartResultDialogue(correctNumberDialogue);
    }

    private void HandleWrongNumber()
    {
        phoneInputActive = false;

        Debug.Log(
            "Falsche Telefonnummer eingegeben: " +
            SequenceChoiceManager.Instance.GetSequenceText());

        onWrongNumber?.Invoke();

        if (resetAfterWrongNumber)
        {
            enteredDigits.Clear();
        }

        StartResultDialogue(wrongNumberDialogue);
    }

    private void StartResultDialogue(DialogueData dialogue)
    {
        if (resultDialogueRoutine != null)
        {
            StopCoroutine(resultDialogueRoutine);
        }

        resultDialogueRoutine =
            StartCoroutine(PlayResultDialogueNextFrame(dialogue));
    }

    private IEnumerator PlayResultDialogueNextFrame(
        DialogueData dialogue)
    {
        // Der Eingabedialog beendet sich in DialogueManager.SelectChoice()
        // erst nach dem Speichern der letzten Zahl. Einen Frame warten, damit
        // der Ergebnisdialog nicht sofort wieder geschlossen wird.
        yield return null;

        PlayDialogue(dialogue);

        inputLocked = false;
        resultDialogueRoutine = null;
    }

    /// <summary>
    /// Entfernt die zuletzt eingegebene Ziffer.
    /// </summary>
    public void DeleteLastDigit()
    {
        if (!phoneInputActive || inputLocked)
        {
            return;
        }

        if (enteredDigits.Count == 0)
        {
            return;
        }

        enteredDigits.RemoveAt(enteredDigits.Count - 1);

        RebuildManagerSequence();

        Debug.Log(
            "Letzte Ziffer gelöscht. Telefonnummer: " +
            GetEnteredNumber());
    }

    /// <summary>
    /// Löscht die gesamte aktuelle Telefonnummer.
    /// </summary>
    public void ClearPhoneNumber()
    {
        if (!phoneInputActive)
        {
            return;
        }

        enteredDigits.Clear();
        inputLocked = false;

        SequenceChoiceManager.Instance.StartSequence("Telefon");

        Debug.Log("Telefonnummer gelöscht.");
    }

    /// <summary>
    /// Startet nach einer falschen Eingabe eine neue Eingabe.
    /// </summary>
    public void ResetPhoneInput()
    {
        enteredDigits.Clear();

        // Wichtig: Nach einem Fehlversuch muss die Eingabe inaktiv sein,
        // damit StartPhoneQuest() beim nächsten Drücken von E wieder startet.
        phoneInputActive = false;
        inputLocked = false;

        if (SequenceChoiceManager.Instance != null)
        {
            SequenceChoiceManager.Instance.StartSequence("Telefon");
        }

        Debug.Log("Telefoneingabe wurde für einen neuen Versuch zurückgesetzt.");
    }

    public string GetEnteredNumber()
    {
        if (enteredDigits.Count == 0)
        {
            return "";
        }

        return string.Join("", enteredDigits);
    }

    private void RebuildManagerSequence()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        SequenceChoiceManager.Instance.StartSequence("Telefon");

        for (int i = 0; i < enteredDigits.Count; i++)
        {
            SequenceChoiceManager.Instance.AddValue(
                enteredDigits[i]);
        }
    }

    private void PlayDialogue(DialogueData dialogue)
    {
        if (dialogue == null)
        {
            Debug.LogWarning(
                "PhoneSequenceQuest: Für dieses Ergebnis wurde kein Dialog eingetragen.");
            return;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "PhoneSequenceQuest: DialogueManager fehlt.");
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
        int[] sequence = new int[phoneNumber.Length];

        for (int i = 0; i < phoneNumber.Length; i++)
        {
            sequence[i] = phoneNumber[i] - '0';
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

        for (int i = 0; i < phoneNumber.Length; i++)
        {
            if (!char.IsDigit(phoneNumber[i]))
            {
                return false;
            }
        }

        return true;
    }

    // Komfortmethoden, falls dein Button-System keine Integer
    // als Parameter übergeben kann.

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