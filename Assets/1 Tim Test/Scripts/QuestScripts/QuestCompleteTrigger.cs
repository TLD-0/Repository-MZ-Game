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
                QuestManager.Instance.quest1 = QuestStatus.Completed;
                Debug.Log("Quest1 Status = " + QuestManager.Instance.quest1);
                break;

            case 2:
                QuestManager.Instance.quest2 = QuestStatus.Completed;
                Debug.Log("Quest2 Status = " + QuestManager.Instance.quest2);
                break;

            case 3:
                QuestManager.Instance.quest3 = QuestStatus.Completed;
                Debug.Log("Quest3 Status = " + QuestManager.Instance.quest3);
                break;

            case 4:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                Debug.Log("Quest4 Status = " + QuestManager.Instance.quest4);
                break;

            case 5:
                QuestManager.Instance.quest5 = QuestStatus.Completed;
                Debug.Log("Quest5 Status = " + QuestManager.Instance.quest5);
                break;

            case 6:
                QuestManager.Instance.quest6 = QuestStatus.Completed;
                Debug.Log("Quest6 Status = " + QuestManager.Instance.quest6);
                break;

            case 7:
                QuestManager.Instance.quest7 = QuestStatus.Completed;
                Debug.Log("Quest7 Status = " + QuestManager.Instance.quest7);
                break;

            case 8:
                QuestManager.Instance.quest8 = QuestStatus.Completed;
                Debug.Log("Quest8 Status = " + QuestManager.Instance.quest8);
                break;

            case 9:
                QuestManager.Instance.quest9 = QuestStatus.Completed;
                Debug.Log("Quest9 Status = " + QuestManager.Instance.quest9);
                break;

            case 10:
                QuestManager.Instance.quest10 = QuestStatus.Completed;
                Debug.Log("Quest10 Status = " + QuestManager.Instance.quest10);
                break;

            case 11:
                QuestManager.Instance.quest11 = QuestStatus.Completed;
                Debug.Log("Quest11 Status = " + QuestManager.Instance.quest11);
                break;

            case 12:
                QuestManager.Instance.quest12 = QuestStatus.Completed;
                Debug.Log("Quest12 Status = " + QuestManager.Instance.quest12);
                break;

            case 13:
                QuestManager.Instance.quest13 = QuestStatus.Completed;
                Debug.Log("Quest13 Status = " + QuestManager.Instance.quest13);
                break;

            case 14:
                QuestManager.Instance.quest14 = QuestStatus.Completed;
                Debug.Log("Quest14 Status = " + QuestManager.Instance.quest14);
                break;

            case 15:
                QuestManager.Instance.quest15 = QuestStatus.Completed;
                Debug.Log("Quest15 Status = " + QuestManager.Instance.quest15);
                break;

            default:
                Debug.LogError("Ungültige Quest-ID: " + questID);
                return;
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
            case 5: return QuestManager.Instance.quest5 == QuestStatus.Active;
            case 6: return QuestManager.Instance.quest6 == QuestStatus.Active;
            case 7: return QuestManager.Instance.quest7 == QuestStatus.Active;
            case 8: return QuestManager.Instance.quest8 == QuestStatus.Active;
            case 9: return QuestManager.Instance.quest9 == QuestStatus.Active;
            case 10: return QuestManager.Instance.quest10 == QuestStatus.Active;
            case 11: return QuestManager.Instance.quest11 == QuestStatus.Active;
            case 12: return QuestManager.Instance.quest12 == QuestStatus.Active;
            case 13: return QuestManager.Instance.quest13 == QuestStatus.Active;
            case 14: return QuestManager.Instance.quest14 == QuestStatus.Active;
            case 15: return QuestManager.Instance.quest15 == QuestStatus.Active;
        }

        return false;
    }
}