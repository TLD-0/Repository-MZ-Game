using UnityEngine;

public class PlayerQuestObjectInteraction : MonoBehaviour
{
    [Header("References")]
    public Camera playerCamera;
    public GameObject interactText;

    [Header("Settings")]
    public float interactDistance = 3f;

    private QuestInteractObject currentObject;

    void Update()
    {
        CheckObject();

        if (Input.GetKeyDown(KeyCode.E))
        {
            Interact();
        }
    }

    void CheckObject()
    {
        currentObject = null;

        if (playerCamera == null)
            return;

        Ray ray = new Ray(
            playerCamera.transform.position,
            playerCamera.transform.forward);

        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, interactDistance))
        {
            QuestInteractObject questObject =
                hit.collider.GetComponentInParent<QuestInteractObject>();

            if (questObject != null)
            {
                currentObject = questObject;

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
        if (currentObject != null)
        {
            currentObject.Interact();

            if (interactText != null)
                interactText.SetActive(false);
        }
    }
}