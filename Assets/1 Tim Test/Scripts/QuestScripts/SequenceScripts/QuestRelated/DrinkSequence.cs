using UnityEngine;

public class DrinkSequenceTest : MonoBehaviour
{
[Header("Dialog")]
public DialogueData drinkDialogue;


[Header("Dialog Positionen")]
public Transform playerPoint;
public Transform cameraPoint;

public void StartDrinkTest()
{
    if (SequenceChoiceManager.Instance == null)
    {
        Debug.LogError(
            "DrinkSequenceTest: SequenceChoiceManager fehlt.");
        return;
    }

    if (DialogueManager.Instance == null)
    {
        Debug.LogError(
            "DrinkSequenceTest: DialogueManager fehlt.");
        return;
    }

    if (drinkDialogue == null)
    {
        Debug.LogError(
            "DrinkSequenceTest: Drink Dialogue fehlt.");
        return;
    }

    SequenceChoiceManager.Instance.StartSequence("Drink");

    DialogueManager.Instance.StartDialogue(
        drinkDialogue,
        playerPoint,
        cameraPoint);
}


}
