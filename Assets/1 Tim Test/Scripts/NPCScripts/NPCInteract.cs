using UnityEngine;

public class NPCInteraction : MonoBehaviour
{
    public Camera playerCamera;
    public float interactDistance = 3f;

    private NPCDialogue currentNPC;
    private NPCQuestDialogue currentQuestNPC;
    private QuestInteractObject currentQuestObject;

    private PhoneSequenceQuest currentPhoneQuest;
    private DrinkSequenceTest currentDrinkQuest;

    void Update()
        {
            CheckInteractable();

            if (Input.GetKeyDown(KeyCode.E))
            {
                Interact();
            }
        }

    void CheckInteractable()
    {
        currentNPC = null;
        currentQuestNPC = null;
        currentPhoneQuest = null;
        currentDrinkQuest = null;

        if (playerCamera == null)
        {
            Debug.LogError(
                "NPCInteraction: Player Camera wurde nicht zugewiesen.");

            return;
        }

        Ray ray = new Ray(
            playerCamera.transform.position,
            playerCamera.transform.forward);

        RaycastHit hit;

        if (!Physics.Raycast(
                ray,
                out hit,
                interactDistance))
        {
            return;
        }
        
        /*
        * Allgemeine Quest-Sperre.
        *
        * Liegt InteractionQuestGate auf dem getroffenen Objekt
        * oder einem Parent, wird jede Art von Interaktion blockiert,
        * bis alle eingetragenen Quests abgeschlossen sind.
        */
        InteractionQuestGate interactionGate =
            hit.collider.GetComponentInParent<
                InteractionQuestGate>();

        if (interactionGate != null &&
            !interactionGate.IsUnlocked())
        {
            return;
        }

        /*
        * Zuerst nach einem Quest-NPC suchen.
        */
        NPCQuestDialogue foundQuestNPC =
            hit.collider.GetComponentInParent<
                NPCQuestDialogue>();

        if (foundQuestNPC != null)
        {
            NPCStoryRequirement storyRequirement =
                foundQuestNPC.GetComponentInParent<
                    NPCStoryRequirement>();

            /*
            * Der NPC wurde getroffen, ist aber noch
            * nicht durch den Storyfortschritt freigeschaltet.
            */
            if (storyRequirement != null &&
                !storyRequirement.IsUnlocked())
            {
                currentQuestNPC = null;
                return;
            }

            currentQuestNPC = foundQuestNPC;
            return;
        }

        /*
        * Danach nach einem normalen Dialog-NPC suchen.
        */
        NPCDialogue foundNPC =
            hit.collider.GetComponentInParent<
                NPCDialogue>();

        if (foundNPC != null)
        {
            NPCStoryRequirement storyRequirement =
                foundNPC.GetComponentInParent<
                    NPCStoryRequirement>();

            if (storyRequirement != null &&
                !storyRequirement.IsUnlocked())
            {
                currentNPC = null;
                return;
            }

            currentNPC = foundNPC;
            return;
        }

        /*
        * Questobjekte werden nicht durch
        * NPCStoryRequirement eingeschränkt.
        */
        PhoneSequenceQuest foundPhoneQuest =
            hit.collider.GetComponentInParent<
                PhoneSequenceQuest>();

        if (foundPhoneQuest != null)
        {
            if (foundPhoneQuest.CanInteract())
            {
                currentPhoneQuest =
                    foundPhoneQuest;
            }

            /*
            * Das getroffene Objekt ist ein Telefon.
            * Ist seine Quest nicht aktiv, wird es nicht
            * als anderes Questobjekt interpretiert.
            */
            return;
        }
        
        DrinkSequenceTest foundDrinkQuest =
            hit.collider.GetComponentInParent<
                DrinkSequenceTest>();

        if (foundDrinkQuest != null &&
            foundDrinkQuest.CanInteract())
        {
            currentDrinkQuest =
                foundDrinkQuest;
        }
    }

    void Interact()
    {
        if (currentQuestNPC != null)
        {
            currentQuestNPC.StartNPCDialogue();
            return;
        }

        if (currentNPC != null)
        {
            currentNPC.StartNPCDialogue();
            return;
        }

        if (currentPhoneQuest != null)
        {
            currentPhoneQuest.StartPhoneQuest();
            return;
        }

        if (currentDrinkQuest != null)
        {
            currentDrinkQuest.StartDrinkTest();
        } 
    }
}
