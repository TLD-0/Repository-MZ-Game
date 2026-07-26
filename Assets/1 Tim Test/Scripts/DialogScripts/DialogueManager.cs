using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance;

    [Header("UI")]
    public GameObject dialoguePanel;
    public TMP_Text dialogueText;

    [Tooltip(
        "Alte, feste Antwortfelder. Können leer bleiben, " +
        "wenn nur Choice Container und Choice Prefab verwendet werden."
    )]
    public GameObject[] choicePanels;

    [Tooltip(
        "Alte, feste Antworttexte. Werden nicht mehr für " +
        "die Tastatureingabe benötigt."
    )]
    public TMP_Text[] choiceTexts;

    [SerializeField]
    private DialogueTextScroller dialogueTextScroller;

    [Header("Dynamische Antworten")]
    public Transform choiceContainer;
    public GameObject choicePrefab;

    [Header("Spieler")]
    public PlayerLock playerLock;

    [Header("Spielerportrait")]
    [SerializeField]
    private PlayerEmotionPortrait playerEmotionPortrait;

    private DialogueData currentDialogue;
    private NPCEmotionController currentEmotionController;

    private int currentNode = -1;
    private bool dialogueActive;
    private bool isProcessingChoice;

    public bool IsDialogueActive
    {
        get { return dialogueActive; }
    }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Debug.LogWarning(
                "DialogueManager: Es existiert bereits ein DialogueManager. " +
                "Die zusätzliche Komponente wird entfernt.",
                this);

            Destroy(this);
            return;
        }

        Instance = this;

        if (dialogueTextScroller == null &&
            dialogueText != null)
        {
            dialogueTextScroller =
                dialogueText.GetComponent<DialogueTextScroller>();
        }

        if (playerEmotionPortrait == null)
        {
            playerEmotionPortrait =
                FindFirstObjectByType<PlayerEmotionPortrait>();
        }

        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(false);
        }

        ClearChoices();
    }

    private void OnDestroy()
    {
        if (Instance == this)
        {
            Instance = null;
        }
    }

    private void Update()
    {
        if (!dialogueActive)
        {
            return;
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EndDialogue();
            return;
        }

        HandleKeyboardChoices();
    }

    private void HandleKeyboardChoices()
    {
        DialogueNode node = GetCurrentNode();

        if (node == null ||
            node.choices == null ||
            isProcessingChoice)
        {
            return;
        }

        /*
         * Tastatur:
         *
         * Antwort 1 bis 9 = Tasten 1 bis 9
         * Antwort 10      = Taste 0
         *
         * Weitere Antworten können weiterhin mit
         * der Maus angeklickt werden.
         */
        int keyboardChoiceCount =
            Mathf.Min(node.choices.Count, 10);

        for (int i = 0; i < keyboardChoiceCount; i++)
        {
            if (WasChoiceKeyPressed(i))
            {
                SelectChoice(i);
                return;
            }
        }
    }

    private bool WasChoiceKeyPressed(int choiceIndex)
    {
        if (choiceIndex < 0 || choiceIndex > 9)
        {
            return false;
        }

        // Antwort 10 wird über 0 gewählt.
        if (choiceIndex == 9)
        {
            return
                Input.GetKeyDown(KeyCode.Alpha0) ||
                Input.GetKeyDown(KeyCode.Keypad0);
        }

        KeyCode alphaKey =
            (KeyCode)((int)KeyCode.Alpha1 + choiceIndex);

        KeyCode keypadKey =
            (KeyCode)((int)KeyCode.Keypad1 + choiceIndex);

        return
            Input.GetKeyDown(alphaKey) ||
            Input.GetKeyDown(keypadKey);
    }

    public void StartDialogue(
        DialogueData dialogue,
        Transform playerPoint,
        Transform cameraPoint,
        NPCEmotionController emotionController)
    {
        if (!ValidateDialogueStart(
                dialogue,
                playerPoint,
                cameraPoint))
        {
            return;
        }

        /*
         * Falls bereits ein Dialog läuft, wird dieser sauber
         * geschlossen, bevor der neue Dialog startet.
         *
         * Das ist unter anderem für die Ergebnisdialoge der
         * Telefonquest wichtig.
         */
        if (dialogueActive)
        {
            EndDialogue();
        }

        currentDialogue = dialogue;
        currentEmotionController = emotionController;

        currentNode = 0;
        dialogueActive = true;
        isProcessingChoice = false;

        dialoguePanel.SetActive(true);

        playerLock.LockPlayer(
            playerPoint,
            cameraPoint);

        if (playerEmotionPortrait != null)
        {
            playerEmotionPortrait.ShowPortrait();
        }

        ShowNode();

        Debug.Log(
            "DialogueManager: Dialog gestartet.");
    }

    private bool ValidateDialogueStart(
        DialogueData dialogue,
        Transform playerPoint,
        Transform cameraPoint)
    {
        if (dialogue == null ||
            dialogue.nodes == null ||
            dialogue.nodes.Count == 0)
        {
            Debug.LogError(
                "DialogueManager: Kein gültiger Dialog zugewiesen.");

            return false;
        }

        if (dialoguePanel == null)
        {
            Debug.LogError(
                "DialogueManager: Dialogue Panel wurde nicht zugewiesen.");

            return false;
        }

        if (dialogueText == null &&
            dialogueTextScroller == null)
        {
            Debug.LogError(
                "DialogueManager: Weder Dialogue Text noch " +
                "Dialogue Text Scroller wurde zugewiesen.");

            return false;
        }

        if (choiceContainer == null)
        {
            Debug.LogError(
                "DialogueManager: Choice Container wurde nicht zugewiesen.");

            return false;
        }

        if (choicePrefab == null)
        {
            Debug.LogError(
                "DialogueManager: Choice Prefab wurde nicht zugewiesen.");

            return false;
        }

        if (playerLock == null)
        {
            Debug.LogError(
                "DialogueManager: PlayerLock wurde nicht zugewiesen.");

            return false;
        }

        if (playerPoint == null)
        {
            Debug.LogError(
                "DialogueManager: Player Point wurde nicht zugewiesen.");

            return false;
        }

        if (cameraPoint == null)
        {
            Debug.LogError(
                "DialogueManager: Camera Point wurde nicht zugewiesen.");

            return false;
        }

        return true;
    }

    private void ShowNode()
    {
        DialogueNode node = GetCurrentNode();

        if (node == null)
        {
            Debug.LogError(
                "DialogueManager: Der aktuelle Dialog-Node ist ungültig.");

            EndDialogue();
            return;
        }

        ApplyPlayerEmotion(node);
        ApplyNPCEmotions(node);
        ShowDialogueText(node);

        ClearChoices();
        CreateChoices(node);

        isProcessingChoice = false;
    }

    private DialogueNode GetCurrentNode()
    {
        if (currentDialogue == null ||
            currentDialogue.nodes == null)
        {
            return null;
        }

        if (currentNode < 0 ||
            currentNode >= currentDialogue.nodes.Count)
        {
            return null;
        }

        return currentDialogue.nodes[currentNode];
    }

    private void ApplyPlayerEmotion(
        DialogueNode node)
    {
        if (!node.changePlayerEmotion)
        {
            return;
        }

        if (playerEmotionPortrait == null)
        {
            Debug.LogWarning(
                "DialogueManager: Der Node möchte die " +
                "Spieleremotion ändern, aber es wurde kein " +
                "PlayerEmotionPortrait gefunden.");

            return;
        }

        playerEmotionPortrait.SetEmotion(
            node.playerEmotion);
    }

    private void ApplyNPCEmotions(
        DialogueNode node)
    {
        if (node.emotionChanges == null)
        {
            return;
        }

        foreach (NPCEmotionChange change in node.emotionChanges)
        {
            if (change == null)
            {
                continue;
            }

            /*
             * Falls im Dialog-Asset kein bestimmter NPC
             * eingetragen wurde, wird automatisch der NPC
             * verwendet, mit dem gerade gesprochen wird.
             */
            NPCEmotionController targetController =
                change.targetNPC != null
                    ? change.targetNPC
                    : currentEmotionController;

            if (targetController == null)
            {
                Debug.LogWarning(
                    "DialogueManager: Für einen Emotion Change " +
                    "wurde kein NPCEmotionController gefunden.");

                continue;
            }

            targetController.SetEmotion(
                change.emotion);
        }
    }

    private void ShowDialogueText(
        DialogueNode node)
    {
        string text =
            node.dialogueText ?? "";

        if (dialogueTextScroller != null)
        {
            dialogueTextScroller.SetText(text);
            return;
        }

        if (dialogueText != null)
        {
            dialogueText.text = text;
        }
    }

    private void ClearChoices()
    {
        if (choiceContainer == null)
        {
            return;
        }

        /*
         * Destroy wird erst am Ende des Frames ausgeführt.
         * Durch SetActive(false) verschwinden die alten
         * Antworten sofort.
         */
        for (int i = choiceContainer.childCount - 1;
             i >= 0;
             i--)
        {
            GameObject child =
                choiceContainer.GetChild(i).gameObject;

            child.SetActive(false);
            Destroy(child);
        }
    }

    private void CreateChoices(
        DialogueNode node)
    {
        if (node.choices == null ||
            node.choices.Count == 0)
        {
            Debug.LogWarning(
                "DialogueManager: Der aktuelle Node besitzt " +
                "keine Antworten. Der Dialog kann mit ESC beendet werden.");

            return;
        }

        for (int i = 0; i < node.choices.Count; i++)
        {
            int capturedIndex = i;

            GameObject choiceObject =
                Instantiate(
                    choicePrefab,
                    choiceContainer);

            DialogueChoiceUI choiceUI =
                choiceObject.GetComponent<DialogueChoiceUI>();

            if (choiceUI == null)
            {
                Debug.LogError(
                    "DialogueManager: Das Choice Prefab besitzt " +
                    "keine DialogueChoiceUI-Komponente.",
                    choiceObject);

                Destroy(choiceObject);
                continue;
            }

            string shortcutText =
                GetShortcutText(i);

            choiceUI.SetText(
                shortcutText +
                ". " +
                node.choices[i].answerText);

            /*
             * Dadurch können die dynamisch erzeugten Antworten
             * zusätzlich mit der Maus angeklickt werden.
             */
            Button button =
                choiceObject.GetComponent<Button>();

            if (button == null)
            {
                button =
                    choiceObject.GetComponentInChildren<Button>(true);
            }

            if (button != null)
            {
                button.onClick.AddListener(
                    () => SelectChoice(capturedIndex));
            }
        }

        RectTransform containerRect =
            choiceContainer as RectTransform;

        if (containerRect != null)
        {
            LayoutRebuilder.ForceRebuildLayoutImmediate(
                containerRect);
        }

        if (node.choices.Count > 10)
        {
            Debug.LogWarning(
                "DialogueManager: Der aktuelle Node besitzt mehr " +
                "als zehn Antworten. Nur die ersten zehn können " +
                "über die Zahlentasten gewählt werden. Alle Antworten " +
                "bleiben per Mausklick verfügbar.");
        }
    }

    private string GetShortcutText(
        int choiceIndex)
    {
        if (choiceIndex == 9)
        {
            return "0";
        }

        return (choiceIndex + 1).ToString();
    }

    private void SelectChoice(
        int index)
    {
        if (!dialogueActive ||
            isProcessingChoice)
        {
            return;
        }

        DialogueNode node =
            GetCurrentNode();

        if (node == null ||
            node.choices == null)
        {
            return;
        }

        if (index < 0 ||
            index >= node.choices.Count)
        {
            Debug.LogWarning(
                "DialogueManager: Ungültiger Choice-Index: " +
                index);

            return;
        }

        isProcessingChoice = true;

        DialogueChoice choice =
            node.choices[index];

        ProcessSequenceActions(choice);
        ProcessQuestActions(choice);

        if (choice.nextNode == -1)
        {
            EndDialogue();
            return;
        }

        if (choice.nextNode < 0 ||
            choice.nextNode >= currentDialogue.nodes.Count)
        {
            Debug.LogError(
                "DialogueManager: Die Antwort verweist auf " +
                "einen ungültigen nächsten Node: " +
                choice.nextNode);

            EndDialogue();
            return;
        }

        currentNode = choice.nextNode;

        ShowNode();
    }

    private void ProcessSequenceActions(
        DialogueChoice choice)
    {
        if (choice.addsSequenceValue)
        {
            if (SequenceChoiceManager.Instance == null)
            {
                Debug.LogError(
                    "DialogueManager: SequenceChoiceManager " +
                    "wurde nicht gefunden.");
            }
            else
            {
                SequenceChoiceManager.Instance.AddValue(
                    choice.sequenceValue);
            }
        }

        if (!choice.checksSequence)
        {
            return;
        }

        if (choice.sequenceChecker == null)
        {
            Debug.LogError(
                "DialogueManager: Checks Sequence ist aktiviert, " +
                "aber es wurde kein Sequence Checker zugewiesen.");

            return;
        }

        choice.sequenceChecker.CheckSequence();
    }

    private void ProcessQuestActions(
        DialogueChoice choice)
    {
        if (choice.questsToStart != null)
        {
            foreach (QuestStart quest in choice.questsToStart)
            {
                StartQuest(quest.questID);
            }
        }

        if (choice.skipsQuest)
        {
            SkipQuest(choice.questIDToSkip);
        }
    }

    private void StartQuest(
        int questID)
    {
        if (SetQuestStatus(
                questID,
                QuestStatus.Active))
        {
            Debug.Log(
                "Quest " +
                questID +
                " wurde aktiviert.");
        }
    }

    private void SkipQuest(
        int questID)
    {
        if (SetQuestStatus(
                questID,
                QuestStatus.Skipped))
        {
            Debug.Log(
                "Quest " +
                questID +
                " wurde übersprungen.");
        }
    }

    private bool SetQuestStatus(
        int questID,
        QuestStatus newStatus)
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "DialogueManager: QuestManager wurde nicht gefunden.");

            return false;
        }

        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 = newStatus;
                break;

            case 2:
                QuestManager.Instance.quest2 = newStatus;
                break;

            case 3:
                QuestManager.Instance.quest3 = newStatus;
                break;

            case 4:
                QuestManager.Instance.quest4 = newStatus;
                break;

            case 5:
                QuestManager.Instance.quest5 = newStatus;
                break;

            case 6:
                QuestManager.Instance.quest6 = newStatus;
                break;

            case 7:
                QuestManager.Instance.quest7 = newStatus;
                break;

            case 8:
                QuestManager.Instance.quest8 = newStatus;
                break;

            case 9:
                QuestManager.Instance.quest9 = newStatus;
                break;

            case 10:
                QuestManager.Instance.quest10 = newStatus;
                break;

            case 11:
                QuestManager.Instance.quest11 = newStatus;
                break;

            case 12:
                QuestManager.Instance.quest12 = newStatus;
                break;

            case 13:
                QuestManager.Instance.quest13 = newStatus;
                break;

            case 14:
                QuestManager.Instance.quest14 = newStatus;
                break;

            case 15:
                QuestManager.Instance.quest15 = newStatus;
                break;

            default:
                Debug.LogError(
                    "DialogueManager: Ungültige Quest-ID: " +
                    questID);

                return false;
        }

        return true;
    }

    public void EndDialogue()
    {
        if (!dialogueActive &&
            currentDialogue == null)
        {
            return;
        }

        dialogueActive = false;
        isProcessingChoice = false;

        ClearChoices();

        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(false);
        }

        if (choicePanels != null)
        {
            for (int i = 0;
                 i < choicePanels.Length;
                 i++)
            {
                if (choicePanels[i] != null)
                {
                    choicePanels[i].SetActive(false);
                }
            }
        }

        if (playerEmotionPortrait != null)
        {
            playerEmotionPortrait.HidePortrait();
        }

        if (playerLock != null)
        {
            playerLock.UnlockPlayer();
        }

        if (currentEmotionController != null)
        {
            currentEmotionController.SetEmotion(
                NPCEmotion.Neutral);
        }

        currentDialogue = null;
        currentEmotionController = null;
        currentNode = -1;

        Debug.Log(
            "DialogueManager: Dialog beendet.");
    }
}