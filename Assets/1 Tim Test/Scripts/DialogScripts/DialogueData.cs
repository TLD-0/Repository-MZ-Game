using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class QuestStart
{
    [Range(1, 16)]
    public int questID = 1;
}

[System.Serializable]
public class QuestComplete
{
    [Range(1, 16)]
    public int questID = 1;
}

[System.Serializable]
public class DialogueChoice
{
    [Header("Text")]
    public string answerText;

    [Header("Next Dialogue Node")]
    public int nextNode;

    [Header("Quests starten")]
    public List<QuestStart> questsToStart =
        new List<QuestStart>();

    [Header("Quests abschließen")]
    public List<QuestComplete> questsToComplete =
        new List<QuestComplete>();

    [Header("Quest überspringen")]
    public bool skipsQuest;

    [Range(1, 16)]
    public int questIDToSkip = 1;

    [Header("Sequenz-Auswahl")]
    public bool addsSequenceValue;

    public int sequenceValue;

    [Header("Sequenz prüfen")]
    public bool checksSequence;

    public SequenceQuestChecker sequenceChecker;

    [Header("Cloud Mood")]
    [Tooltip(
        "Dieser Wert wird beim Auswählen der Antwort zu MoodValue addiert. " +
        "0 bedeutet keine Veränderung."
    )]
    public int moodValueChange;

    [Header("Spieler-Teleport")]
    public bool teleportPlayer;

    public DialogueTeleportDestination teleportDestination;
}

[System.Serializable]
public class NPCEmotionChange
{
    [Header("Emotion ändern")]
    public bool changeEmotion;

    [Header("Ziel")]
    public NPCEmotionTargetMode targetMode =
        NPCEmotionTargetMode.CurrentSpeaker;

    public NPCId targetNPCId =
        NPCId.None;

    [Header("Neue Emotion")]
    public Sprite emotionSprite;

    public bool returnToNeutral;
}

[System.Serializable]
public class DialogueNode
{
    [TextArea(3, 10)]
    public string dialogueText;

    [Header("Spieleremotion")]
    public bool changePlayerEmotion;

    public PlayerEmotion playerEmotion =
        PlayerEmotion.Neutral;

    [Header("NPC-Emotionen")]
    public List<NPCEmotionChange> emotionChanges =
        new List<NPCEmotionChange>();

    [Header("Antwortmöglichkeiten")]
    public List<DialogueChoice> choices =
        new List<DialogueChoice>();
}

[CreateAssetMenu(
    fileName = "New Dialogue",
    menuName = "Dialogue System/Dialogue"
)]
public class DialogueData : ScriptableObject
{
    [Header("Dialogsteuerung")]
    [Tooltip(
        "Aktiviert: Der Dialog kann mit Escape beendet werden. " +
        "Bei einmaligen Story- oder Questdialogen sollte dies deaktiviert sein."
    )]
    public bool allowEscape = true;

    [Header("Nodes")]
    public List<DialogueNode> nodes =
        new List<DialogueNode>();
}
