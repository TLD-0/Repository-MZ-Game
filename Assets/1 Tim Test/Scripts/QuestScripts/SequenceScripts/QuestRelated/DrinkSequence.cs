using System;
using UnityEngine;
using UnityEngine.Events;

public class DrinkSequenceTest : MonoBehaviour
{
    [Serializable]
    public class DrinkRecipe
    {
        [Header("Antwortkombination")]
        [Tooltip(
            "Zweistellige Kombination wie AA, AB oder BC. " +
            "Wenn das Feld leer ist, wird der Name des Drink Objects verwendet."
        )]
        public string sequence = "AA";

        [Header("3D-Objekt")]
        [Tooltip(
            "Das Objekt, das bei dieser Kombination ausgegeben wird."
        )]
        public Transform drinkObject;

        [Tooltip(
            "Position, zu der das Objekt beim Zurücksetzen bewegt wird."
        )]
        public Transform pointA;

        [Tooltip(
            "Optionaler eigener Zielpunkt. Wenn das Feld leer ist, " +
            "wird der allgemeine Ausgabe-Punkt verwendet."
        )]
        public Transform pointB;

        [Header("Optionales Event")]
        public UnityEvent onDrinkCreated;
    }

    [Header("Dialog")]
    [Tooltip(
        "Dialog mit zwei Auswahl-Nodes. Jeder Auswahl-Node enthält A, B und C."
    )]
    [SerializeField]
    private DialogueData drinkDialogue;

    [Header("Dialogpositionen")]
    [SerializeField]
    private Transform playerPoint;

    [SerializeField]
    private Transform cameraPoint;

    [SerializeField]
    private NPCEmotionController emotionController;

    [Header("Getränke und Kombinationen")]
    [SerializeField]
    private DrinkRecipe[] drinkRecipes;

    [Header("Ausgabe")]
    [SerializeField]
    private Transform defaultOutputPoint;

    [Header("Einstellungen")]
    [SerializeField]
    private bool resetDrinksOnStart = true;

    [Header("Questabschluss")]
    [Tooltip(
        "Aktiviert: Jede gültige Drinkkombination schließt die eingetragene Quest ab."
    )]
    [SerializeField]
    private bool completeQuestAfterValidDrink = true;

    [SerializeField]
    [Range(1, 16)]
    private int questIDToComplete = 14;

    [Tooltip(
        "Optionaler alter Sequenz-Checker. Für dein System mit neun gültigen " +
        "Drinks sollte diese Option deaktiviert bleiben."
    )]
    [SerializeField]
    private bool useOptionalQuestChecker;

    [SerializeField]
    private SequenceQuestChecker questChecker;

    [Header("Interaktionsfreigabe")]
    [SerializeField]
    private bool requireActiveQuest = true;

    [SerializeField]
    [Range(1, 16)]
    private int requiredQuestID = 14;

    private const int RequiredChoiceCount = 2;

    private bool sequenceRunning;
    private bool inputLocked;

    public bool CanInteract()
    {
        if (!requireActiveQuest)
        {
            return true;
        }

        if (QuestManager.Instance == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: QuestManager wurde nicht gefunden.",
                this);

            return false;
        }

