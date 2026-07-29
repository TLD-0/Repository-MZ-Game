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
        "Quests, die geprüft werden, bevor die eingetragenen Objekte " +
        "aktiviert oder das Prefab erzeugt wird."
    )]
    [SerializeField]
    private int[] requiredCompletedQuestIDs;

    [SerializeField]
    private RequiredQuestState requiredQuestState =
        RequiredQuestState.Completed;

    [Tooltip(
        "Aktiviert: Alle eingetragenen Quests müssen passen. " +
        "Deaktiviert: Eine passende Quest reicht."
    )]
    [SerializeField]
    private bool requireAll = true;

    [Header("Bedingungen für das spätere Deaktivieren")]
    [SerializeField]
    private bool hideAfterQuestCompleted;

    [SerializeField]
    private int[] hideAfterCompletedQuestIDs;

    [Tooltip(
        "Status, auf den die Despawn-Quests geprüft werden."
    )]
    [SerializeField]
    private RequiredQuestState hideRequiredQuestState =
        RequiredQuestState.Completed;

    [Tooltip(
        "Aktiviert: Alle Despawn-Bedingungen müssen passen. " +
        "Deaktiviert: Eine passende Bedingung reicht."
    )]
    [SerializeField]
    private bool requireAllHideQuests = true;

    [Header("Freischaltart")]
    [SerializeField]
    private UnlockMode unlockMode =
        UnlockMode.EnableExistingNPC;

    [Header("Vorhandene Objekte aktivieren")]
    [FormerlySerializedAs("existingNpcRoot")]
    [SerializeField]
    private GameObject primaryExistingObject;

    [SerializeField]
    private GameObject[] additionalExistingObjects;

    [Tooltip(
        "Deaktiviert die eingetragenen vorhandenen Objekte beim Scene-Start. " +
        "Der QuestNPCSpawner muss dafür auf einem separaten Controller liegen."
    )]
    [SerializeField]
    private bool disableExistingObjectsAtStart = true;

    [Header("Prefab erzeugen")]
    [Tooltip(
        "Nur bei Unlock Mode = Instantiate Prefab verwenden."
    )]
    [SerializeField]
    private GameObject npcPrefab;

    [Tooltip(
        "Nur bei Unlock Mode = Instantiate Prefab verwenden."
    )]
    [SerializeField]
    private Transform spawnPoint;

    [Header("Prüfung")]
    [SerializeField]
    [Min(0.05f)]
    private float checkInterval = 0.25f;

    private float nextCheckTime;
    private bool objectsUnlocked;
    private bool objectsHiddenAfterQuest;
    private GameObject spawnedObject;
    private bool invalidSetupWarningShown;
    private bool missingQuestManagerWarningShown;

    private void Awake()
    {
        if (unlockMode == UnlockMode.EnableExistingNPC &&
            disableExistingObjectsAtStart)
        {
            SetExistingObjectsActive(false);
        }
    }

    private void Update()
    {
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
            if (!missingQuestManagerWarningShown)
            {
                Debug.LogError(
                    "QuestNPCSpawner: QuestManager wurde nicht gefunden.",
                    this);

                missingQuestManagerWarningShown = true;
            }

            return;
        }

        if (ShouldHideObjects())
        {
            HideObjects();
            return;
        }

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
        return AreQuestRequirementsMet(
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

        return AreQuestRequirementsMet(
            hideAfterCompletedQuestIDs,
            requireAllHideQuests,
            false,
            hideRequiredQuestState);
    }

    private bool AreQuestRequirementsMet(
        int[] questIDs,
        bool requireAllQuests,
        bool resultForEmptyList,
        RequiredQuestState requiredState)
    {
        if (questIDs == null ||
            questIDs.Length == 0)
        {
            return resultForEmptyList;
        }

        if (requireAllQuests)
        {
            for (int i = 0;
                 i < questIDs.Length;
                 i++)
            {
                if (!HasRequiredQuestState(
                        questIDs[i],
                        requiredState))
                {
                    return false;
                }
            }

            return true;
        }

        for (int i = 0;
             i < questIDs.Length;
             i++)
        {
            if (HasRequiredQuestState(
                    questIDs[i],
                    requiredState))
            {
                return true;
            }
        }

        return false;
    }

    private bool HasRequiredQuestState(
        int questID,
        RequiredQuestState requiredState)
    {
        QuestStatus currentStatus =
            QuestManager.Instance.GetQuestStatus(
                questID);

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
                return currentStatus == QuestStatus.Completed ||
                       currentStatus == QuestStatus.Skipped;

            default:
                return false;
        }
    }

    private void UnlockObjects()
    {
        bool success;

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

                return;
        }

        if (!success)
        {
            return;
        }

        objectsUnlocked = true;

        Debug.Log(
            "QuestNPCSpawner: Ziele wurden aktiviert.",
            this);
    }

    private bool EnableExistingObjects()
    {
        int validObjectCount =
            SetExistingObjectsActive(true);

        if (validObjectCount > 0)
        {
            return true;
        }

        ShowExistingObjectSetupError();
        return false;
    }

    private bool SpawnPrefab()
    {
        if (npcPrefab == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Unlock Mode steht auf Instantiate Prefab, " +
                "aber NPC Prefab fehlt.",
                this);

            return false;
        }

        if (spawnPoint == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Unlock Mode steht auf Instantiate Prefab, " +
                "aber Spawn Point fehlt.",
                this);

            return false;
        }

        if (spawnedObject != null)
        {
            return true;
        }

        spawnedObject = Instantiate(
            npcPrefab,
            spawnPoint.position,
            spawnPoint.rotation);

        return true;
    }

    private void HideObjects()
    {
        bool success;

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

                return;
        }

        if (!success)
        {
            return;
        }

        objectsUnlocked = false;
        objectsHiddenAfterQuest = true;

        Debug.Log(
            "QuestNPCSpawner: Ziele wurden dauerhaft deaktiviert.",
            this);
    }

    private bool DisableExistingObjects()
    {
        int validObjectCount =
            SetExistingObjectsActive(false);

        if (validObjectCount > 0)
        {
            return true;
        }

        ShowExistingObjectSetupError();
        return false;
    }

    private bool RemoveSpawnedObject()
    {
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
            if (TrySetObjectActive(
                    additionalExistingObjects[i],
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

        bool controllerWouldBeDisabled =
            targetObject == gameObject ||
            transform.IsChildOf(
                targetObject.transform);

        if (controllerWouldBeDisabled)
        {
            if (!invalidSetupWarningShown)
            {
                Debug.LogError(
                    "QuestNPCSpawner: Das Ziel " +
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

    private void ShowExistingObjectSetupError()
    {
        if (invalidSetupWarningShown)
        {
            return;
        }

        Debug.LogError(
            "QuestNPCSpawner: Unlock Mode steht auf Enable Existing NPC, " +
            "aber Primary Existing Object und Additional Existing Objects " +
            "enthalten kein gültiges Ziel. NPC Prefab und Spawn Point werden " +
            "in diesem Modus nicht verwendet.",
            this);

        invalidSetupWarningShown = true;
    }
}
