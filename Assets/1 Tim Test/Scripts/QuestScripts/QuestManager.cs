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
}