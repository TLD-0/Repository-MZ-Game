using UnityEngine;
using TMPro;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance;

    [Header("UI")]
    public GameObject dialoguePanel;
    public TMP_Text dialogueText;
    public GameObject[] choicePanels;
    public TMP_Text[] choiceTexts;

    [Header("Choices")]
    public Transform choiceContainer;
    public GameObject choicePrefab;

    [Header("Player")]
    public PlayerLock playerLock;
    private DialogueData currentDialogue;
    private int currentNode;
    private bool dialogueActive;

    private NPCEmotionController currentEmotionController;

    private void Awake()
    {
        Instance = this;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (dialogueActive)
            {
                EndDialogue();
                return;
            }
        }

        if (!dialogueActive)
            return;

        for (int i = 0; i < choiceTexts.Length; i++)
        {
            if (Input.GetKeyDown((KeyCode)((int)KeyCode.Alpha1 + i)))
            {
                SelectChoice(i);
            }
        }
    }

    public void StartDialogue(
    DialogueData dialogue,
    Transform playerPoint,
    Transform cameraPoint,
    NPCEmotionController emotionController)
    {
        if (dialogue == null ||
            dialogue.nodes == null ||
            dialogue.nodes.Count == 0)
        {
            Debug.LogError(
                "DialogueManager: Kein gültiger Dialog zugewiesen.");
            return;
        }

        if (playerLock == null)
        {
            Debug.LogError(
                "DialogueManager: PlayerLock ist nicht zugewiesen.");
            return;
        }

        currentDialogue = dialogue;
        currentEmotionController = emotionController;
        currentNode = 0;
        dialogueActive = true;

        dialoguePanel.SetActive(true);

        playerLock.LockPlayer(playerPoint, cameraPoint);

        ShowNode();
    }

    void ClearChoices()
    {
        foreach (Transform child in choiceContainer)
        {
            Destroy(child.gameObject);
        }
    }

    void CreateChoices(DialogueNode node)
    {
        for (int i = 0; i < node.choices.Count; i++)
        {
            GameObject choice =
                Instantiate(choicePrefab, choiceContainer);

            DialogueChoiceUI ui =
                choice.GetComponent<DialogueChoiceUI>();

            ui.SetText(
                (i + 1) + ". " +
                node.choices[i].answerText);
        }
    }

    private void ShowNode()
    {
        if (currentDialogue == null)
            return;

        if (currentNode < 0 ||
            currentNode >= currentDialogue.nodes.Count)
        {
            Debug.LogError(
                "DialogueManager: Ungültiger Dialog-Node: " +
                currentNode);
            return;
        }

        DialogueNode node = currentDialogue.nodes[currentNode];

        if (currentEmotionController != null)
        {
            foreach (NPCEmotionChange change in node.emotionChanges)
            {
                if(change.targetNPC != null)
                {
                    change.targetNPC.SetEmotion(change.emotion);
                }
            }
        }

        dialogueText.text = node.dialogueText;

        ClearChoices();
        CreateChoices(node);
/*
        for (int i = 0; i < choiceTexts.Length; i++)
        {
            bool hasChoice = i < node.choices.Count;

            if (choicePanels[i] != null)
                choicePanels[i].SetActive(hasChoice);

            if (choiceTexts[i] != null)
            {
                choiceTexts[i].gameObject.SetActive(hasChoice);

                if (hasChoice)
                {
                    choiceTexts[i].text =
                        (i + 1) + ". " +
                        node.choices[i].answerText;
                }
            }
        }
*/
    }

    private void SelectChoice(int index)
    {
        DialogueNode node = currentDialogue.nodes[currentNode];

        if (index < 0 || index >= node.choices.Count)
            return;

        DialogueChoice choice = node.choices[index];

        if (choice.addsSequenceValue)
        {
            if (SequenceChoiceManager.Instance == null)
            {
                Debug.LogError(
                "DialogueManager: SequenceChoiceManager wurde nicht gefunden.");
            }
            else
            {
                SequenceChoiceManager.Instance.AddValue(choice.sequenceValue);
            }
        }
        if (choice.checksSequence)
        {
            if (choice.sequenceChecker == null)
            {
                Debug.LogError("DialogueManager: Sequence Checker wurde nicht zugewiesen.");
            }
            else
            {
                choice.sequenceChecker.CheckSequence();
            }
        }

        // Entscheidung führt Quest-Aktionen direkt aus.
        foreach(QuestStart quest in choice.questsToStart)
        {
            StartQuest(quest.questID);
        }

        if (choice.skipsQuest)
        {
            SkipQuest(choice.questIDToSkip);
        }

        if (choice.nextNode == -1)
        {
            EndDialogue();
            return;
        }

        currentNode = choice.nextNode;
        ShowNode();
    }

    private void StartQuest(int questID)
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "DialogueManager: QuestManager wurde nicht gefunden.");
            return;
        }

        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 = QuestStatus.Active;
                break;

            case 2:
                QuestManager.Instance.quest2 = QuestStatus.Active;
                break;

            case 3:
                QuestManager.Instance.quest3 = QuestStatus.Active;
                break;

            case 4:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;

            case 5:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 6:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 7:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 8:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 9:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 10:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 11:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 12:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 13:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 14:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;
                
            case 15:
                QuestManager.Instance.quest4 = QuestStatus.Active;
                break;

            default:
                Debug.LogError(
                    "DialogueManager: Ungültige Quest-ID: " +
                    questID);
                return;
        }

        Debug.Log("Quest " + questID + " wurde aktiviert.");
    }

    private void SkipQuest(int questID)
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError("DialogueManager: QuestManager wurde nicht gefunden.");
            return;
        }

        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 = QuestStatus.Skipped;
                break;

            case 2:
                QuestManager.Instance.quest2 = QuestStatus.Skipped;
                break;

            case 3:
                QuestManager.Instance.quest3 = QuestStatus.Skipped;
                break;

            case 4:
                QuestManager.Instance.quest4 = QuestStatus.Skipped;
                break;

            case 5:
                QuestManager.Instance.quest5 = QuestStatus.Skipped;
                break;

            case 6:
                QuestManager.Instance.quest6 = QuestStatus.Skipped;
                break;

            case 7:
                QuestManager.Instance.quest7 = QuestStatus.Skipped;
                break;

            case 8:
                QuestManager.Instance.quest8 = QuestStatus.Skipped;
                break;

            case 9:
                QuestManager.Instance.quest9 = QuestStatus.Skipped;
                break;

            case 10:
                QuestManager.Instance.quest10 = QuestStatus.Skipped;
                break;

            case 11:
                QuestManager.Instance.quest11 = QuestStatus.Skipped;
                break;

            case 12:
                QuestManager.Instance.quest12 = QuestStatus.Skipped;
                break;

            case 13:
                QuestManager.Instance.quest13 = QuestStatus.Skipped;
                break;

            case 14:
                QuestManager.Instance.quest14 = QuestStatus.Skipped;
                break;

            case 15:
                QuestManager.Instance.quest15 = QuestStatus.Skipped;
                break;

            default:
                Debug.LogError(
                    "DialogueManager: Ungültige Quest-ID zum Überspringen: " +
                    questID);
                return;
        }

        Debug.Log("Quest " + questID + " wurde übersprungen.");
    }

    public void EndDialogue()
    {
        dialogueActive = false;

        if (dialoguePanel != null)
            dialoguePanel.SetActive(false);
            ClearChoices();
/*
        for (int i = 0; i < choicePanels.Length; i++)
        {
            if (choicePanels[i] != null)
                choicePanels[i].SetActive(false);
        }
*/
        if (playerLock != null)
        {
            playerLock.UnlockPlayer();
        }

        if (currentEmotionController != null)
        {
            currentEmotionController.SetEmotion(NPCEmotion.Neutral);
        }
        currentEmotionController = null;
    }
}