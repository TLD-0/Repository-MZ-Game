using System;
using UnityEngine;
using UnityEngine.UI;

public class PlayerEmotionPortrait : MonoBehaviour
{
    [Serializable]
    public class EmotionSprite
    {
        [Tooltip("Emotion, die im Dialog ausgewählt wird.")]
        public PlayerEmotion emotion;

        [Tooltip("Sprite, das für diese Emotion angezeigt wird.")]
        public Sprite sprite;
    }

    [Header("UI")]
    [Tooltip("Das sichtbare Portrait-Objekt, das ein- und ausgeblendet wird.")]
    [SerializeField]
    private GameObject portraitRoot;

    [Tooltip("Die UI-Image-Komponente, auf der das Portrait angezeigt wird.")]
    [SerializeField]
    private Image portraitImage;

    [Header("Emotionen")]
    [SerializeField]
    private EmotionSprite[] emotionSprites;

    [Header("Startemotion")]
    [SerializeField]
    private PlayerEmotion startEmotion =
        PlayerEmotion.Neutral;

    private PlayerEmotion currentEmotion;

    private void Awake()
    {
        if (portraitImage == null &&
            portraitRoot != null)
        {
            portraitImage =
                portraitRoot.GetComponent<Image>();

            if (portraitImage == null)
            {
                portraitImage =
                    portraitRoot.GetComponentInChildren<Image>(true);
            }
        }

        if (portraitRoot == null)
        {
            Debug.LogError(
                "PlayerEmotionPortrait: Portrait Root fehlt.",
                this);

            return;
        }

        if (portraitImage == null)
        {
            Debug.LogError(
                "PlayerEmotionPortrait: Portrait Image fehlt.",
                this);

            return;
        }

        SetEmotion(startEmotion);
        HidePortrait();
    }

    public void ShowPortrait()
    {
        if (portraitRoot == null)
        {
            return;
        }

        portraitRoot.SetActive(true);
    }

    public void HidePortrait()
    {
        if (portraitRoot == null)
        {
            return;
        }

        portraitRoot.SetActive(false);
    }

    public void SetEmotion(PlayerEmotion emotion)
    {
        if (portraitImage == null)
        {
            Debug.LogError(
                "PlayerEmotionPortrait: Portrait Image fehlt.",
                this);

            return;
        }

        Sprite emotionSprite =
            FindEmotionSprite(emotion);

        if (emotionSprite == null)
        {
            Debug.LogWarning(
                "PlayerEmotionPortrait: Für die Emotion " +
                emotion +
                " wurde kein Sprite eingetragen.",
                this);

            return;
        }

        currentEmotion = emotion;
        portraitImage.sprite = emotionSprite;

        Debug.Log(
            "Spielerportrait wechselt zu: " +
            currentEmotion);
    }

    private Sprite FindEmotionSprite(
        PlayerEmotion emotion)
    {
        if (emotionSprites == null)
        {
            return null;
        }

        for (int i = 0;
             i < emotionSprites.Length;
             i++)
        {
            EmotionSprite entry =
                emotionSprites[i];

            if (entry == null)
            {
                continue;
            }

            if (entry.emotion == emotion)
            {
                return entry.sprite;
            }
        }

        return null;
    }
}