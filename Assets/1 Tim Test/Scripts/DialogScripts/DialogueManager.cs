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

    public void StartDialogue(
        DialogueData dialogue,
        Transform cameraPoint)
    {
        currentDialogue = dialogue;

        currentNode = 0;

        dialogueActive = true;

        if(playerMovement != null)
        {
            playerMovement.enabled = false;
        }

        if(mouseLook != null)
        {
            mouseLook.enabled = false;
        }

        dialoguePanel.SetActive(true);

        playerLock.LockPlayer(cameraPoint);

        ShowNode();
    }

    void ShowNode()
    {
        Debug.Log("Anzahl Choices: " +
        currentDialogue.nodes[currentNode].choices.Count);

        DialogueNode node =
        currentDialogue.nodes[currentNode];

        dialogueText.text =
        node.dialogueText;

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

        playerLock.UnlockPlayer();

        dialoguePanel.SetActive(false);

        for(int i = 0; i < choicePanels.Length; i++)
        {
            choicePanels[i].SetActive(false);
        }

        if(playerMovement != null)
        {
            playerMovement.enabled = true;
        }

        if(mouseLook != null)
        {
            mouseLook.enabled = true;
        }
    }
}
