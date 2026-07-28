using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class QuestStart
{
    public int questID;
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

    [Header("Quest überspringen")]
    public bool skipsQuest;

    public int questIDToSkip;

    [Header("Sequenz-Auswahl")]
    public bool addsSequenceValue;

    public int sequenceValue;

    [Header("Sequenz prüfen")]
    public bool checksSequence;

    public SequenceQuestChecker sequenceChecker;

    [Header("Cloud Mood")]
    [Tooltip(
        "Dieser Wert wird beim Auswählen der Antwort zu MoodValue addiert. " +
        "Beispiele: 1, 2, -1 oder -3. " +
        "0 bedeutet keine Veränderung."
    )]
    public int moodValueChange;
}

[System.Serializable]
public class NPCEmotionChange
{
    [Header("Emotion ändern")]
    [Tooltip(
        "Wenn deaktiviert, bleibt die bisherige Emotion erhalten."
    )]
    public bool changeEmotion;

    [Header("Ziel")]
    [Tooltip(
        "Current Speaker verwendet den NPC, mit dem der Dialog gestartet wurde. " +
        "Specific NPC verwendet die ausgewählte NPC-ID."
    )]
    public NPCEmotionTargetMode targetMode =
        NPCEmotionTargetMode.CurrentSpeaker;

    [Tooltip(
        "Nur bei Target Mode = Specific NPC relevant."
    )]
    public NPCId targetNPCId =
        NPCId.None;

    [Header("Neue Emotion")]
    [Tooltip(
        "Der Kopf-Sprite, der in diesem Node angezeigt werden soll. " +
        "Bleibt das Feld leer, bleibt die vorherige Emotion bestehen."
    )]
    public Sprite emotionSprite;

    [Tooltip(
        "Blendet den Emotionskopf aus und zeigt wieder " +
        "den neutralen Kopf des normalen Körpersprites."
    )]
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
    public List<DialogueNode> nodes =
        new List<DialogueNode>();
}