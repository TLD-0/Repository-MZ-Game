using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class NPCQuestEntry
{
    [Header("Quest")]
    public int questID;

    [Header("Dialogues")]
    public DialogueData startDialogue;
    public DialogueData activeDialogue;
    public DialogueData completedDialogue;
}

public class NPCQuestDialogue : MonoBehaviour
{
    [Header("Dialog Positionen")]
    public Transform playerPoint;
    public Transform cameraPoint;

    [Header("Emotionen")] 
    public NPCEmotionController emotionController;

    [Header("Quests dieses NPCs")]
    public List<NPCQuestEntry> quests = new List<NPCQuestEntry>();

    public void StartNPCDialogue()
    {
        NPCQuestEntry entry = GetCurrentQuestEntry();

        if (entry == null)
        {
            Debug.Log("Dieser NPC hat keine offenen Quests mehr.");
            return;
        }

        QuestStatus status = GetQuestStatus(entry.questID);

        if (status == QuestStatus.NotStarted)
        {
            DialogueManager.Instance.StartDialogue(
                entry.startDialogue,
                playerPoint,
                cameraPoint,
                emotionController);
        }
        else if (status == QuestStatus.Active)
        {
            DialogueManager.Instance.StartDialogue(
                entry.activeDialogue,
                playerPoint,
                cameraPoint,
                emotionController);
        }
        else if (status == QuestStatus.Completed)
        {
            DialogueManager.Instance.StartDialogue(
                entry.completedDialogue,
                playerPoint,
                cameraPoint,
                emotionController);
        }
    }

    private NPCQuestEntry GetCurrentQuestEntry()
    {
        foreach (NPCQuestEntry entry in quests)
        {
            QuestStatus status = GetQuestStatus(entry.questID);

            // Abgeschlossene und ausgeschlossene Quests werden übersprungen.
            if (status != QuestStatus.Completed &&
                status != QuestStatus.Skipped)
            {
                return entry;
            }
        }

        // Alle Quests sind abgeschlossen oder übersprungen:
        // letzter Quest-Eintrag wird für einen Abschlussdialog benutzt.
        if (quests.Count > 0)
        {
            return quests[quests.Count - 1];
        }

        return null;
    }

    private QuestStatus GetQuestStatus(int questID)
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "NPCQuestDialogue: QuestManager wurde nicht gefunden.");
            return QuestStatus.NotStarted;
        }

        switch (questID)
        {
            case 1:
                return QuestManager.Instance.quest1;

            case 2:
                return QuestManager.Instance.quest2;

            case 3:
                return QuestManager.Instance.quest3;

            case 4:
                return QuestManager.Instance.quest4;

            default:
                Debug.LogError(
                    "NPCQuestDialogue: Ungültige Quest-ID: " +
                    questID);
                return QuestStatus.NotStarted;
        }
    }
}

