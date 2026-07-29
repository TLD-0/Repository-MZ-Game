using UnityEngine;

public class QuestManager : MonoBehaviour
{
    public static QuestManager Instance;

    private void Awake()
    {
        Instance = this;
    }

    public QuestStatus quest1 = QuestStatus.NotStarted;
    public QuestStatus quest2 = QuestStatus.NotStarted;
    public QuestStatus quest3 = QuestStatus.NotStarted;
    public QuestStatus quest4 = QuestStatus.NotStarted;
    public QuestStatus quest5 = QuestStatus.NotStarted;
    public QuestStatus quest6 = QuestStatus.NotStarted;
    public QuestStatus quest7 = QuestStatus.NotStarted;
    public QuestStatus quest8 = QuestStatus.NotStarted;
    public QuestStatus quest9 = QuestStatus.NotStarted;
    public QuestStatus quest10 = QuestStatus.NotStarted;
    public QuestStatus quest11 = QuestStatus.NotStarted;
    public QuestStatus quest12 = QuestStatus.NotStarted;
    public QuestStatus quest13 = QuestStatus.NotStarted;
    public QuestStatus quest14 = QuestStatus.NotStarted;
    public QuestStatus quest15 = QuestStatus.NotStarted;

    public QuestStatus GetQuestStatus(
        int questID)
    {
        switch (questID)
        {
            case 1:  return quest1;
            case 2:  return quest2;
            case 3:  return quest3;
            case 4:  return quest4;
            case 5:  return quest5;
            case 6:  return quest6;
            case 7:  return quest7;
            case 8:  return quest8;
            case 9:  return quest9;
            case 10: return quest10;
            case 11: return quest11;
            case 12: return quest12;
            case 13: return quest13;
            case 14: return quest14;
            case 15: return quest15;

            default:
                Debug.LogError(
                    "QuestManager: Ungültige Quest-ID: " +
                    questID);

                return QuestStatus.NotStarted;
        }
    }

    public bool SetQuestStatus(
        int questID,
        QuestStatus status)
    {
        switch (questID)
        {
            case 1:  quest1 = status; break;
            case 2:  quest2 = status; break;
            case 3:  quest3 = status; break;
            case 4:  quest4 = status; break;
            case 5:  quest5 = status; break;
            case 6:  quest6 = status; break;
            case 7:  quest7 = status; break;
            case 8:  quest8 = status; break;
            case 9:  quest9 = status; break;
            case 10: quest10 = status; break;
            case 11: quest11 = status; break;
            case 12: quest12 = status; break;
            case 13: quest13 = status; break;
            case 14: quest14 = status; break;
            case 15: quest15 = status; break;

            default:
                Debug.LogError(
                    "QuestManager: Ungültige Quest-ID: " +
                    questID);

                return false;
        }

        Debug.Log(
            "QuestManager: Quest " +
            questID +
            " wurde auf " +
            status +
            " gesetzt.");

        return true;
    }

    public bool IsQuestActive(
        int questID)
    {
        return GetQuestStatus(questID) ==
            QuestStatus.Active;
    }

    public bool IsQuestCompleted(
        int questID)
    {
        return GetQuestStatus(questID) ==
            QuestStatus.Completed;
    }

    public bool IsQuestSkipped(
        int questID)
    {
        return GetQuestStatus(questID) ==
            QuestStatus.Skipped;
    }

    public bool IsQuestFinished(
        int questID)
    {
        QuestStatus status =
            GetQuestStatus(questID);

        return status == QuestStatus.Completed ||
            status == QuestStatus.Skipped;
    }

    public bool StartQuest(
        int questID)
    {
        return SetQuestStatus(
            questID,
            QuestStatus.Active);
    }

    public bool CompleteQuest(
        int questID)
    {
        return SetQuestStatus(
            questID,
            QuestStatus.Completed);
    }

    public bool SkipQuest(
        int questID)
    {
        return SetQuestStatus(
            questID,
            QuestStatus.Skipped);
    }
}