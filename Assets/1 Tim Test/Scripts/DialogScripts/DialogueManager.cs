using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance;

    [Header("UI")]
    [SerializeField]
    private GameObject dialoguePanel;

    [SerializeField]
    private TMP_Text dialogueText;

    [Tooltip(
        "Alte, feste Antwortfelder. Können leer bleiben, " +
        "wenn das dynamische Choice-System verwendet wird."
    )]
    [SerializeField]
    private GameObject[] choicePanels;

    [Tooltip(
        "Alte, feste Antworttexte. Werden für die dynamischen " +
        "Antworten und die Tastatureingabe nicht mehr benötigt."
    )]
    [SerializeField]
    private TMP_Text[] choiceTexts;

    [SerializeField]
    private DialogueTextScroller dialogueTextScroller;

    [Header("Dynamische Antworten")]
    [SerializeField]
    private Transform choiceContainer;

    [SerializeField]
    private GameObject choicePrefab;

    [Header("Spieler")]
    [SerializeField]
    private PlayerLock playerLock;

    [Header("Spielerportrait")]
    [SerializeField]
    private PlayerEmotionPortrait playerEmotionPortrait;

    private DialogueData currentDialogue;

    /*
     * Der NPC, mit dem der Dialog gestartet wurde.
     * Er wird bei Target Mode = CurrentSpeaker verwendet.
     */
    private NPCEmotionController currentEmotionController;

    /*
     * Speichert alle NPCs, deren Emotion innerhalb des
     * aktuellen Dialogs verändert wurde.
     */
    private readonly HashSet<NPCEmotionController>
        changedEmotionControllers =
            new HashSet<NPCEmotionController>();

    private int currentNode = -1;
    private bool dialogueActive;
    private bool isProcessingChoice;

    public bool IsDialogueActive
    {
        get { return dialogueActive; }
    }

    private void Awake()
    {
        if (Instance != null &&
            Instance != this)
        {
            Debug.LogWarning(
                "DialogueManager: Es existiert bereits ein " +
                "DialogueManager. Die zusätzliche Komponente " +
                "wird entfernt.",
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
        DialogueNode node =
            GetCurrentNode();

        if (node == null ||
            node.choices == null ||
            isProcessingChoice)
        {
            return;
        }

        /*
         * Antworten 1 bis 9:
         * Tasten 1 bis 9
         *
         * Antwort 10:
         * Taste 0
         */
        int keyboardChoiceCount =
            Mathf.Min(node.choices.Count, 10);

        for (int i = 0;
             i < keyboardChoiceCount;
             i++)
        {
            if (WasChoiceKeyPressed(i))
            {
                SelectChoice(i);
                return;
            }
        }
    }

    private bool WasChoiceKeyPressed(
        int choiceIndex)
    {
        if (choiceIndex < 0 ||
            choiceIndex > 9)
        {
            return false;
        }

        if (choiceIndex == 9)
        {
            return
                Input.GetKeyDown(KeyCode.Alpha0) ||
                Input.GetKeyDown(KeyCode.Keypad0);
        }

        KeyCode alphaKey =
            (KeyCode)(
                (int)KeyCode.Alpha1 +
                choiceIndex);

        KeyCode keypadKey =
            (KeyCode)(
                (int)KeyCode.Keypad1 +
                choiceIndex);

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
         * Ein laufender Dialog wird sauber beendet,
         * bevor ein neuer gestartet wird.
         *
         * Das wird beispielsweise bei den Ergebnisdialogen
         * der Telefonquest benötigt.
         */
        if (dialogueActive)
        {
            EndDialogue();
        }

        changedEmotionControllers.Clear();

        currentDialogue = dialogue;
        currentEmotionController =
            emotionController;

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
                "DialogueManager: Kein gültiger " +
                "Dialog zugewiesen.");

            return false;
        }

        if (dialoguePanel == null)
        {
            Debug.LogError(
                "DialogueManager: Dialogue Panel " +
                "wurde nicht zugewiesen.");

            return false;
        }

        if (dialogueText == null &&
            dialogueTextScroller == null)
        {
            Debug.LogError(
                "DialogueManager: Weder Dialogue Text " +
                "noch Dialogue Text Scroller wurde zugewiesen.");

            return false;
        }

        if (choiceContainer == null)
        {
            Debug.LogError(
                "DialogueManager: Choice Container " +
                "wurde nicht zugewiesen.");

            return false;
        }

        if (choicePrefab == null)
        {
            Debug.LogError(
                "DialogueManager: Choice Prefab " +
                "wurde nicht zugewiesen.");

            return false;
        }

        if (playerLock == null)
        {
            Debug.LogError(
                "DialogueManager: PlayerLock " +
                "wurde nicht zugewiesen.");

            return false;
        }

        if (playerPoint == null)
        {
            Debug.LogError(
                "DialogueManager: Player Point " +
                "wurde nicht zugewiesen.");

            return false;
        }

        if (cameraPoint == null)
        {
            Debug.LogError(
                "DialogueManager: Camera Point " +
                "wurde nicht zugewiesen.");

            return false;
        }

        return true;
    }

    private void ShowNode()
    {
        DialogueNode node =
            GetCurrentNode();

        if (node == null)
        {
            Debug.LogError(
                "DialogueManager: Der aktuelle " +
                "Dialog-Node ist ungültig.");

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
            currentNode >=
            currentDialogue.nodes.Count)
        {
            return null;
        }

        return
            currentDialogue.nodes[currentNode];
    }

    private void ApplyPlayerEmotion(
        DialogueNode node)
    {
        /*
         * Ist Change Player Emotion deaktiviert,
         * bleibt die vorherige Emotion erhalten.
         */
        if (!node.changePlayerEmotion)
        {
            return;
        }

        if (playerEmotionPortrait == null)
        {
            Debug.LogWarning(
                "DialogueManager: Der Node möchte die " +
                "Spieleremotion ändern, aber es wurde kein " +
                "PlayerEmotionPortrait zugewiesen.");

            return;
        }

        playerEmotionPortrait.SetEmotion(
            node.playerEmotion);
    }

    private void ApplyNPCEmotions(
        DialogueNode node)
    {
        /*
        * Kein Eintrag:
        * Alle vorherigen NPC-Emotionen bleiben bestehen.
        */
        if (node.emotionChanges == null ||
            node.emotionChanges.Count == 0)
        {
            return;
        }

        foreach (NPCEmotionChange change
                in node.emotionChanges)
        {
            if (change == null)
            {
                continue;
            }

            /*
            * Change Emotion nicht aktiviert:
            * vorheriger Kopf bleibt bestehen.
            */
            if (!change.changeEmotion)
            {
                continue;
            }

            NPCEmotionController targetController =
                ResolveEmotionTarget(change);

            if (targetController == null)
            {
                continue;
            }

            /*
            * Bewusste Rückkehr zum neutralen Kopf.
            */
            if (change.returnToNeutral)
            {
                targetController.ClearEmotion();

                changedEmotionControllers.Add(
                    targetController);

                continue;
            }

            /*
            * Kein Sprite eingetragen:
            * vorherige Emotion bleibt bestehen.
            */
            if (change.emotionSprite == null)
            {
                continue;
            }

            bool emotionChanged =
                targetController.SetEmotionSprite(
                    change.emotionSprite);

            if (emotionChanged)
            {
                changedEmotionControllers.Add(
                    targetController);
            }
        }
    }

    private NPCEmotionController ResolveEmotionTarget(
    NPCEmotionChange change)
    {
        if (change.targetMode ==
            NPCEmotionTargetMode.CurrentSpeaker)
        {
            return currentEmotionController;
        }

        if (change.targetNPCId == NPCId.None)
        {
            Debug.LogWarning(
                "DialogueManager: Specific NPC wurde gewählt, " +
                "aber keine NPC-ID eingetragen.");

            return null;
        }

        bool found =
            NPCEmotionController.TryGetController(
                change.targetNPCId,
                out NPCEmotionController targetController);

        if (!found)
        {
            Debug.LogWarning(
                "DialogueManager: Für NPC " +
                change.targetNPCId +
                " wurde kein aktiver NPCEmotionController gefunden.");

            return null;
        }

        return targetController;
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
         * SetActive(false) entfernt die alten Antworten sofort.
         */
        for (int i =
                 choiceContainer.childCount - 1;
             i >= 0;
             i--)
        {
            GameObject child =
                choiceContainer
                    .GetChild(i)
                    .gameObject;

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
                "DialogueManager: Der aktuelle Node " +
                "besitzt keine Antworten. Der Dialog kann " +
                "mit ESC beendet werden.");

            return;
        }

        for (int i = 0;
             i < node.choices.Count;
             i++)
        {
            int capturedIndex = i;

            DialogueChoice dialogueChoice =
                node.choices[i];

            if (dialogueChoice == null)
            {
                Debug.LogWarning(
                    "DialogueManager: Antwort " +
                    i +
                    " ist leer.");

                continue;
            }

            GameObject choiceObject =
                Instantiate(
                    choicePrefab,
                    choiceContainer);

            DialogueChoiceUI choiceUI =
                choiceObject
                    .GetComponent<DialogueChoiceUI>();

            if (choiceUI == null)
            {
                Debug.LogError(
                    "DialogueManager: Das Choice Prefab " +
                    "besitzt keine DialogueChoiceUI-Komponente.",
                    choiceObject);

                Destroy(choiceObject);
                continue;
            }

            string shortcutText =
                GetShortcutText(i);

            choiceUI.SetText(
                shortcutText +
                ". " +
                dialogueChoice.answerText);

            /*
             * Die dynamisch erzeugte Antwort kann
             * zusätzlich mit der Maus angeklickt werden.
             */
            Button button =
                choiceObject.GetComponent<Button>();

            if (button == null)
            {
                button =
                    choiceObject
                        .GetComponentInChildren<Button>(true);
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
            LayoutRebuilder
                .ForceRebuildLayoutImmediate(
                    containerRect);
        }

        if (node.choices.Count > 10)
        {
            Debug.LogWarning(
                "DialogueManager: Der aktuelle Node besitzt " +
                "mehr als zehn Antworten. Nur die ersten zehn " +
                "können über Zahlentasten gewählt werden. " +
                "Alle Antworten bleiben per Mausklick verfügbar.");
        }
    }

    private string GetShortcutText(
        int choiceIndex)
    {
        if (choiceIndex == 9)
        {
            return "0";
        }

        return
            (choiceIndex + 1).ToString();
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
                "DialogueManager: Ungültiger " +
                "Choice-Index: " +
                index);

            return;
        }

        DialogueChoice choice =
            node.choices[index];

        if (choice == null)
        {
            Debug.LogError(
                "DialogueManager: Die ausgewählte " +
                "Antwort ist leer.");

            return;
        }

        isProcessingChoice = true;

        /*
        * Aktionen der ausgewählten Antwort ausführen.
        */
        ProcessSequenceActions(choice);
        ProcessQuestActions(choice);
        ProcessMoodValueAction(choice);

        /*
        * Eine Teleportantwort beendet den Dialog,
        * entsperrt den Spieler und teleportiert ihn.
        */
        if (ProcessPlayerTeleportAction(choice))
        {
            return;
        }

        /*
        * -1 beendet den Dialog.
        */
        if (choice.nextNode == -1)
        {
            EndDialogue();
            return;
        }

        if (choice.nextNode < 0 ||
            choice.nextNode >=
            currentDialogue.nodes.Count)
        {
            Debug.LogError(
                "DialogueManager: Die Antwort verweist " +
                "auf einen ungültigen nächsten Node: " +
                choice.nextNode);

            EndDialogue();
            return;
        }

        currentNode =
            choice.nextNode;

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
                "DialogueManager: Checks Sequence ist " +
                "aktiviert, aber es wurde kein Sequence " +
                "Checker zugewiesen.");

            return;
        }

        choice.sequenceChecker.CheckSequence();
    }

    private void ProcessQuestActions(
        DialogueChoice choice)
    {
        if (choice.questsToStart != null)
        {
            foreach (QuestStart quest
                     in choice.questsToStart)
            {
                if (quest == null)
                {
                    continue;
                }

                StartQuest(quest.questID);
            }
        }

        if (choice.skipsQuest)
        {
            SkipQuest(
                choice.questIDToSkip);
        }
    }

    private void ProcessMoodValueAction(
    DialogueChoice choice)
    {
        if (choice == null)
        {
            return;
        }

        /*
        * 0 bedeutet:
        * Diese Antwort verändert den MoodValue nicht.
        */
        if (choice.moodValueChange == 0)
        {
            return;
        }

        if (CloudMoodManager.Instance == null)
        {
            Debug.LogError(
                "DialogueManager: Diese Antwort soll den MoodValue " +
                "verändern, aber es wurde kein aktiver " +
                "CloudMoodManager in der Scene gefunden.");

            return;
        }

        CloudMoodManager.Instance.AddMoodValue(
            choice.moodValueChange);

        Debug.Log(
            "DialogueManager: MoodValue wurde durch die " +
            "Dialogentscheidung um " +
            choice.moodValueChange +
            " verändert. Neuer Wert: " +
            CloudMoodManager.Instance.CurrentMoodValue);
    }

    private bool ProcessPlayerTeleportAction(
        DialogueChoice choice)
    {
        if (choice == null ||
            !choice.teleportPlayer)
        {
            return false;
        }

        if (choice.teleportDestination == null)
        {
            Debug.LogError(
                "DialogueManager: Teleport Player ist aktiviert, " +
                "aber es wurde keine Teleport Destination ausgewählt.");

            return false;
        }

        bool destinationFound =
            DialogueTeleportPoint.TryGetDestination(
                choice.teleportDestination,
                out Transform destinationTransform);

        if (!destinationFound)
        {
            Debug.LogError(
                "DialogueManager: Für die Teleport Destination " +
                choice.teleportDestination.name +
                " wurde kein eindeutiger aktiver " +
                "DialogueTeleportPoint in der Scene gefunden.");

            return false;
        }

        /*
        * Der Dialog muss zuerst beendet werden.
        * Dadurch wird PlayerLock aufgehoben und zieht den
        * Spieler nicht wieder zum Dialog-PlayerPoint zurück.
        */
        EndDialogue();

        TeleportPlayerTo(
            destinationTransform);

        return true;
    }

    private void TeleportPlayerTo(
        Transform destination)
    {
        if (destination == null)
        {
            Debug.LogError(
                "DialogueManager: Das Teleportziel ist leer.");

            return;
        }

        if (playerLock == null)
        {
            Debug.LogError(
                "DialogueManager: Der Spieler kann nicht teleportiert " +
                "werden, weil PlayerLock nicht zugewiesen ist.");

            return;
        }

        /*
        * PlayerLock liegt in deinem aktuellen Projekt direkt
        * auf dem zu bewegenden Spielerobjekt.
        */
        Transform playerTransform =
            playerLock.transform;

        /*
        * Nur die horizontale Rotation verwenden.
        * Dadurch wird der Spieler nicht nach oben oder unten geneigt.
        */
        Quaternion destinationRotation =
            Quaternion.Euler(
                0f,
                destination.eulerAngles.y,
                0f);

        Rigidbody playerRigidbody =
            playerTransform.GetComponent<Rigidbody>();

        if (playerRigidbody != null)
        {
            bool wasKinematic =
                playerRigidbody.isKinematic;

            /*
            * Den Rigidbody kurz kontrolliert anhalten,
            * damit keine alte Geschwindigkeit übernommen wird.
            */
            playerRigidbody.isKinematic = true;

            playerRigidbody.linearVelocity =
                Vector3.zero;

            playerRigidbody.angularVelocity =
                Vector3.zero;

            playerTransform.SetPositionAndRotation(
                destination.position,
                destinationRotation);

            playerRigidbody.position =
                destination.position;

            playerRigidbody.rotation =
                destinationRotation;

            Physics.SyncTransforms();

            playerRigidbody.isKinematic =
                wasKinematic;
        }
        else
        {
            playerTransform.SetPositionAndRotation(
                destination.position,
                destinationRotation);

            Physics.SyncTransforms();
        }

        Debug.Log(
            "DialogueManager: Spieler wurde zu " +
            destination.gameObject.name +
            " teleportiert.");
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
                "DialogueManager: QuestManager " +
                "wurde nicht gefunden.");

            return false;
        }

        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 =
                    newStatus;
                break;

            case 2:
                QuestManager.Instance.quest2 =
                    newStatus;
                break;

            case 3:
                QuestManager.Instance.quest3 =
                    newStatus;
                break;

            case 4:
                QuestManager.Instance.quest4 =
                    newStatus;
                break;

            case 5:
                QuestManager.Instance.quest5 =
                    newStatus;
                break;

            case 6:
                QuestManager.Instance.quest6 =
                    newStatus;
                break;

            case 7:
                QuestManager.Instance.quest7 =
                    newStatus;
                break;

            case 8:
                QuestManager.Instance.quest8 =
                    newStatus;
                break;

            case 9:
                QuestManager.Instance.quest9 =
                    newStatus;
                break;

            case 10:
                QuestManager.Instance.quest10 =
                    newStatus;
                break;

            case 11:
                QuestManager.Instance.quest11 =
                    newStatus;
                break;

            case 12:
                QuestManager.Instance.quest12 =
                    newStatus;
                break;

            case 13:
                QuestManager.Instance.quest13 =
                    newStatus;
                break;

            case 14:
                QuestManager.Instance.quest14 =
                    newStatus;
                break;

            case 15:
                QuestManager.Instance.quest15 =
                    newStatus;
                break;

            default:
                Debug.LogError(
                    "DialogueManager: Ungültige " +
                    "Quest-ID: " +
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

        /*
         * Alle NPCs, deren Emotion im Dialog verändert wurde,
         * erhalten die Information, dass der Dialog beendet ist.
         *
         * Ob sie dabei auf Neutral zurückgesetzt werden,
         * entscheidet die Einstellung
         * Reset To Neutral On Dialogue End
         * im jeweiligen NPCEmotionController.
         */
        foreach (NPCEmotionController controller
                 in changedEmotionControllers)
        {
            if (controller != null)
            {
                controller.OnDialogueEnded();
            }
        }

        changedEmotionControllers.Clear();

        currentDialogue = null;
        currentEmotionController = null;
        currentNode = -1;

        Debug.Log(
            "DialogueManager: Dialog beendet.");
    }
}