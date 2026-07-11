using UnityEngine;

public class SequenceQuestChecker : MonoBehaviour
{
    [Header("Quest")]
    public int questID;

    [Header("Richtige Reihenfolge")]
    public int[] correctSequence;

    public void CheckSequence()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError("SequenceQuestChecker: SequenceChoiceManager fehlt.");
            return;
        }

        bool isCorrect = SequenceChoiceManager.Instance.MatchesSequence(correctSequence);

        if (isCorrect)
        {
            CompleteQuest();
            Debug.Log("Richtige Eingabe. Quest " + SequenceChoiceManager.Instance.GetSequenceText() + " abgeschlossen.");
        }
        else
        {
            Debug.Log("Falsche Eingabe: " + SequenceChoiceManager.Instance.GetSequenceText());
        }
    }

    private void CompleteQuest()
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError("SequenceQuestChecker: QuestManager fehlt.");
            return;
        }

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
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 6:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 7:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 8:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 9:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 10:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 11:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 12:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 13:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 14:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;
            case 15:
                QuestManager.Instance.quest4 = QuestStatus.Completed;
                break;

            default:
                Debug.LogError("SequenceQuestChecker: Ungültige Quest-ID: " + questID);
                break;
        }
    }
}