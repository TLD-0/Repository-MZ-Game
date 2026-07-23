using UnityEngine;

public class SequenceQuestChecker : MonoBehaviour
{
    [Header("Quest")]
    [Tooltip("Die ID der Quest, die abgeschlossen werden soll.")]
    [Range(1, 15)]
    public int questID = 1;

    [Header("Richtige Reihenfolge")]
    [Tooltip("Die Werte müssen genau in dieser Reihenfolge eingegeben werden.")]
    public int[] correctSequence;

    public bool CheckSequence()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "SequenceQuestChecker: SequenceChoiceManager fehlt.");
            return false;
        }

        if (correctSequence == null || correctSequence.Length == 0)
        {
            Debug.LogError(
                "SequenceQuestChecker: Keine richtige Sequenz eingetragen.");
            return false;
        }

        bool isCorrect =
            SequenceChoiceManager.Instance.MatchesSequence(
                correctSequence);

        if (!isCorrect)
        {
            Debug.Log(
                "Falsche Eingabe: " +
                SequenceChoiceManager.Instance.GetSequenceText());

            return false;
        }

        bool questCompleted = CompleteQuest();

        if (questCompleted)
        {
            Debug.Log(
                "Richtige Eingabe: " +
                SequenceChoiceManager.Instance.GetSequenceText() +
                ". Quest " +
                questID +
                " wurde abgeschlossen.");
        }

        return questCompleted;
    }

    private bool CompleteQuest()
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "SequenceQuestChecker: QuestManager fehlt.");
            return false;
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
                Debug.LogError(
                    "SequenceQuestChecker: Ungültige Quest-ID: " +
                    questID);

                return false;
        }

        return true;
    }
}