using UnityEngine;

public class NPCStoryRequirement : MonoBehaviour
{
    [Header("Benötigte Quests")]
    [Tooltip(
        "Diese Quests müssen abgeschlossen sein, " +
        "bevor der NPC angesprochen werden kann."
    )]
    [SerializeField]
    private int[] requiredCompletedQuestIDs;

    [Tooltip(
        "Aktiviert: Alle eingetragenen Quests müssen abgeschlossen sein. " +
        "Deaktiviert: Eine der eingetragenen Quests reicht."
    )]
    [SerializeField]
    private bool requireAll = true;

    public bool IsUnlocked()
    {
        if (requiredCompletedQuestIDs == null ||
            requiredCompletedQuestIDs.Length == 0)
        {
            return true;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogWarning(
                "NPCStoryRequirement: QuestManager fehlt.",
                this);

            return false;
        }

        if (requireAll)
        {
            for (int i = 0;
                 i < requiredCompletedQuestIDs.Length;
                 i++)
            {
                if (!QuestManager.Instance.IsQuestCompleted(
                        requiredCompletedQuestIDs[i]))
                {
                    return false;
                }
            }

            return true;
        }

        for (int i = 0;
             i < requiredCompletedQuestIDs.Length;
             i++)
        {
            if (QuestManager.Instance.IsQuestCompleted(
                    requiredCompletedQuestIDs[i]))
            {
                return true;
            }
        }

        return false;
    }
}