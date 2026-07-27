using System.Collections.Generic;
using UnityEngine;

public class NPCEmotionController : MonoBehaviour
{
    private static readonly Dictionary<
        NPCId,
        NPCEmotionController
    > registeredControllers =
        new Dictionary<NPCId, NPCEmotionController>();

    [Header("NPC")]
    [Tooltip("Muss für jeden NPC eindeutig sein.")]
    [SerializeField]
    private NPCId npcId =
        NPCId.None;

    [Header("Emotionskopf")]
    [Tooltip(
        "Der separate SpriteRenderer, der ausschließlich " +
        "den Kopf beziehungsweise die Emotion darstellt."
    )]
    [SerializeField]
    private SpriteRenderer emotionRenderer;

    [Header("Verhalten")]
    [Tooltip(
        "Blendet den Emotionskopf am Dialogende wieder aus."
    )]
    [SerializeField]
    private bool resetToNeutralOnDialogueEnd = true;

    private Sprite currentEmotionSprite;

    public NPCId Id
    {
        get { return npcId; }
    }

    private void Awake()
    {
        FindRenderer();

        /*
         * Außerhalb eines Dialogs wird zunächst nur
         * der normale Körpersprite angezeigt.
         */
        ClearEmotion();
    }

    private void OnEnable()
    {
        RegisterController();
    }

    private void OnDisable()
    {
        UnregisterController();
    }

    private void OnValidate()
    {
        FindRenderer();
    }

    private void FindRenderer()
    {
        if (emotionRenderer == null)
        {
            emotionRenderer =
                GetComponent<SpriteRenderer>();
        }
    }

    private void RegisterController()
    {
        if (npcId == NPCId.None)
        {
            Debug.LogWarning(
                "NPCEmotionController: Bei " +
                gameObject.name +
                " wurde keine NPC-ID eingetragen.",
                this);

            return;
        }

        if (registeredControllers.TryGetValue(
                npcId,
                out NPCEmotionController existingController))
        {
            if (existingController != null &&
                existingController != this)
            {
                Debug.LogError(
                    "NPCEmotionController: Die NPC-ID " +
                    npcId +
                    " wird mehrfach verwendet.",
                    this);

                return;
            }
        }

        registeredControllers[npcId] = this;
    }

    private void UnregisterController()
    {
        if (npcId == NPCId.None)
        {
            return;
        }

        if (registeredControllers.TryGetValue(
                npcId,
                out NPCEmotionController existingController) &&
            existingController == this)
        {
            registeredControllers.Remove(npcId);
        }
    }

    public static bool TryGetController(
        NPCId id,
        out NPCEmotionController controller)
    {
        if (id == NPCId.None)
        {
            controller = null;
            return false;
        }

        return registeredControllers.TryGetValue(
                   id,
                   out controller) &&
               controller != null;
    }

    public bool SetEmotionSprite(
        Sprite newEmotionSprite)
    {
        /*
         * Kein Sprite ausgewählt:
         * Die bisherige Emotion bleibt bestehen.
         */
        if (newEmotionSprite == null)
        {
            return false;
        }

        if (emotionRenderer == null)
        {
            Debug.LogError(
                "NPCEmotionController: Emotions-SpriteRenderer fehlt.",
                this);

            return false;
        }

        currentEmotionSprite =
            newEmotionSprite;

        emotionRenderer.sprite =
            newEmotionSprite;

        emotionRenderer.enabled =
            true;

        Debug.Log(
            "NPC " +
            npcId +
            " zeigt jetzt den Emotionssprite " +
            newEmotionSprite.name);

        return true;
    }

    public void ClearEmotion()
    {
        currentEmotionSprite = null;

        if (emotionRenderer == null)
        {
            return;
        }

        emotionRenderer.sprite = null;
        emotionRenderer.enabled = false;
    }

    public void OnDialogueEnded()
    {
        if (resetToNeutralOnDialogueEnd)
        {
            ClearEmotion();
        }
    }
}