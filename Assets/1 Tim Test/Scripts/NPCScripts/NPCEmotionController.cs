using UnityEngine;

public class NPCEmotionController : MonoBehaviour
{
    [Header("Sprite Renderer")]
    public SpriteRenderer spriteRenderer;

    [Header("Emotion Sprites")]
    public Sprite neutralSprite;
    public Sprite happySprite;
    public Sprite sadSprite;
    public Sprite angrySprite;
    public Sprite surprisedSprite;

    private void Awake()
    {
        if (spriteRenderer == null)
        {
            spriteRenderer = GetComponent<SpriteRenderer>();
        }
    }

    public void SetEmotion(NPCEmotion emotion)
    {
        Sprite newSprite = null;

        switch (emotion)
        {
            case NPCEmotion.Neutral:
                newSprite = neutralSprite;
                break;

            case NPCEmotion.Happy:
                newSprite = happySprite;
                break;

            case NPCEmotion.Sad:
                newSprite = sadSprite;
                break;

            case NPCEmotion.Angry:
                newSprite = angrySprite;
                break;

            case NPCEmotion.Surprised:
                newSprite = surprisedSprite;
                break;
        }

        if (newSprite == null)
        {
            Debug.LogWarning(
                "NPCEmotionController: Für " + emotion +
                " wurde kein Sprite zugewiesen.");
            return;
        }

        spriteRenderer.sprite = newSprite;
    }
}