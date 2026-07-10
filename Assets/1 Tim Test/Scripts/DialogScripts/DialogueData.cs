using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class DialogueChoice
{
    [Header("Text")]
    public string answerText;

    [Header("Next Dialogue Node")]
    public int nextNode;

    [Header("Quest starten")]
    public bool startsQuest;
    public int questIDToStart;

    [Header("Quest überspringen")]
    public bool skipsQuest;
    public int questIDToSkip;

    [Header("Sequenz-Auswahl")]
    public bool addsSequenceValue;
    public int sequenceValue;

    [Header("Sequenz prüfen")]
    public bool checksSequence;
    public SequenceQuestChecker sequenceChecker;
}


[System.Serializable]
public class DialogueNode
{
    [TextArea(3, 10)]
    public string dialogueText;

    [Header("NPC Emotion")]
    public NPCEmotion npcEmotion = NPCEmotion.Neutral;

    public List<DialogueChoice> choices =
        new List<DialogueChoice>();
}

[CreateAssetMenu(fileName = "New Dialogue", menuName = "Dialogue System/Dialogue")]

public class DialogueData : ScriptableObject
{
    public List<DialogueNode> nodes =
    new List<DialogueNode>();
}

