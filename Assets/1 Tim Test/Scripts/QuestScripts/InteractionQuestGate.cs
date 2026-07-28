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
        /*
         * Keine Quest eingetragen:
         * Die Interaktion ist immer erlaubt.
         */
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

        /*
         * Alle eingetragenen Quests müssen Completed sein.
         */
        for (int i = 0;
             i < requiredCompletedQuestIDs.Count;
             i++)
        {
            int questID =
                requiredCompletedQuestIDs[i];

            if (!IsQuestCompleted(questID))
            {
                return false;
            }
        }

        return true;
    }

    private bool IsQuestCompleted(
        int questID)
    {
        switch (questID)
        {
            case 1:
                return QuestManager.Instance.quest1 ==
                       QuestStatus.Completed;

            case 2:
                return QuestManager.Instance.quest2 ==
                       QuestStatus.Completed;

            case 3:
                return QuestManager.Instance.quest3 ==
                       QuestStatus.Completed;

            case 4:
                return QuestManager.Instance.quest4 ==
                       QuestStatus.Completed;

            case 5:
                return QuestManager.Instance.quest5 ==
                       QuestStatus.Completed;

            case 6:
                return QuestManager.Instance.quest6 ==
                       QuestStatus.Completed;

            case 7:
                return QuestManager.Instance.quest7 ==
                       QuestStatus.Completed;

            case 8:
                return QuestManager.Instance.quest8 ==
                       QuestStatus.Completed;

            case 9:
                return QuestManager.Instance.quest9 ==
                       QuestStatus.Completed;

            case 10:
                return QuestManager.Instance.quest10 ==
                       QuestStatus.Completed;

            case 11:
                return QuestManager.Instance.quest11 ==
                       QuestStatus.Completed;

            case 12:
                return QuestManager.Instance.quest12 ==
                       QuestStatus.Completed;

            case 13:
                return QuestManager.Instance.quest13 ==
                       QuestStatus.Completed;

            case 14:
                return QuestManager.Instance.quest14 ==
                       QuestStatus.Completed;

            case 15:
                return QuestManager.Instance.quest15 ==
                       QuestStatus.Completed;

            default:
                Debug.LogError(
                    "InteractionQuestGate: Ungültige Quest-ID: " +
                    questID,
                    this);

                return false;
        }
    }
}