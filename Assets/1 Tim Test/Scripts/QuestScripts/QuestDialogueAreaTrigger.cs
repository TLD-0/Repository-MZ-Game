using UnityEngine;

[RequireComponent(typeof(Collider))]
public class QuestDialogueAreaTrigger : MonoBehaviour
{
    [Header("Dialog")]
    [SerializeField]
    private DialogueData dialogue;

    [Header("Dialogpositionen")]
    [Tooltip(
        "Position, zu der der Spieler beim Dialog bewegt wird."
    )]
    [SerializeField]
    private Transform playerPoint;

    [Tooltip(
        "Position, zu der die Kamera beim Dialog bewegt wird."
    )]
    [SerializeField]
    private Transform cameraPoint;

    [Header("Optionaler aktueller Sprecher")]
    [Tooltip(
        "Nur notwendig, wenn im Dialog Target Mode " +
        "Current Speaker verwendet wird. " +
        "Bei ausschließlich Specific-NPC-Einträgen kann das Feld leer bleiben."
    )]
    [SerializeField]
    private NPCEmotionController currentSpeakerEmotionController;

    [Header("Trigger-Einstellungen")]
    [Tooltip(
        "Der Dialog kann während des gesamten Spiels " +
        "nur einmal ausgelöst werden."
    )]
    [SerializeField]
    private bool triggerOnlyOnce = true;

    [Tooltip(
        "Deaktiviert den Collider nach der ersten " +
        "erfolgreichen Auslösung."
    )]
    [SerializeField]
    private bool disableColliderAfterTrigger = true;

    [Tooltip(
        "Tag des Spielerobjekts."
    )]
    [SerializeField]
    private string playerTag = "Player";

    private Collider triggerCollider;

    private bool playerInside;
    private bool triggeredThisVisit;
    private bool permanentlyTriggered;

    private void Awake()
    {
        triggerCollider =
            GetComponent<Collider>();

        if (triggerCollider == null)
        {
            Debug.LogError(
                "QuestDialogueAreaTrigger: " +
                "Es wurde kein Collider gefunden.",
                this);

            return;
        }

        if (!triggerCollider.isTrigger)
        {
            Debug.LogWarning(
                "QuestDialogueAreaTrigger: Der Collider auf " +
                gameObject.name +
                " ist nicht als Trigger eingestellt.",
                this);
        }
    }

    private void Update()
    {
        /*
         * Falls beim Betreten des Bereichs bereits ein anderer
         * Dialog läuft, versucht das Script erneut zu starten,
         * sobald dieser Dialog beendet wurde.
         */
        if (playerInside)
        {
            TryStartDialogue();
        }
    }

    private void OnTriggerEnter(
        Collider other)
    {
        if (!IsPlayer(other))
        {
            return;
        }

        playerInside = true;

        TryStartDialogue();
    }

    private void OnTriggerExit(
        Collider other)
    {
        if (!IsPlayer(other))
        {
            return;
        }

        playerInside = false;

        /*
         * Bei Trigger Only Once = false kann der Dialog
         * nach Verlassen und erneutem Betreten wieder starten.
         */
        triggeredThisVisit = false;
    }

    private void TryStartDialogue()
    {
        if (!playerInside)
        {
            return;
        }

        if (triggeredThisVisit)
        {
            return;
        }

        if (triggerOnlyOnce &&
            permanentlyTriggered)
        {
            return;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "QuestDialogueAreaTrigger: " +
                "DialogueManager fehlt.",
                this);

            return;
        }

        /*
         * Ein laufender Dialog wird nicht unterbrochen.
         * Solange der Spieler im Bereich bleibt, versucht
         * das Script es später erneut.
         */
        if (DialogueManager.Instance.IsDialogueActive)
        {
            return;
        }

        if (!ValidateTrigger())
        {
            return;
        }

        triggeredThisVisit = true;

        if (triggerOnlyOnce)
        {
            permanentlyTriggered = true;
        }

        DialogueManager.Instance.StartDialogue(
            dialogue,
            playerPoint,
            cameraPoint,
            currentSpeakerEmotionController);

        Debug.Log(
            "QuestDialogueAreaTrigger: " +
            "Bereichsdialog wurde gestartet.",
            this);

        if (triggerOnlyOnce &&
            disableColliderAfterTrigger &&
            triggerCollider != null)
        {
            triggerCollider.enabled = false;
        }
    }

    private bool ValidateTrigger()
    {
        if (dialogue == null ||
            dialogue.nodes == null ||
            dialogue.nodes.Count == 0)
        {
            Debug.LogError(
                "QuestDialogueAreaTrigger: " +
                "Kein gültiger Dialog eingetragen.",
                this);

            return false;
        }

        if (playerPoint == null)
        {
            Debug.LogError(
                "QuestDialogueAreaTrigger: " +
                "Player Point fehlt.",
                this);

            return false;
        }

        if (cameraPoint == null)
        {
            Debug.LogError(
                "QuestDialogueAreaTrigger: " +
                "Camera Point fehlt.",
                this);

            return false;
        }

        return true;
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

    /// <summary>
    /// Gibt den Trigger wieder frei.
    /// Kann durch andere Scripts oder UnityEvents aufgerufen werden.
    /// </summary>
    public void ResetTrigger()
    {
        permanentlyTriggered = false;
        triggeredThisVisit = false;

        if (triggerCollider != null)
        {
            triggerCollider.enabled = true;
        }
    }
}