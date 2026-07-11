using TMPro;
using UnityEngine;

public class DialogueChoiceUI : MonoBehaviour
{
    public TMP_Text choiceText;

    public void SetText(string text)
    {
        choiceText.text = text;
    }
}