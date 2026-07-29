using UnityEngine;

public class Door : MonoBehaviour
{
    [Header("Teleport")]
    [Tooltip(
        "Zielposition, zu der der Spieler beim Interagieren bewegt wird."
    )]
    public Transform destination;

    [Header("Optionaler Questabschluss")]
    [Tooltip(
        "Aktiviert: Beim erfolgreichen Benutzen dieser Tür " +
        "wird die eingetragene Quest abgeschlossen."
    )]
    public bool completeQuestOnUse;

    [Tooltip(
        "Quest, die beim erfolgreichen Benutzen abgeschlossen wird."
    )]
    [Range(1, 16)]
    public int questIDToComplete = 1;
}
