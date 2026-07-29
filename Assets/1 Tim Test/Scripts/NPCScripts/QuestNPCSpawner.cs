using UnityEngine;
using UnityEngine.Serialization;

public class QuestNPCSpawner : MonoBehaviour
{
    public enum UnlockMode
    {
        EnableExistingNPC,
        InstantiatePrefab
    }

    public enum RequiredQuestState
    {
        Active,
        Completed,
        Skipped,
        CompletedOrSkipped
    }

    [Header("Bedingungen für das Aktivieren")]
    [Tooltip(
        "Diese Quests müssen abgeschlossen sein, " +
        "bevor die eingetragenen Objekte aktiviert werden."
    )]
    [SerializeField]
    private int[] requiredCompletedQuestIDs;

    [Tooltip(
    "Legt fest, ob die eingetragenen Quests aktiv " +
    "oder abgeschlossen sein müssen."
    )]
    [SerializeField]
    private RequiredQuestState requiredQuestState =
        RequiredQuestState.Completed;

    [Tooltip(
        "Aktiviert: Alle eingetragenen Quests müssen abgeschlossen sein. " +
        "Deaktiviert: Eine der eingetragenen Quests reicht."
    )]
    [SerializeField]
    private bool requireAll = true;

    [Header("Bedingungen für das spätere Deaktivieren")]
    [Tooltip(
        "Aktiviert: Die zuvor aktivierten Objekte werden wieder " +
        "deaktiviert, sobald die Despawn-Bedingungen erfüllt sind."
    )]
    [SerializeField]
    private bool hideAfterQuestCompleted;

    [Tooltip(
        "Diese Quests werden für das spätere Deaktivieren geprüft."
    )]
    [SerializeField]
    private int[] hideAfterCompletedQuestIDs;

    [Tooltip(
        "Aktiviert: Alle Despawn-Quests müssen abgeschlossen sein. " +
        "Deaktiviert: Eine abgeschlossene Despawn-Quest reicht."
    )]
    [SerializeField]
    private bool requireAllHideQuests = true;

    [Header("Freischaltart")]
    [SerializeField]
    private UnlockMode unlockMode =
        UnlockMode.EnableExistingNPC;

    [Header("Vorhandene Objekte aktivieren")]
    [Tooltip(
        "Primäres GameObject, das aktiviert und später " +
        "gegebenenfalls wieder deaktiviert wird."
    )]
    [FormerlySerializedAs("existingNpcRoot")]
    [SerializeField]
    private GameObject primaryExistingObject;

    [Tooltip(
        "Zusätzliche NPCs, Questobjekte, Dialogbereiche oder " +
        "andere GameObjects, die gemeinsam aktiviert werden."
    )]
    [SerializeField]
    private GameObject[] additionalExistingObjects;

    [Tooltip(
        "Deaktiviert die eingetragenen vorhandenen Objekte " +
        "automatisch beim Start der Scene."
    )]
    [SerializeField]
    private bool disableExistingObjectsAtStart = true;

    [Header("Prefab erzeugen")]
    [Tooltip(
        "Nur bei Unlock Mode = Instantiate Prefab erforderlich."
    )]
    [SerializeField]
    private GameObject npcPrefab;

    [Tooltip(
        "Position, an der das Prefab erzeugt wird."
    )]
    [SerializeField]
    private Transform spawnPoint;

    [Header("Prüfung")]
    [Tooltip(
        "Zeit zwischen den Queststatus-Prüfungen."
    )]
    [SerializeField]
    [Min(0.05f)]
    private float checkInterval = 0.25f;

    private float nextCheckTime;

    /*
     * True, sobald die Objekte aktiviert
     * oder das Prefab erzeugt wurde.
     */
    private bool objectsUnlocked;

    /*
     * True, sobald die Objekte aufgrund der
     * späteren Quests endgültig deaktiviert wurden.
     */
    private bool objectsHiddenAfterQuest;

    /*
     * Nur bei InstantiatePrefab relevant.
     */
    private GameObject spawnedObject;

    private bool invalidSetupWarningShown;

    private void Awake()
    {
        /*
         * Vorhandene Objekte werden zunächst deaktiviert.
         *
         * Das QuestNPCSpawner-Script muss auf einem separaten,
         * dauerhaft aktiven Controller-Objekt liegen.
         */
        if (unlockMode ==
                UnlockMode.EnableExistingNPC &&
            disableExistingObjectsAtStart)
        {
            SetExistingObjectsActive(false);
        }
    }

