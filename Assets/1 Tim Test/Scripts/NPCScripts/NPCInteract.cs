using UnityEngine;

public class NPCInteraction : MonoBehaviour
{
    public Camera playerCamera;

    public float interactDistance = 3f;

    private NPCDialogue currentNPC;

    void Update()
    {
        CheckNPC();

        if (Input.GetKeyDown(KeyCode.E))
        {
            Interact();
        }
    }

    void CheckNPC()
    {
        if (Camera.main == null)
        {
            Debug.LogError("Main Camera is NULL!");
            return;
        }

        currentNPC = null;

        Ray ray = new Ray(
            playerCamera.transform.position,
            playerCamera.transform.forward);

        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, interactDistance))
        {
            NPCDialogue npc =
                hit.collider.GetComponent<NPCDialogue>();

            if (npc != null)
            {
                currentNPC = npc;
            }
        }
    }

    void Interact()
    {
        if (currentNPC != null)
        {
            currentNPC.StartNPCDialogue();
        }
    }
}