using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
[RequireComponent(typeof(RectMask2D))]
public class ChoiceTextMarquee : MonoBehaviour
{
    [Header("Referenzen")]
    [SerializeField]
    private TMP_Text choiceText;

    [Tooltip("Normalerweise das RectTransform von ChoiceX.")]
    [SerializeField]
    private RectTransform viewport;

    [Header("Abstände")]
    [SerializeField]
    private float leftPadding = 12f;

    [SerializeField]
    private float rightPadding = 12f;

    [Header("Animation")]
    [Tooltip("Bewegungsgeschwindigkeit in UI-Pixeln pro Sekunde.")]
    [SerializeField]
    private float scrollSpeed = 40f;

    [Tooltip("Pause, bevor sich ein langer Text bewegt.")]
    [SerializeField]
    private float startDelay = 1f;

    [Tooltip("Pause, wenn das Ende des Textes erreicht wurde.")]
    [SerializeField]
    private float endDelay = 0.7f;

    private RectTransform textRect;
    private Coroutine scrollRoutine;

    private float startPositionX;
    private float endPositionX;

    private void Awake()
    {
        if (viewport == null)
        {
            viewport = transform as RectTransform;
        }

        if (choiceText == null)
        {
            choiceText = GetComponentInChildren<TMP_Text>();
        }

        if (choiceText != null)
        {
            textRect = choiceText.rectTransform;
        }
    }

    public void SetText(string newText)
    {
        if (choiceText == null)
        {
            Debug.LogError(
                "ChoiceTextMarquee: Kein TMP_Text zugewiesen.",
                this);

            return;
        }

        choiceText.text = newText;
        RestartMarquee();
    }

    public void RestartMarquee()
    {
        if (scrollRoutine != null)
        {
            StopCoroutine(scrollRoutine);
            scrollRoutine = null;
        }

        scrollRoutine = StartCoroutine(PrepareMarquee());
    }

    private IEnumerator PrepareMarquee()
    {
        // Auf das Layout des Grid Layout Groups warten.
        yield return null;

        if (choiceText == null ||
            textRect == null ||
            viewport == null)
        {
            yield break;
        }

        Canvas.ForceUpdateCanvases();

        choiceText.enableWordWrapping = false;
        choiceText.overflowMode = TextOverflowModes.Overflow;
        choiceText.alignment = TextAlignmentOptions.MidlineLeft;

        choiceText.ForceMeshUpdate();

        float availableWidth =
            viewport.rect.width -
            leftPadding -
            rightPadding;

        if (availableWidth <= 0f)
        {
            yield break;
        }

        float preferredTextWidth =
            Mathf.Ceil(choiceText.preferredWidth);

        // Text links ausrichten und vertikal über das Feld strecken.
        textRect.anchorMin = new Vector2(0f, 0f);
        textRect.anchorMax = new Vector2(0f, 1f);
        textRect.pivot = new Vector2(0f, 0.5f);

        float actualTextWidth =
            Mathf.Max(preferredTextWidth, availableWidth);

        textRect.sizeDelta =
            new Vector2(actualTextWidth, 0f);

        startPositionX = leftPadding;

        textRect.anchoredPosition =
            new Vector2(startPositionX, 0f);

        float overflowDistance =
            preferredTextWidth - availableWidth;

        // Kurzer Text bleibt normal stehen.
        if (overflowDistance <= 1f)
        {
            scrollRoutine = null;
            yield break;
        }

        endPositionX =
            startPositionX - overflowDistance;

        yield return AnimateText();
    }

    private IEnumerator AnimateText()
    {
        while (true)
        {
            yield return new WaitForSecondsRealtime(startDelay);

            yield return MoveTextTo(endPositionX);

            yield return new WaitForSecondsRealtime(endDelay);

            yield return MoveTextTo(startPositionX);
        }
    }

    private IEnumerator MoveTextTo(float targetX)
    {
        while (Mathf.Abs(
                   textRect.anchoredPosition.x -
                   targetX) > 0.1f)
        {
            float newX = Mathf.MoveTowards(
                textRect.anchoredPosition.x,
                targetX,
                scrollSpeed * Time.unscaledDeltaTime);

            textRect.anchoredPosition =
                new Vector2(newX, 0f);

            yield return null;
        }

        textRect.anchoredPosition =
            new Vector2(targetX, 0f);
    }

    private void OnDisable()
    {
        if (scrollRoutine != null)
        {
            StopCoroutine(scrollRoutine);
            scrollRoutine = null;
        }
    }
}