    private void Update()
    {
        /*
         * Nachdem die Objekte endgültig deaktiviert wurden,
         * sind keine weiteren Prüfungen notwendig.
         */
        if (objectsHiddenAfterQuest)
        {
            return;
        }

        if (Time.unscaledTime < nextCheckTime)
        {
            return;
        }

        nextCheckTime =
            Time.unscaledTime +
            checkInterval;

        if (QuestManager.Instance == null)
        {
            return;
        }

        /*
         * Die Bedingung für das Deaktivieren wird zuerst geprüft.
         *
         * Sind die späteren Quests bereits abgeschlossen,
         * werden die Objekte beim Laden nicht noch einmal aktiviert.
         */
        if (ShouldHideObjects())
        {
            HideObjects();
            return;
        }

        /*
         * Die Objekte sind bereits aktiv.
         * Es muss nur noch auf die späteren Despawn-Quests
         * gewartet werden.
         */
        if (objectsUnlocked)
        {
            return;
        }

        if (!AreActivationRequirementsCompleted())
        {
            return;
        }

        UnlockObjects();
    }

    private bool AreActivationRequirementsCompleted()
    {
        return AreQuestRequirementsCompleted(
            requiredCompletedQuestIDs,
            requireAll,
            true,
            requiredQuestState);
    }

    private bool ShouldHideObjects()
    {
        if (!hideAfterQuestCompleted)
        {
            return false;
        }

        /*
        * Die Bedingungen für das spätere Deaktivieren
        * prüfen weiterhin auf Completed.
        */
        return AreQuestRequirementsCompleted(
            hideAfterCompletedQuestIDs,
            requireAllHideQuests,
            false,
            RequiredQuestState.Completed);
    }

    private QuestStatus GetQuestStatus(
        int questID)
    {
        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: QuestManager wurde nicht gefunden.",
                this);

