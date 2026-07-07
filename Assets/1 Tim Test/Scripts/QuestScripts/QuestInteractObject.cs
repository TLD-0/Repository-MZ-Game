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
        }

        return false;
    }
}