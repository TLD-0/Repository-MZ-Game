using System.Collections;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_Text))]
public class DialogueTextScroller : MonoBehaviour
{
    [Header("Referenzen")]
    [SerializeField]
    private TMP_Text dialogueText;

    [Tooltip("Das begrenzende Dialog Panel.")]
    [SerializeField]
    private RectTransform viewport;

    [Header("Innenabstand")]
    [SerializeField]
    private float leftPadding = 25f;

    [SerializeField]
    private float rightPadding = 25f;

    [SerializeField]
    private float topPadding = 12f;

    [SerializeField]
    private float bottomPadding = 12f;

    [Header("Animation")]
    [Tooltip("Bewegungsgeschwindigkeit in UI-Pixeln pro Sekunde.")]
    [SerializeField]
    private float scrollSpeed = 25f;

    [Tooltip("Pause, bevor ein langer Dialog zu scrollen beginnt.")]
    [SerializeField]
    private float startDelay = 1.5f;

    [Tooltip("Pause am Ende des Textes.")]
    [SerializeField]
    private float endDelay = 1f;

    [Tooltip("Bewegt den Text nach dem Ende wieder zum Anfang zurück.")]
    [SerializeField]
    private bool scrollBackToStart = true;

    private RectTransform textRect;
    private Coroutine scrollRoutine;

    private float startPositionY;
    private float endPositionY;

    private void Awake()
    {
        FindReferences();
        ConfigureText();
    }

    private void FindReferences()
    {
        if (dialogueText == null)
        {
            dialogueText = GetComponent<TMP_Text>();
        }

        if (dialogueText != null)
        {
            textRect = dialogueText.rectTransform;
        }

        if (viewport == null && transform.parent != null)
        {
            viewport = transform.parent as RectTransform;
        }
    }

    private void ConfigureText()
    {
        if (dialogueText == null)
        {
            return;
        }

        dialogueText.enableWordWrapping = true;
        dialogueText.overflowMode = TextOverflowModes.Overflow;
        dialogueText.alignment = TextAlignmentOptions.TopLeft;
        dialogueText.raycastTarget = false;
    }

    /// <summary>
    /// Setzt einen neuen Dialogtext und startet die
    /// Scrollbewegung neu.
    /// </summary>
    public void SetText(string newText)
    {
        FindReferences();

        if (dialogueText == null)
        {
            Debug.LogError(
                "DialogueTextScroller: Dialog Text fehlt.",
                this);
            return;
        }

        StopScrolling();

        dialogueText.text = newText ?? "";

        scrollRoutine =
            StartCoroutine(PrepareTextAndScroll());
    }

    private IEnumerator PrepareTextAndScroll()
    {
        /*
         * Einen Frame warten, damit Dialog Panel und
         * TextMeshPro ihre Größen aktualisiert haben.
         */
        yield return null;

        if (dialogueText == null ||
            textRect == null ||
            viewport == null)
        {
            yield break;
        }

        Canvas.ForceUpdateCanvases();

        float availableWidth =
            viewport.rect.width -
            leftPadding -
            rightPadding;

        float availableHeight =
            viewport.rect.height -
            topPadding -
            bottomPadding;

        if (availableWidth <= 0f ||
            availableHeight <= 0f)
        {
            Debug.LogError(
                "DialogueTextScroller: Der Dialogbereich ist zu klein.",
                this);
            yield break;
        }

        /*
         * Text oben im Dialogfeld verankern und horizontal
         * über die verfügbare Breite strecken.
         */
        textRect.anchorMin = new Vector2(0f, 1f);
        textRect.anchorMax = new Vector2(1f, 1f);
        textRect.pivot = new Vector2(0.5f, 1f);

        float positionX =
            (leftPadding - rightPadding) * 0.5f;

        startPositionY = -topPadding;

        textRect.anchoredPosition =
            new Vector2(positionX, startPositionY);

        /*
         * Zunächst die verfügbare Breite setzen, damit TMP
         * die notwendige mehrzeilige Höhe berechnen kann.
         */
        textRect.sizeDelta = new Vector2(
            -(leftPadding + rightPadding),
            availableHeight);

        dialogueText.ForceMeshUpdate();

        Vector2 preferredSize =
            dialogueText.GetPreferredValues(
                dialogueText.text,
                availableWidth,
                0f);

        float actualTextHeight =
            Mathf.Max(
                preferredSize.y,
                availableHeight);

        textRect.sizeDelta = new Vector2(
            -(leftPadding + rightPadding),
            actualTextHeight);

        dialogueText.ForceMeshUpdate();

        float overflowDistance =
            actualTextHeight - availableHeight;

        /*
         * Passt der Text vollständig in das Panel,
         * bleibt er einfach oben stehen.
         */
        if (overflowDistance <= 1f)
        {
            scrollRoutine = null;
            yield break;
        }

        /*
         * Der Text wird nach oben bewegt, bis sein unteres
         * Ende vollständig sichtbar war.
         */
        endPositionY =
            startPositionY + overflowDistance;

        yield return ScrollText();
    }

    private IEnumerator ScrollText()
    {
        while (true)
        {
            yield return new WaitForSecondsRealtime(
                startDelay);

            yield return MoveTextTo(endPositionY);

            yield return new WaitForSecondsRealtime(
                endDelay);

            if (!scrollBackToStart)
            {
                scrollRoutine = null;
                yield break;
            }

            yield return MoveTextTo(startPositionY);
        }
    }

    private IEnumerator MoveTextTo(float targetY)
    {
        while (Mathf.Abs(
                   textRect.anchoredPosition.y -
                   targetY) > 0.1f)
        {
            Vector2 position =
                textRect.anchoredPosition;

            position.y = Mathf.MoveTowards(
                position.y,
                targetY,
                scrollSpeed *
                Time.unscaledDeltaTime);

            textRect.anchoredPosition =
                position;

            yield return null;
        }

        Vector2 finalPosition =
            textRect.anchoredPosition;

        finalPosition.y = targetY;
        textRect.anchoredPosition =
            finalPosition;
    }

    public void StopScrolling()
    {
        if (scrollRoutine != null)
        {
            StopCoroutine(scrollRoutine);
            scrollRoutine = null;
        }

        if (textRect != null)
        {
            Vector2 position =
                textRect.anchoredPosition;

            position.y = startPositionY;
            textRect.anchoredPosition =
                position;
        }
    }

    private void OnDisable()
    {
        StopScrolling();
    }
}