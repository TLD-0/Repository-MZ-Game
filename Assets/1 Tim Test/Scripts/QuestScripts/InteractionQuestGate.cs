using System.Collections.Generic;
using UnityEngine;

public class InteractionQuestGate : MonoBehaviour
{
    [Header("Benötigte abgeschlossene Quests")]
    [Tooltip(
        "Die Interaktion wird erst erlaubt, wenn alle hier " +
        "eingetragenen Quests den Status Completed besitzen."
    )]
    [SerializeField]
    private List<int> requiredCompletedQuestIDs =
        new List<int>();

    private bool missingQuestManagerWarningShown;

    public bool IsUnlocked()
    {
        if (requiredCompletedQuestIDs == null ||
            requiredCompletedQuestIDs.Count == 0)
        {
            return true;
        }

        if (QuestManager.Instance == null)
        {
            if (!missingQuestManagerWarningShown)
            {
                Debug.LogError(
                    "InteractionQuestGate: QuestManager wurde " +
                    "nicht gefunden.",
                    this);

                missingQuestManagerWarningShown = true;
            }

            return false;
        }

        for (int i = 0;
             i < requiredCompletedQuestIDs.Count;
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
}
