using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class DialogueChoice
{
    public string answerText;

    public int nextNode;

    [Header("Quest Action")]
    public bool startsQuest;
    public int questIDToStart;
}

[System.Serializable]
public class DialogueNode
{
    [TextArea(3, 10)]
    public string dialogueText;


    public List<DialogueChoice> choices =
        new List<DialogueChoice>();
}

[CreateAssetMenu(
fileName = "New Dialogue",
menuName = "Dialogue System/Dialogue")]
public class DialogueData : ScriptableObject
{
    public List<DialogueNode> nodes =
    new List<DialogueNode>();
}
