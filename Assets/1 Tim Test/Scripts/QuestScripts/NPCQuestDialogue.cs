using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class NPCQuestEntry
{
    [Header("Quest")]
    [Range(1, 16)]
    public int questID = 1;

    [Header("Dialoge")]
    public DialogueData startDialogue;
    public DialogueData activeDialogue;
    public DialogueData completedDialogue;
}

public class NPCQuestDialogue : MonoBehaviour
{
    [Header("Dialogpositionen")]
    public Transform playerPoint;
    public Transform cameraPoint;

    [Header("Emotionen")]
    public NPCEmotionController emotionController;

    [Header("Quests dieses NPCs")]
    public List<NPCQuestEntry> quests =
        new List<NPCQuestEntry>();

    private void Awake()
    {
        FindEmotionController();
    }

    private void OnValidate()
    {
        FindEmotionController();
    }

    public void StartNPCDialogue()
    {
        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "NPCQuestDialogue: DialogueManager wurde nicht gefunden.",
                this);

            return;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "NPCQuestDialogue: QuestManager wurde nicht gefunden.",
                this);

            return;
        }

        FindEmotionController();

        NPCQuestEntry entry =
            GetCurrentQuestEntry();

        if (entry == null)
        {
            Debug.Log(
                "NPCQuestDialogue: Dieser NPC besitzt keinen passenden Questdialog.",
                this);

            return;
        }

        QuestStatus status =
            QuestManager.Instance.GetQuestStatus(
                entry.questID);

        DialogueData dialogue =
            GetDialogueForStatus(
                entry,
                status);

        if (dialogue == null)
        {
            Debug.LogWarning(
                "NPCQuestDialogue: Für Quest " +
                entry.questID +
                " und Status " +
                status +
                " ist kein Dialog eingetragen.",
                this);

            return;
        }

        DialogueManager.Instance.StartDialogue(
            dialogue,
            playerPoint,
            cameraPoint,
            emotionController);
    }

    private NPCQuestEntry GetCurrentQuestEntry()
    {
        if (quests == null ||
            quests.Count == 0)
        {
            return null;
        }

        for (int i = 0;
             i < quests.Count;
             i++)
        {
            NPCQuestEntry entry =
                quests[i];

            if (entry == null)
            {
                continue;
            }

            QuestStatus status =
                QuestManager.Instance.GetQuestStatus(
                    entry.questID);

            if (status != QuestStatus.Completed &&
                status != QuestStatus.Skipped)
            {
                return entry;
            }
        }

        /*
         * Alle Quests sind abgeschlossen oder übersprungen.
         * Der letzte Eintrag darf dann seinen Completed Dialogue zeigen.
         */
        for (int i = quests.Count - 1;
             i >= 0;
             i--)
        {
            if (quests[i] != null)
            {
                return quests[i];
            }
        }

        return null;
    }

    private static DialogueData GetDialogueForStatus(
        NPCQuestEntry entry,
        QuestStatus status)
    {
        switch (status)
        {
            case QuestStatus.NotStarted:
                return entry.startDialogue;

            case QuestStatus.Active:
                return entry.activeDialogue;

            case QuestStatus.Completed:
            case QuestStatus.Skipped:
                return entry.completedDialogue;

            default:
                return null;
        }
    }

    private void FindEmotionController()
    {
        if (emotionController == null)
        {
            emotionController =
                GetComponentInChildren<NPCEmotionController>(
                    true);
        }
    }
}
