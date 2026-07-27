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
        currentPhoneQuest =
            hit.collider.GetComponentInParent<
                PhoneSequenceQuest>();

        if (currentPhoneQuest != null)
        {
            return;
        }

        currentDrinkQuest =
            hit.collider.GetComponentInParent<
                DrinkSequenceTest>();
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
