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

    public bool IsQuestCompleted(int questID)
    {
        switch (questID)
        {
            case 1:
                return quest1 == QuestStatus.Completed;

            case 2:
                return quest2 == QuestStatus.Completed;

            case 3:
                return quest3 == QuestStatus.Completed;

            case 4:
                return quest4 == QuestStatus.Completed;

            case 5:
                return quest5 == QuestStatus.Completed;

            case 6:
                return quest6 == QuestStatus.Completed;

            case 7:
                return quest7 == QuestStatus.Completed;

            case 8:
                return quest8 == QuestStatus.Completed;

            case 9:
                return quest9 == QuestStatus.Completed;

            case 10:
                return quest10 == QuestStatus.Completed;

            case 11:
                return quest11 == QuestStatus.Completed;

            case 12:
                return quest12 == QuestStatus.Completed;

            case 13:
                return quest13 == QuestStatus.Completed;

            case 14:
                return quest14 == QuestStatus.Completed;

            case 15:
                return quest15 == QuestStatus.Completed;

            default:
                Debug.LogError(
                    "QuestManager: Ungültige Quest-ID: " +
                    questID);

                return false;
        }
    }
}