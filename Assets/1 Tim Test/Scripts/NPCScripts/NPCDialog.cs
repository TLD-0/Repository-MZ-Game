using UnityEngine;

public class NPCDialogue : MonoBehaviour
{
    public DialogueData dialogue;

    public Transform playerPoint;
    public Transform cameraPoint;

    [Header("Emotionen")]
    public NPCEmotionController emotionController;

    private void Awake()
    {
        FindEmotionController();
    }

    private void OnValidate()
    {
        FindEmotionController();
    }

    private void FindEmotionController()
    {
        if (emotionController == null)
        {
            emotionController =
                GetComponentInChildren<
                    NPCEmotionController
                >(true);
        }
    }

    public void StartNPCDialogue()
    {
        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "NPCDialogue: DialogueManager wurde nicht gefunden.",
                this);

            return;
        }

        FindEmotionController();

        DialogueManager.Instance.StartDialogue(
            dialogue,
            playerPoint,
            cameraPoint,
            emotionController);
    }
}