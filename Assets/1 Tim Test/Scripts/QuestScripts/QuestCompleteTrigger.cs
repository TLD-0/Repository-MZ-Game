using UnityEngine;

public class QuestCompleteTrigger : MonoBehaviour
{
    public int questID;

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("QuestObejctTrigger funktioniert");

        if(!other.CompareTag("Player"))
            return;

        if (!IsQuestActive())
        return;

            Debug.Log("Quest " + questID + " abgeschlossen");

        switch(questID)
        {
            case 1:
                QuestManager.Instance.quest1 =
                    QuestStatus.Completed;

                    Debug.Log("Quest1 Status = " + QuestManager.Instance.quest1);

                break;

            case 2:
                QuestManager.Instance.quest2 =
                    QuestStatus.Completed;

                    Debug.Log("Quest1 Status = " + QuestManager.Instance.quest2);

                break;

            case 3:
                QuestManager.Instance.quest3 =
                    QuestStatus.Completed;

                    Debug.Log("Quest1 Status = " + QuestManager.Instance.quest3);

                break;

            case 4:
                QuestManager.Instance.quest4 =
                    QuestStatus.Completed;

                    Debug.Log("Quest1 Status = " + QuestManager.Instance.quest4);

                break;
        }

        Destroy(gameObject);
    }

    private bool IsQuestActive()
    {
        if (QuestManager.Instance == null)
            return false;

        switch (questID)
        {
            case 1: return QuestManager.Instance.quest1 == QuestStatus.Active;
            case 2: return QuestManager.Instance.quest2 == QuestStatus.Active;
            case 3: return QuestManager.Instance.quest3 == QuestStatus.Active;
            case 4: return QuestManager.Instance.quest4 == QuestStatus.Active;
        }

        return false;
    }
}