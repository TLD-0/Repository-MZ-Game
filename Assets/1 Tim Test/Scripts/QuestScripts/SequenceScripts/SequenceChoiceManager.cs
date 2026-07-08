using System.Collections.Generic;
using UnityEngine;

public class SequenceChoiceManager : MonoBehaviour
{
    public static SequenceChoiceManager Instance;

    private List<int> currentValues = new List<int>();
    private string currentSequenceName = "";

    private void Awake()
    {
        Instance = this;
    }

    public void StartSequence(string sequenceName)
    {
        currentSequenceName = sequenceName;
        currentValues.Clear();

        Debug.Log("Sequenz gestartet: " + currentSequenceName);
    }

    public void AddValue(int value)
    {
        currentValues.Add(value);

        Debug.Log(
            currentSequenceName +
            " | Wert hinzugefügt: " + value +
            " | Aktuell: " + GetSequenceText());
    }

    public int GetValue(int index)
    {
        if (index < 0 || index >= currentValues.Count)
        {
            Debug.LogError("SequenceChoiceManager: Ungültiger Index: " + index);
            return -1;
        }

        return currentValues[index];
    }

    public int GetCount()
    {
        return currentValues.Count;
    }

    public bool MatchesSequence(int[] correctValues)
    {
        if (correctValues == null)
        {
            Debug.LogError("SequenceChoiceManager: Richtige Sequenz fehlt.");
            return false;
        }

        if (currentValues.Count != correctValues.Length)
            return false;

        for (int i = 0; i < correctValues.Length; i++)
        {
            if (currentValues[i] != correctValues[i])
                return false;
        }

        return true;
    }

    public string GetSequenceText()
    {
        if (currentValues.Count == 0)
            return "Leer";

        return string.Join(" / ", currentValues);
    }
}