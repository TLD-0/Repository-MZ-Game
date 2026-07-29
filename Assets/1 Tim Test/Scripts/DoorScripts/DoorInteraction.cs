using UnityEngine;

public class DoorInteraction : MonoBehaviour
{
    [Header("Referenzen")]
    [SerializeField]
    private Camera playerCamera;

    [SerializeField]
    private GameObject interactText;

    [Header("Einstellungen")]
    [SerializeField]
    [Min(0.1f)]
    private float interactDistance = 3f;

    private Door currentDoor;

    private void Update()
    {
        CheckDoor();

        if (Input.GetKeyDown(KeyCode.E))
        {
            Interact();
        }
    }

    private void CheckDoor()
    {
        currentDoor = null;
        SetInteractTextActive(false);

        if (playerCamera == null)
        {
            Debug.LogError(
                "DoorInteraction: Player Camera wurde nicht zugewiesen.",
                this);

            return;
        }

        Ray ray = new Ray(
            playerCamera.transform.position,
            playerCamera.transform.forward);

        if (!Physics.Raycast(
                ray,
                out RaycastHit hit,
                interactDistance))
        {
            return;
        }

        Door door =
            hit.collider.GetComponentInParent<Door>();

        if (door == null)
        {
            return;
        }

        InteractionQuestGate questGate =
            hit.collider.GetComponentInParent<InteractionQuestGate>();

        if (questGate != null &&
            !questGate.IsUnlocked())
        {
            return;
        }

        currentDoor = door;
        SetInteractTextActive(true);
    }

    private void Interact()
    {
        if (currentDoor == null)
        {
            return;
        }

        if (currentDoor.destination == null)
        {
            Debug.LogError(
                "DoorInteraction: Das Objekt " +
                currentDoor.name +
                " besitzt kein Destination-Objekt.",
                currentDoor);

            return;
        }

        TeleportPlayer(
            currentDoor.destination);

        if (currentDoor.completeQuestOnUse)
        {
            if (QuestManager.Instance == null)
            {
                Debug.LogError(
                    "DoorInteraction: QuestManager fehlt.",
                    currentDoor);

                return;
            }

            QuestManager.Instance.CompleteQuest(
                currentDoor.questIDToComplete);
        }

        SetInteractTextActive(false);
        currentDoor = null;
    }

    private void TeleportPlayer(
        Transform destination)
    {
        Rigidbody playerRigidbody =
            GetComponent<Rigidbody>();

        if (playerRigidbody == null)
        {
            transform.SetPositionAndRotation(
                destination.position,
                destination.rotation);

            Physics.SyncTransforms();
            return;
        }

        bool wasKinematic =
            playerRigidbody.isKinematic;

        playerRigidbody.isKinematic = true;
        playerRigidbody.linearVelocity = Vector3.zero;
        playerRigidbody.angularVelocity = Vector3.zero;

        transform.SetPositionAndRotation(
            destination.position,
            destination.rotation);

        playerRigidbody.position =
            destination.position;

        playerRigidbody.rotation =
            destination.rotation;

        Physics.SyncTransforms();

        playerRigidbody.isKinematic =
            wasKinematic;
    }

    private void SetInteractTextActive(
        bool active)
    {
        if (interactText != null &&
            interactText.activeSelf != active)
        {
            interactText.SetActive(active);
        }
    }
}
