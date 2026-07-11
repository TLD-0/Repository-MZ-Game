using UnityEngine;

public class QuestInteractObject : MonoBehaviour
{
    [Header("Quest")]
    public int questID;

    [Header("Teleport")]
    public Transform destination;

    public void Interact()
    {
        if (destination == null)
        {
            Debug.LogError("QuestInteractObject: Destination wurde nicht zugewiesen.");
            return;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError("QuestManager wurde nicht gefunden.");
            return;
        }

        if (!IsQuestActive())
        {
            Debug.Log("Quest " + questID + " ist noch nicht aktiv.");
            return;
        }

        // Objekt an seinen neuen Ort bewegen
        transform.position = destination.position;
        transform.rotation = destination.rotation;

        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 = QuestStatus.Completed;
                break;

            case 2:
                QuestManager.Instance.quest2 = QuestStatus.Completed;
                break;

            case 3:
                QuestManager.Instance.quest3 = QuestStatus.Completed;
                break;

            case 4:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;

            case 5:
                QuestManager.Instance.quest5 = QuestStatus.Completed;
                break;

            case 6:
                QuestManager.Instance.quest6 = QuestStatus.Completed;
                break;

            case 7:
                QuestManager.Instance.quest7 = QuestStatus.Completed;
                break;

            case 8:
                QuestManager.Instance.quest8 = QuestStatus.Completed;
                break;

            case 9:
                QuestManager.Instance.quest9 = QuestStatus.Completed;
                break;

            case 10:
                QuestManager.Instance.quest10 = QuestStatus.Completed;
                break;

            case 11:
                QuestManager.Instance.quest11 = QuestStatus.Completed;
                break;

            case 12:
                QuestManager.Instance.quest12 = QuestStatus.Completed;
                break;

            case 13:
                QuestManager.Instance.quest13 = QuestStatus.Completed;
                break;

            case 14:
                QuestManager.Instance.quest14 = QuestStatus.Completed;
                break;

            case 15:
                QuestManager.Instance.quest15 = QuestStatus.Completed;
                break;

            default:
                Debug.LogError("Ungültige Quest-ID: " + questID);
                return;
        }

        Debug.Log("Quest " + questID + " abgeschlossen.");
    }
    private bool IsQuestActive()
    {
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