            return QuestStatus.NotStarted;
        }

        switch (questID)
        {
            case 1:
                return QuestManager.Instance.quest1;

            case 2:
                return QuestManager.Instance.quest2;

            case 3:
                return QuestManager.Instance.quest3;

            case 4:
                return QuestManager.Instance.quest4;

            case 5:
                return QuestManager.Instance.quest5;

            case 6:
                return QuestManager.Instance.quest6;

            case 7:
                return QuestManager.Instance.quest7;

            case 8:
                return QuestManager.Instance.quest8;

            case 9:
                return QuestManager.Instance.quest9;

            case 10:
                return QuestManager.Instance.quest10;

            case 11:
                return QuestManager.Instance.quest11;

            case 12:
                return QuestManager.Instance.quest12;

            case 13:
                return QuestManager.Instance.quest13;

            case 14:
                return QuestManager.Instance.quest14;

            case 15:
                return QuestManager.Instance.quest15;

            default:
                Debug.LogError(
                    "QuestNPCSpawner: Ungültige Quest-ID: " +
                    questID,
                    this);

                return QuestStatus.NotStarted;
        }
    }

    private bool HasRequiredQuestState(
        int questID,
        RequiredQuestState requiredState)
    {
        QuestStatus currentStatus =
            GetQuestStatus(questID);

        switch (requiredState)
        {
            case RequiredQuestState.Active:
                return currentStatus ==
                    QuestStatus.Active;

            case RequiredQuestState.Completed:
                return currentStatus ==
                    QuestStatus.Completed;

            case RequiredQuestState.Skipped:
                return currentStatus ==
                    QuestStatus.Skipped;

            case RequiredQuestState.CompletedOrSkipped:
                return currentStatus ==
                        QuestStatus.Completed ||
                    currentStatus ==
                        QuestStatus.Skipped;

            default:
                return false;
        }
    }

    private bool AreQuestRequirementsCompleted(
    int[] questIDs,
    bool requireAllQuests,
    bool emptyListResult,
    RequiredQuestState requiredState)
    {
        if (QuestManager.Instance == null)
        {
            return false;
        }

        if (questIDs == null ||
            questIDs.Length == 0)
        {
            return emptyListResult;
        }

        /*
        * Alle eingetragenen Quests müssen
        * den gewünschten Status besitzen.
        */
        if (requireAllQuests)
        {
            for (int i = 0;
                i < questIDs.Length;
                i++)
            {
                int questID =
                    questIDs[i];

                if (!HasRequiredQuestState(
                        questID,
                        requiredState))
                {
                    return false;
                }
            }

            return true;
        }

        /*
        * Eine passende Quest reicht.
        */
        for (int i = 0;
            i < questIDs.Length;
            i++)
        {
            int questID =
                questIDs[i];

            if (HasRequiredQuestState(
                    questID,
                    requiredState))
            {
                return true;
            }
        }

        return false;
    }

    private void UnlockObjects()
    {
        bool success = false;

        switch (unlockMode)
        {
            case UnlockMode.EnableExistingNPC:
                success =
                    EnableExistingObjects();
                break;

            case UnlockMode.InstantiatePrefab:
                success =
                    SpawnPrefab();
                break;

            default:
                Debug.LogError(
                    "QuestNPCSpawner: Unbekannter Unlock Mode.",
                    this);
                break;
        }

        if (!success)
        {
            return;
        }

        objectsUnlocked = true;

        Debug.Log(
            "QuestNPCSpawner: Objekte wurden aktiviert.",
            this);
    }

    private bool EnableExistingObjects()
    {
        int validObjectCount =
            SetExistingObjectsActive(true);

        if (validObjectCount == 0)
        {
            Debug.LogError(
                "QuestNPCSpawner: Es wurde kein gültiges " +
                "vorhandenes Objekt zugewiesen.",
                this);

            return false;
        }

        return true;
    }

    private bool SpawnPrefab()
    {
        if (npcPrefab == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Prefab fehlt.",
                this);

            return false;
        }

        if (spawnPoint == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Spawn Point fehlt.",
                this);

            return false;
        }

        spawnedObject = Instantiate(
            npcPrefab,
            spawnPoint.position,
            spawnPoint.rotation);

        Debug.Log(
            "QuestNPCSpawner: Prefab " +
            spawnedObject.name +
            " wurde erzeugt.",
            this);

        return true;
    }

    private void HideObjects()
    {
        bool success = false;

        switch (unlockMode)
        {
            case UnlockMode.EnableExistingNPC:
                success =
                    DisableExistingObjects();
                break;

            case UnlockMode.InstantiatePrefab:
                success =
                    RemoveSpawnedObject();
                break;

            default:
                Debug.LogError(
                    "QuestNPCSpawner: Unbekannter Unlock Mode.",
                    this);
                break;
        }

        if (!success)
        {
            return;
        }

        objectsUnlocked = false;
        objectsHiddenAfterQuest = true;

        Debug.Log(
            "QuestNPCSpawner: Objekte wurden deaktiviert, " +
            "weil die späteren Questbedingungen erfüllt wurden.",
            this);
    }

    private bool DisableExistingObjects()
    {
        int validObjectCount =
            SetExistingObjectsActive(false);

        if (validObjectCount == 0)
        {
            Debug.LogError(
                "QuestNPCSpawner: Es wurde kein gültiges " +
                "vorhandenes Objekt zum Deaktivieren gefunden.",
                this);

            return false;
        }

        return true;
    }

    private bool RemoveSpawnedObject()
    {
        /*
         * Wurde die spätere Quest bereits abgeschlossen,
         * bevor das Prefab erzeugt wurde, existiert noch
         * keine Instanz. Der gewünschte Zustand ist trotzdem
         * bereits erreicht.
         */
        if (spawnedObject == null)
        {
            return true;
        }

        Destroy(spawnedObject);
        spawnedObject = null;

        return true;
    }

    private int SetExistingObjectsActive(
        bool active)
    {
        int validObjectCount = 0;

        if (TrySetObjectActive(
                primaryExistingObject,
                active))
        {
            validObjectCount++;
        }

        if (additionalExistingObjects == null)
        {
            return validObjectCount;
        }

        for (int i = 0;
             i < additionalExistingObjects.Length;
             i++)
        {
            GameObject targetObject =
                additionalExistingObjects[i];

            if (TrySetObjectActive(
                    targetObject,
                    active))
            {
                validObjectCount++;
            }
        }

        return validObjectCount;
    }

    private bool TrySetObjectActive(
        GameObject targetObject,
        bool active)
    {
        if (targetObject == null)
        {
            return false;
        }

        /*
         * Der Controller darf weder sich selbst noch einen
         * Parent von sich deaktivieren. Sonst würde Update()
         * nicht mehr ausgeführt und die Objekte könnten
         * später nicht wieder aktiviert werden.
         */
        bool controllerWouldBeDisabled =
            targetObject == gameObject ||
            transform.IsChildOf(
                targetObject.transform);

        if (controllerWouldBeDisabled)
        {
            if (!invalidSetupWarningShown)
            {
                Debug.LogError(
                    "QuestNPCSpawner: Das Objekt " +
                    targetObject.name +
                    " enthält den QuestNPCSpawner selbst. " +
                    "Verwende ein separates Controller-GameObject.",
                    this);

                invalidSetupWarningShown = true;
            }

            return false;
        }

        targetObject.SetActive(active);

        return true;
    }
}