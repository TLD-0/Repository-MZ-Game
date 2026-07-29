using UnityEngine;

public class Door : MonoBehaviour
{
    [Header("Teleport")]
    public Transform destination;

    [Header("Optionaler Questabschluss")]
    [Tooltip(
        "Aktiviert: Beim Benutzen dieser Tür wird " +
        "die eingetragene Quest abgeschlossen."
    )]
    public bool completeQuestOnUse;

    [Tooltip(
        "Quest, die beim Benutzen abgeschlossen wird."
    )]
    [Range(1, 15)]
    public int questIDToComplete = 1;
}