using UnityEngine;

public class QuestInteractObject : MonoBehaviour
{
    public enum QuestObjectAction
    {
        Teleport = 0,
        Deactivate = 1,
        None = 2
    }

    [Header("Quest")]
    [Tooltip(
        "Alle QuestInteractObjects mit derselben Quest-ID " +
        "gehören grundsätzlich zur selben Quest."
    )]
    [SerializeField]
    [Range(1, 16)]
    private int questID = 1;

    [Header("Quest-Abschluss")]
    [Tooltip(
        "Aktiviert: Dieses Objekt schließt die Quest sofort ab. " +
        "Deaktiviert: Die Quest wird erst abgeschlossen, wenn alle " +
        "zählenden QuestInteractObjects mit derselben Quest-ID benutzt wurden."
    )]
    [SerializeField]
    private bool completeQuestImmediately;

    [Tooltip(
        "Bestimmt, ob dieses Objekt bei der Gruppenprüfung " +
        "für dieselbe Quest-ID mitgezählt wird."
    )]
    [SerializeField]
    private bool countsForQuestCompletion = true;

    [Header("Aktion bei Interaktion")]
    [Tooltip(
        "Teleport: Objekt wird zur Destination bewegt. " +
        "Deactivate: Objekt wird deaktiviert. " +
        "None: Nur der Questfortschritt wird verarbeitet."
    )]
    [SerializeField]
    private QuestObjectAction action =
        QuestObjectAction.Teleport;

    [Tooltip(
        "Nur bei Action = Teleport erforderlich."
    )]
    [SerializeField]
    private Transform destination;

    [Header("Interaktion")]
    [Tooltip(
        "Verhindert, dass dieses Objekt mehrfach benutzt " +
        "und mehrfach gezählt wird."
    )]
    [SerializeField]
    private bool allowOnlyOneInteraction = true;

    private bool hasInteracted;

    public int QuestID
    {
        get { return questID; }
    }

    public bool HasInteracted
    {
        get { return hasInteracted; }
    }

    public bool CountsForQuestCompletion
    {
        get { return countsForQuestCompletion; }
    }

    public void Interact()
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "QuestInteractObject: QuestManager wurde nicht gefunden.",
                this);

            return;
        }

        if (!QuestManager.Instance.IsQuestActive(questID))
        {
            Debug.Log(
                "QuestInteractObject: Quest " +
                questID +
                " ist nicht aktiv.",
                this);

            return;
        }

        if (allowOnlyOneInteraction &&
            hasInteracted)
        {
            Debug.Log(
                "QuestInteractObject: " +
                gameObject.name +
                " wurde bereits benutzt.",
                this);

            return;
        }

        if (!ValidateAction())
        {
            return;
        }

        hasInteracted = true;

        ApplyAction();

        Debug.Log(
            "QuestInteractObject: " +
            gameObject.name +
            " wurde für Quest " +
            questID +
            " erledigt.",
            this);

        if (completeQuestImmediately)
        {
            QuestManager.Instance.CompleteQuest(
                questID);

            return;
        }

        CheckQuestCompletion();
    }

    private bool ValidateAction()
    {
        if (action != QuestObjectAction.Teleport)
        {
            return true;
        }

        if (destination != null)
        {
            return true;
        }

        Debug.LogError(
            "QuestInteractObject: Action steht auf Teleport, " +
            "aber Destination wurde nicht zugewiesen.",
            this);

        return false;
    }

    private void ApplyAction()
    {
        switch (action)
        {
            case QuestObjectAction.Teleport:
                transform.SetPositionAndRotation(
                    destination.position,
                    destination.rotation);
                break;

            case QuestObjectAction.Deactivate:
                gameObject.SetActive(false);
                break;

            case QuestObjectAction.None:
                break;

            default:
                Debug.LogError(
                    "QuestInteractObject: Unbekannte Aktion.",
                    this);
                break;
        }
    }

    private void CheckQuestCompletion()
    {
        QuestInteractObject[] allQuestObjects =
            FindObjectsByType<QuestInteractObject>(
                FindObjectsInactive.Include,
                FindObjectsSortMode.None);

        int requiredObjectCount = 0;
        int completedObjectCount = 0;

        for (int i = 0;
             i < allQuestObjects.Length;
             i++)
        {
            QuestInteractObject questObject =
                allQuestObjects[i];

            if (questObject == null ||
                questObject.questID != questID ||
                !questObject.countsForQuestCompletion)
            {
                continue;
            }

            requiredObjectCount++;

            if (questObject.hasInteracted)
            {
                completedObjectCount++;
            }
        }

        Debug.Log(
            "Quest " +
            questID +
            ": " +
            completedObjectCount +
            " von " +
            requiredObjectCount +
            " Objekten erledigt.",
            this);

        if (requiredObjectCount > 0 &&
            completedObjectCount >= requiredObjectCount)
        {
            QuestManager.Instance.CompleteQuest(
                questID);
        }
    }
}
