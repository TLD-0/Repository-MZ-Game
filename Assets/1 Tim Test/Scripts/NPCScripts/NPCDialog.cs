using UnityEngine;

public class NPCDialogue : MonoBehaviour
{
    public DialogueData dialogue;

    public Transform cameraPoint;

    public void StartNPCDialogue()
    {
        DialogueManager.Instance.StartDialogue(
            dialogue,
            cameraPoint);
    }
}