using TMPro;
using UnityEngine;

public class DialogueChoiceUI : MonoBehaviour
{
    public TMP_Text choiceText;

    [SerializeField]
    private ChoiceTextMarquee textMarquee;

    private void Awake()
    {
        if (textMarquee == null)
        {
            textMarquee =
                GetComponent<ChoiceTextMarquee>();
        }
    }

    public void SetText(string text)
    {
        if (textMarquee != null)
        {
            textMarquee.SetText(text);
            return;
        }

        if (choiceText != null)
        {
            choiceText.text = text;
        }
    }
}