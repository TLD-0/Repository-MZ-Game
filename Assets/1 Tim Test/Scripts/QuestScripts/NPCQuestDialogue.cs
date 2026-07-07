using UnityEngine;

public class NPCQuestDialogue : MonoBehaviour
{
    public DialogueData startDialogue;
    public DialogueData activeDialogue;
    public DialogueData completedDialogue;

    [Header("Dialog Positionen")]
    public Transform playerPoint;
    public Transform cameraPoint;

    public int questID;

    public void StartNPCDialogue()
    {
        QuestStatus status = GetQuestStatus();

        if (status == QuestStatus.NotStarted)
        {
            DialogueManager.Instance.StartDialogue(
                startDialogue,
                playerPoint,
                cameraPoint);
        }
        else if (status == QuestStatus.Active)
        {
            DialogueManager.Instance.StartDialogue(
                activeDialogue,
                playerPoint,
                cameraPoint);
        }
        else if (status == QuestStatus.Completed)
        {
            DialogueManager.Instance.StartDialogue(
                completedDialogue,
                playerPoint,
                cameraPoint);
        }
    }

    QuestStatus GetQuestStatus()
    {
        switch (questID)
        {
            case 1: return QuestManager.Instance.quest1;
            case 2: return QuestManager.Instance.quest2;
            case 3: return QuestManager.Instance.quest3;
            case 4: return QuestManager.Instance.quest4;
        }

        return QuestStatus.NotStarted;
    }
}