        return QuestManager.Instance.IsQuestActive(
            requiredQuestID);
    }

    private void Update()
    {
        if (!sequenceRunning ||
            inputLocked)
        {
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        int choiceCount =
            SequenceChoiceManager.Instance.GetCount();

        if (choiceCount >= RequiredChoiceCount)
        {
            if (choiceCount > RequiredChoiceCount)
            {
                Debug.LogError(
                    "DrinkSequenceTest: Es wurden mehr als zwei Werte gespeichert. " +
                    "Prüfe die Adds Sequence Value-Einstellungen im Dialog.",
                    this);
            }

            inputLocked = true;
            ResolveDrinkSequence();
            return;
        }

        /*
         * Wird der Dialog mit Escape oder durch ein anderes Script beendet,
         * wird die Bar wieder freigegeben.
         */
        if (DialogueManager.Instance != null &&
            !DialogueManager.Instance.IsDialogueActive)
        {
            CancelDrinkSequence();
        }
    }

    public void StartDrinkTest()
    {
        if (!CanInteract())
        {
            Debug.Log(
                "DrinkSequenceTest: Die Drink-Sequenz kann erst gestartet werden, " +
                "wenn Quest " +
                requiredQuestID +
                " aktiv ist.",
                this);

            return;
        }

        if (sequenceRunning)
        {
            Debug.Log(
                "DrinkSequenceTest: Die Drink-Sequenz läuft bereits.",
                this);

            return;
        }

        if (!ValidateStart())
        {
            return;
        }

        if (resetDrinksOnStart)
        {
            ResetAllDrinkObjects();
        }

        sequenceRunning = true;
        inputLocked = false;

        SequenceChoiceManager.Instance.StartSequence(
            "Drink");

        DialogueManager.Instance.StartDialogue(
            drinkDialogue,
            playerPoint,
            cameraPoint,
            emotionController);

        Debug.Log(
            "DrinkSequenceTest: Drink-Dialog gestartet.",
            this);
    }

    private void ResolveDrinkSequence()
    {
        string selectedSequence =
            GetCurrentSequenceAsLetters();

        sequenceRunning = false;

        DrinkRecipe matchingRecipe =
            FindRecipe(selectedSequence);

        if (matchingRecipe == null)
        {
            Debug.LogWarning(
                "DrinkSequenceTest: Für die Kombination " +
                selectedSequence +
                " wurde kein passendes Getränk gefunden.",
                this);

            inputLocked = false;
            return;
        }

        if (!TeleportDrink(matchingRecipe))
        {
            inputLocked = false;
            return;
        }

        matchingRecipe.onDrinkCreated?.Invoke();

        if (completeQuestAfterValidDrink)
        {
            if (QuestManager.Instance == null)
            {
                Debug.LogError(
                    "DrinkSequenceTest: QuestManager fehlt.",
                    this);
            }
            else
            {
                QuestManager.Instance.CompleteQuest(
                    questIDToComplete);
            }
        }

        if (useOptionalQuestChecker)
        {
            if (questChecker == null)
            {
                Debug.LogError(
                    "DrinkSequenceTest: Optionaler Quest Checker ist aktiviert, " +
                    "aber nicht zugewiesen.",
                    this);
            }
            else
            {
                questChecker.CheckSequence();
            }
        }

        inputLocked = false;

        Debug.Log(
            "DrinkSequenceTest: Kombination " +
            selectedSequence +
            " wurde erfolgreich erzeugt.",
            this);
    }

    public void CancelDrinkSequence()
    {
        sequenceRunning = false;
        inputLocked = false;

        if (SequenceChoiceManager.Instance != null)
        {
            SequenceChoiceManager.Instance.StartSequence(
                "Drink");
        }

        Debug.Log(
            "DrinkSequenceTest: Drink-Sequenz wurde zurückgesetzt.",
            this);
    }

    private bool ValidateStart()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: SequenceChoiceManager fehlt.",
                this);

            return false;
        }

        if (DialogueManager.Instance == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: DialogueManager fehlt.",
                this);

            return false;
        }

        if (drinkDialogue == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Drink Dialogue fehlt.",
                this);

            return false;
        }

        if (playerPoint == null ||
            cameraPoint == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Player Point oder Camera Point fehlt.",
                this);

            return false;
        }

        if (drinkRecipes == null ||
            drinkRecipes.Length == 0)
        {
            Debug.LogError(
                "DrinkSequenceTest: Keine Drink Recipes eingetragen.",
                this);

            return false;
        }

        return true;
    }

    private DrinkRecipe FindRecipe(
        string selectedSequence)
    {
        if (drinkRecipes == null)
        {
            return null;
        }

        for (int i = 0;
             i < drinkRecipes.Length;
             i++)
        {
            DrinkRecipe recipe =
                drinkRecipes[i];

            if (recipe == null)
            {
                continue;
            }

            if (GetRecipeSequence(recipe) ==
                selectedSequence)
            {
                return recipe;
            }
        }

        return null;
    }

    private string GetRecipeSequence(
        DrinkRecipe recipe)
    {
        if (string.IsNullOrWhiteSpace(recipe.sequence))
        {
            if (recipe.drinkObject == null)
            {
                return "";
            }

            return NormalizeSequence(
                recipe.drinkObject.name);
        }

        return NormalizeSequence(
            recipe.sequence);
    }

    private bool TeleportDrink(
        DrinkRecipe recipe)
    {
        if (recipe.drinkObject == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Bei Kombination " +
                GetRecipeSequence(recipe) +
                " fehlt das Drink Object.",
                this);

            return false;
        }

        Transform targetPoint =
            recipe.pointB != null
                ? recipe.pointB
                : defaultOutputPoint;

        if (targetPoint == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Bei Kombination " +
                GetRecipeSequence(recipe) +
                " fehlt ein Zielpunkt.",
                this);

            return false;
        }

        recipe.drinkObject.SetPositionAndRotation(
            targetPoint.position,
            targetPoint.rotation);

        return true;
    }

    public void ResetAllDrinkObjects()
    {
        if (drinkRecipes == null)
        {
            return;
        }

        for (int i = 0;
             i < drinkRecipes.Length;
             i++)
        {
            DrinkRecipe recipe =
                drinkRecipes[i];

            if (recipe == null ||
                recipe.drinkObject == null ||
                recipe.pointA == null)
            {
                continue;
            }

            recipe.drinkObject.SetPositionAndRotation(
                recipe.pointA.position,
                recipe.pointA.rotation);
        }
    }

    private string GetCurrentSequenceAsLetters()
    {
        if (SequenceChoiceManager.Instance == null)
        {
            return "";
        }

        string result = "";

        int count =
            Mathf.Min(
                SequenceChoiceManager.Instance.GetCount(),
                RequiredChoiceCount);

        for (int i = 0;
             i < count;
             i++)
        {
            int value =
                SequenceChoiceManager.Instance.GetValue(i);

            switch (value)
            {
                case 1:
                    result += "A";
                    break;

                case 2:
                    result += "B";
                    break;

                case 3:
                    result += "C";
                    break;

                default:
                    result += "?";
                    break;
            }
        }

        return result;
    }

    private static string NormalizeSequence(
        string sequence)
    {
        if (string.IsNullOrWhiteSpace(sequence))
        {
            return "";
        }

        return sequence
            .Trim()
            .ToUpperInvariant();
    }
}
