using UnityEngine;

public class QuestInteractObject : MonoBehaviour
{
    [Header("Quest")]
    [Tooltip(
        "Alle QuestInteractObjects mit derselben Quest-ID " +
        "gehören grundsätzlich zur selben Quest."
    )]
    [SerializeField]
    private int questID = 1;

    [Header("Quest-Abschluss")]
    [Tooltip(
        "Aktiviert: Dieses Objekt schließt die Quest sofort ab. " +
        "Deaktiviert: Die Quest wird erst abgeschlossen, wenn alle " +
        "QuestInteractObjects mit derselben Quest-ID benutzt wurden."
    )]
    [SerializeField]
    private bool completeQuestImmediately = false;

    [Header("Teleport")]
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

    public void Interact()
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "QuestInteractObject: QuestManager wurde nicht gefunden.",
                this);

            return;
        }

        if (!IsQuestActive())
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

        if (destination == null)
        {
            Debug.LogError(
                "QuestInteractObject: Destination wurde nicht zugewiesen.",
                this);

            return;
        }

        /*
         * Objekt an den Zielpunkt bewegen.
         */
        transform.position =
            destination.position;

        transform.rotation =
            destination.rotation;

        /*
         * Dieses Objekt wurde erfolgreich benutzt.
         */
        hasInteracted = true;

        Debug.Log(
            "QuestInteractObject: " +
            gameObject.name +
            " wurde für Quest " +
            questID +
            " erledigt.",
            this);

        /*
         * Ist diese Option aktiviert, wird die Quest sofort
         * abgeschlossen. Andere Objekte mit derselben Quest-ID
         * müssen dann nicht mehr benutzt werden.
         */
        if (completeQuestImmediately)
        {
            CompleteQuest();

            Debug.Log(
                "QuestInteractObject: Quest " +
                questID +
                " wurde durch " +
                gameObject.name +
                " sofort abgeschlossen.",
                this);

            return;
        }

        /*
         * Normales Verhalten:
         * Prüfen, ob alle Objekte mit derselben Quest-ID
         * bereits benutzt wurden.
         */
        CheckQuestCompletion();
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

            if (questObject == null)
            {
                continue;
            }

            if (questObject.questID != questID)
            {
                continue;
            }

            /*
             * Objekte, die die Quest ohnehin sofort abschließen,
             * werden trotzdem als Teil dieser Quest gezählt.
             */
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
            CompleteQuest();
        }
    }

    private void CompleteQuest()
    {
        switch (questID)
        {
            case 1:
                QuestManager.Instance.quest1 =
                    QuestStatus.Completed;
                break;

            case 2:
                QuestManager.Instance.quest2 =
                    QuestStatus.Completed;
                break;

            case 3:
                QuestManager.Instance.quest3 =
                    QuestStatus.Completed;
                break;

            case 4:
                QuestManager.Instance.quest4 =
                    QuestStatus.Completed;
                break;

            case 5:
                QuestManager.Instance.quest5 =
                    QuestStatus.Completed;
                break;

            case 6:
                QuestManager.Instance.quest6 =
                    QuestStatus.Completed;
                break;

            case 7:
                QuestManager.Instance.quest7 =
                    QuestStatus.Completed;
                break;

            case 8:
                QuestManager.Instance.quest8 =
                    QuestStatus.Completed;
                break;

            case 9:
                QuestManager.Instance.quest9 =
                    QuestStatus.Completed;
                break;

            case 10:
                QuestManager.Instance.quest10 =
                    QuestStatus.Completed;
                break;

            case 11:
                QuestManager.Instance.quest11 =
                    QuestStatus.Completed;
                break;

            case 12:
                QuestManager.Instance.quest12 =
                    QuestStatus.Completed;
                break;

            case 13:
                QuestManager.Instance.quest13 =
                    QuestStatus.Completed;
                break;

            case 14:
                QuestManager.Instance.quest14 =
                    QuestStatus.Completed;
                break;

            case 15:
                QuestManager.Instance.quest15 =
                    QuestStatus.Completed;
                break;

            default:
                Debug.LogError(
                    "QuestInteractObject: Ungültige Quest-ID: " +
                    questID,
                    this);

                return;
        }

        Debug.Log(
            "Quest " +
            questID +
            " wurde abgeschlossen.",
            this);
    }

    private bool IsQuestActive()
    {
        switch (questID)
        {
            case 1:
                return QuestManager.Instance.quest1 ==
                       QuestStatus.Active;

            case 2:
                return QuestManager.Instance.quest2 ==
                       QuestStatus.Active;

            case 3:
                return QuestManager.Instance.quest3 ==
                       QuestStatus.Active;

            case 4:
                return QuestManager.Instance.quest4 ==
                       QuestStatus.Active;

            case 5:
                return QuestManager.Instance.quest5 ==
                       QuestStatus.Active;

            case 6:
                return QuestManager.Instance.quest6 ==
                       QuestStatus.Active;

            case 7:
                return QuestManager.Instance.quest7 ==
                       QuestStatus.Active;

            case 8:
                return QuestManager.Instance.quest8 ==
                       QuestStatus.Active;

            case 9:
                return QuestManager.Instance.quest9 ==
                       QuestStatus.Active;

            case 10:
                return QuestManager.Instance.quest10 ==
                       QuestStatus.Active;

            case 11:
                return QuestManager.Instance.quest11 ==
                       QuestStatus.Active;

            case 12:
                return QuestManager.Instance.quest12 ==
                       QuestStatus.Active;

            case 13:
                return QuestManager.Instance.quest13 ==
                       QuestStatus.Active;

            case 14:
                return QuestManager.Instance.quest14 ==
                       QuestStatus.Active;

            case 15:
                return QuestManager.Instance.quest15 ==
                       QuestStatus.Active;

            default:
                Debug.LogError(
                    "QuestInteractObject: Ungültige Quest-ID: " +
                    questID,
                    this);

                return false;
        }
    }
}