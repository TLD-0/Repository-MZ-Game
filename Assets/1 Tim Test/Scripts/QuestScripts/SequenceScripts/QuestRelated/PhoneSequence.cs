using UnityEngine;

public class PhoneSequenceTest : MonoBehaviour
{
[Header("Dialog")]
public DialogueData phoneDialogue;


[Header("Dialog Positionen")]
public Transform playerPoint;
public Transform cameraPoint;
public NPCEmotionController emotionController;

public void StartPhoneTest()
{
    if (SequenceChoiceManager.Instance == null)
    {
        Debug.LogError(
            "PhoneSequenceTest: SequenceChoiceManager fehlt.");
        return;
    }

    if (DialogueManager.Instance == null)
    {
        Debug.LogError(
            "PhoneSequenceTest: DialogueManager fehlt.");
        return;
    }

    if (phoneDialogue == null)
    {
        Debug.LogError(
            "PhoneSequenceTest: Phone Dialogue fehlt.");
        return;
    }

    SequenceChoiceManager.Instance.StartSequence("Telefon");

    DialogueManager.Instance.StartDialogue(
        phoneDialogue,
        playerPoint,
        cameraPoint,
        emotionController);
    }
}