using UnityEngine;

[RequireComponent(typeof(Collider))]
public class QuestCompleteTrigger : MonoBehaviour
{
    [Header("Quest")]
    [SerializeField]
    [Range(1, 16)]
    private int questID = 1;

    [Tooltip(
        "Aktiviert: Der Trigger funktioniert nur, wenn die Quest Active ist."
    )]
    [SerializeField]
    private bool requireQuestActive = true;

    [Header("Trigger")]
    [SerializeField]
    private string playerTag = "Player";

    [SerializeField]
    private bool triggerOnlyOnce = true;

    [SerializeField]
    private bool disableColliderAfterTrigger = true;

    private Collider triggerCollider;
    private bool hasTriggered;

    private void Awake()
    {
        triggerCollider =
            GetComponent<Collider>();

        if (!triggerCollider.isTrigger)
        {
            Debug.LogWarning(
                "QuestCompleteTrigger: Der Collider ist nicht als Trigger eingestellt.",
                this);
        }
    }

    private void OnTriggerEnter(
        Collider other)
    {
        if (triggerOnlyOnce &&
            hasTriggered)
        {
            return;
        }

        if (!IsPlayer(other))
        {
            return;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "QuestCompleteTrigger: QuestManager fehlt.",
                this);

            return;
        }

        if (requireQuestActive &&
            !QuestManager.Instance.IsQuestActive(questID))
        {
            return;
        }

        if (!QuestManager.Instance.CompleteQuest(questID))
        {
            return;
        }

        hasTriggered = true;

        if (disableColliderAfterTrigger &&
            triggerCollider != null)
        {
            triggerCollider.enabled = false;
        }
    }

    private bool IsPlayer(
        Collider other)
    {
        if (other.CompareTag(playerTag))
        {
            return true;
        }

        Transform root =
            other.transform.root;

        return root != null &&
               root.CompareTag(playerTag);
    }
}
