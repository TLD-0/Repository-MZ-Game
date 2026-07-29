using UnityEngine;

public class SequenceQuestChecker : MonoBehaviour
{
    [Header("Quest")]
    [Tooltip(
        "Die ID der Quest, die bei richtiger Reihenfolge abgeschlossen wird."
    )]
    [Range(1, 16)]
    public int questID = 1;

    [Header("Richtige Reihenfolge")]
    [Tooltip(
        "Die Werte müssen genau in dieser Reihenfolge eingegeben werden."
    )]
    public int[] correctSequence;

    public bool CheckSequence()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "SequenceQuestChecker: SequenceChoiceManager fehlt.",
                this);

            return false;
        }

        if (correctSequence == null ||
            correctSequence.Length == 0)
        {
            Debug.LogError(
                "SequenceQuestChecker: Keine richtige Sequenz eingetragen.",
                this);

            return false;
        }

        bool isCorrect =
            SequenceChoiceManager.Instance.MatchesSequence(
                correctSequence);

        if (!isCorrect)
        {
            Debug.Log(
                "SequenceQuestChecker: Falsche Eingabe: " +
                SequenceChoiceManager.Instance.GetSequenceText(),
                this);

            return false;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "SequenceQuestChecker: QuestManager fehlt.",
                this);

            return false;
        }

        bool questCompleted =
            QuestManager.Instance.CompleteQuest(
                questID);

        if (questCompleted)
        {
            Debug.Log(
                "SequenceQuestChecker: Richtige Eingabe. Quest " +
                questID +
                " wurde abgeschlossen.",
                this);
        }

        return questCompleted;
    }
}
