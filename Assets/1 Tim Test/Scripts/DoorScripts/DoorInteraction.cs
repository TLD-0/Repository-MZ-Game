using UnityEngine;

public class DoorInteraction : MonoBehaviour
{
    [Header("References")]
    public Camera playerCamera;
    public GameObject interactText;

    [Header("Settings")]
    public float interactDistance = 3f;

    private Door currentDoor;

    void Update()
    {
        CheckDoor();

        if (Input.GetKeyDown(KeyCode.E))
        {
            Interact();
        }
    }

    void CheckDoor()
    {
        currentDoor = null;

        if (playerCamera == null)
        {
            Debug.LogError("DoorInteraction: Player Camera wurde nicht zugewiesen.");
            return;
        }

        Ray ray = new Ray(
            playerCamera.transform.position,
            playerCamera.transform.forward);

        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, interactDistance))
        {
            Door door = hit.collider.GetComponent<Door>();

            if (door != null)
            {
                currentDoor = door;

                if (interactText != null)
                    interactText.SetActive(true);

                return;
            }
        }

        if (interactText != null)
            interactText.SetActive(false);
    }

    void Interact()
    {
        if (currentDoor == null)
            return;

        if (currentDoor.destination == null)
        {
            Debug.LogError(
                "Diese Tür hat kein Destination-Objekt: " +
                currentDoor.name);
            return;
        }

        transform.position = currentDoor.destination.position;
        transform.rotation = currentDoor.destination.rotation;

        if (interactText != null)
            interactText.SetActive(false);
    }
}