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

    [Header("Camera")]

    public Camera playerCamera;

    [Header("Player")]

    public PlayerLock playerLock;

    public GameObject player;

    public MonoBehaviour playerMovement;

    public MonoBehaviour mouseLook;

    private DialogueData currentDialogue;

    private int currentNode;

    private bool dialogueActive;

    private void Awake()
    {
        Instance = this;
    }

/*
    private void Update()
    {
        if (!dialogueActive)
            return;

            if (Input.GetKeyDown(KeyCode.Escape))
            {
                EndDialogue();
            }

        for (int i = 0; i < choiceTexts.Length; i++)
        {
            if (Input.GetKeyDown((KeyCode)((int)KeyCode.Alpha1 + i)))
            {
                SelectChoice(i);
            }
        }
    }
*/

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Debug.Log("ESC erkannt. dialogueActive = " + dialogueActive);

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
        Transform cameraPoint)
    {
        currentDialogue = dialogue;

        if (dialogue == null || dialogue.nodes == null || dialogue.nodes.Count == 0)
        {
            Debug.LogError("DialogueManager: Dieser NPC hat keine gültigen Dialogue Nodes.");
            return;
        }

        currentNode = 0;

        dialogueActive = true;

        dialoguePanel.SetActive(true);

        if (playerLock != null)
        {
            playerLock.LockPlayer(playerPoint, cameraPoint);
        }
        else
        {
            Debug.LogError("DialogueManager: PlayerLock ist nicht zugewiesen.");
            return;
        }

        ShowNode();
    }

    void ShowNode()
    {
        if (currentDialogue == null)
        {
            Debug.LogError("DialogueManager: currentDialogue ist null.");
            return;
        }

        if (currentNode < 0 || currentNode >= currentDialogue.nodes.Count)
        {
            Debug.LogError("DialogueManager: Ungültiger Node: " + currentNode);
            return;
        }

        DialogueNode node = currentDialogue.nodes[currentNode];

        if (dialogueText == null)
        {
            Debug.LogError("DialogueManager: Dialogue Text ist nicht zugewiesen.");
            return;
        }

        dialogueText.text = node.dialogueText;

        Debug.Log("Dialogtext wird geschrieben auf: " +
            dialogueText.gameObject.name +
            " | Inhalt: " + dialogueText.text);

            for (int i = 0; i < choiceTexts.Length; i++)
            {
                if (i < node.choices.Count)
                {
                    choicePanels[i].SetActive(true);
                    choiceTexts[i].gameObject.SetActive(true);

                    Debug.Log("Choice Text: " + node.choices[i].answerText);

                    choiceTexts[i].text =
                        (i + 1) + ". " +
                        node.choices[i].answerText;

                    Debug.Log("TMP Inhalt: " + choiceTexts[i].text);
                }
                else
                {
                    choicePanels[i].SetActive(false);
                    choiceTexts[i].gameObject.SetActive(false);
                }
            }
    


        for(int i = 0; i < choiceTexts.Length; i++)
        {
            Debug.Log(
                choiceTexts[i].name +
                " aktiv: " +
                choiceTexts[i].gameObject.activeSelf
            );
        }
    }

    void SelectChoice(int index)
    {
        DialogueNode node =
            currentDialogue.nodes[currentNode];

        if (index >= node.choices.Count)
            return;

        int nextNode =
            node.choices[index].nextNode;

        if (nextNode == -1)
        {
            EndDialogue();
            return;
        }

        currentNode = nextNode;

        ShowNode();
    }

    public void EndDialogue()
    {
        dialogueActive = false;

        Debug.Log("EndDialogue wurde aufgerufen");

        if (playerLock != null)
        {
            playerLock.UnlockPlayer();
        }
        else
        {
            Debug.LogError("DialogueManager: Player Lock ist nicht zugewiesen.");
        }

        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(false);
        }
        else
        {
            Debug.LogError("DialogueManager: Dialogue Panel ist nicht zugewiesen.");
        }

        for (int i = 0; i < choicePanels.Length; i++)
        {
            if (choicePanels[i] != null)
            {
                choicePanels[i].SetActive(false);
            }
            else
            {
                Debug.LogError(
                    "DialogueManager: Choice Panel Element " + i +
                    " ist nicht zugewiesen.");
            }
        }

        if (playerLock != null)
        {
            playerLock.UnlockPlayer();
        }
    }
}
