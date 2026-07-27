using UnityEngine;

public class QuestNPCSpawner : MonoBehaviour
{
    public enum UnlockMode
    {
        EnableExistingNPC,
        InstantiatePrefab
    }

    [Header("Bedingungen")]
    [SerializeField]
    private int[] requiredCompletedQuestIDs;

    [SerializeField]
    private bool requireAll = true;

    [Header("Freischaltart")]
    [SerializeField]
    private UnlockMode unlockMode =
        UnlockMode.EnableExistingNPC;

    [Header("Vorhandenen NPC aktivieren")]
    [Tooltip(
        "Wird verwendet, wenn Unlock Mode auf " +
        "Enable Existing NPC steht."
    )]
    [SerializeField]
    private GameObject existingNpcRoot;

    [Header("NPC-Prefab spawnen")]
    [Tooltip(
        "Wird verwendet, wenn Unlock Mode auf " +
        "Instantiate Prefab steht."
    )]
    [SerializeField]
    private GameObject npcPrefab;

    [SerializeField]
    private Transform spawnPoint;

    [Header("Prüfung")]
    [Tooltip(
        "Zeit zwischen den Questprüfungen."
    )]
    [SerializeField]
    private float checkInterval = 0.25f;

    private float nextCheckTime;
    private bool npcUnlocked;
    private GameObject spawnedNpc;

    private void Awake()
    {
        if (unlockMode ==
                UnlockMode.EnableExistingNPC &&
            existingNpcRoot != null)
        {
            existingNpcRoot.SetActive(false);
        }
    }

    private void Update()
    {
        if (npcUnlocked)
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

        if (!AreRequirementsCompleted())
        {
            return;
        }

        UnlockNPC();
    }

    private bool AreRequirementsCompleted()
    {
        if (QuestManager.Instance == null)
        {
            return false;
        }

        if (requiredCompletedQuestIDs == null ||
            requiredCompletedQuestIDs.Length == 0)
        {
            return true;
        }

        if (requireAll)
        {
            for (int i = 0;
                 i < requiredCompletedQuestIDs.Length;
                 i++)
            {
                if (!QuestManager.Instance.IsQuestCompleted(
                        requiredCompletedQuestIDs[i]))
                {
                    return false;
                }
            }

            return true;
        }

        for (int i = 0;
             i < requiredCompletedQuestIDs.Length;
             i++)
        {
            if (QuestManager.Instance.IsQuestCompleted(
                    requiredCompletedQuestIDs[i]))
            {
                return true;
            }
        }

        return false;
    }

    private void UnlockNPC()
    {
        switch (unlockMode)
        {
            case UnlockMode.EnableExistingNPC:
                EnableExistingNPC();
                break;

            case UnlockMode.InstantiatePrefab:
                SpawnNPCPrefab();
                break;
        }
    }

    private void EnableExistingNPC()
    {
        if (existingNpcRoot == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Existing NPC Root fehlt.",
                this);

            return;
        }

        existingNpcRoot.SetActive(true);
        npcUnlocked = true;

        Debug.Log(
            "QuestNPCSpawner: NPC wurde aktiviert.");
    }

    private void SpawnNPCPrefab()
    {
        if (npcPrefab == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: NPC Prefab fehlt.",
                this);

            return;
        }

        if (spawnPoint == null)
        {
            Debug.LogError(
                "QuestNPCSpawner: Spawn Point fehlt.",
                this);

            return;
        }

        spawnedNpc = Instantiate(
            npcPrefab,
            spawnPoint.position,
            spawnPoint.rotation);

        npcUnlocked = true;

        Debug.Log(
            "QuestNPCSpawner: NPC wurde gespawnt.");
    }
}