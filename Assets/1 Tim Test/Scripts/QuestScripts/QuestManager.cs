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
}