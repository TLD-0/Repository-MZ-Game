using UnityEngine;

public class NPCDialogue : MonoBehaviour
{
    public DialogueData dialogue;

    public Transform playerPoint;
    public Transform cameraPoint;
    public NPCEmotionController emotionController;

    public void StartNPCDialogue()
    {
        DialogueManager.Instance.StartDialogue(
            dialogue,
            playerPoint,
            cameraPoint,
            emotionController);
    }
}