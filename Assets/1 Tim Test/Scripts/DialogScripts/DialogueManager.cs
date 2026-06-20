using UnityEngine;
using TMPro;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance;

    [Header("UI")]

    public GameObject dialoguePanel;

    public TMP_Text dialogueText;

    public TMP_Text[] choiceTexts;

    [Header("Camera")]

    public Camera playerCamera;

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

        dialoguePanel.SetActive(true);

        playerCamera.transform.position =
            cameraPoint.position;

        playerCamera.transform.rotation =
            cameraPoint.rotation;

        ShowNode();
    }

    void ShowNode()
    {
        DialogueNode node =
            currentDialogue.nodes[currentNode];

        dialogueText.text =
            node.dialogueText;

        for (int i = 0; i < choiceTexts.Length; i++)
        {
            if (i < node.choices.Count)
            {
                choiceTexts[i].gameObject.SetActive(true);

                choiceTexts[i].text =
                    (i + 1) + ". " +
                    node.choices[i].answerText;
            }
            else
            {
                choiceTexts[i].gameObject.SetActive(false);
            }
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

        dialoguePanel.SetActive(false);
    }
}
