using UnityEngine;

public class DoorInteraction : MonoBehaviour
{
    public float interactDistance = 10f;
    public GameObject interactText;

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

        Ray ray = new Ray(
            Camera.main.transform.position,
            Camera.main.transform.forward);

        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, interactDistance))
        {
            Debug.Log("Getroffen: " + hit.collider.name);

            Door door = hit.collider.GetComponent<Door>();

            if (door != null)
            {
                Debug.Log("Tür erkannt: " + door.name);

                currentDoor = door;

                if (interactText != null)
                {
                    interactText.SetActive(true);
                }

                return;
            }
        }

        if (interactText != null)
        {
            interactText.SetActive(false);
        }
    }

    void Interact()
    {
        Debug.Log("E gedrückt");

        if (currentDoor != null)
        {
            Debug.Log("Teleportiere");

            CharacterController cc = GetComponent<CharacterController>();

            if (cc != null)
            {
                cc.enabled = false;
            }

            transform.position = currentDoor.destination.position;

            if (cc != null)
            {
                cc.enabled = true;
            }
        }
    }
}