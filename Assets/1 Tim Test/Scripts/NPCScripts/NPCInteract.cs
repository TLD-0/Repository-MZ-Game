using UnityEngine;

public class NPCInteraction : MonoBehaviour
{
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
        currentNPC = null;

        Ray ray = new Ray(
            Camera.main.transform.position,
            Camera.main.transform.forward);

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