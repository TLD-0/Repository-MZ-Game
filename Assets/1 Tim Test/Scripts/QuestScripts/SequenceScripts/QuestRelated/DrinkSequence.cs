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
            "Das Objekt, das bei dieser Kombination ausgegeben wird. " +
            "Das Objekt kann beispielsweise AA, AB oder BC heißen."
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
        [Tooltip(
            "Wird ausgeführt, nachdem das Getränk ausgegeben wurde."
        )]
        public UnityEvent onDrinkCreated;
    }

    [Header("Dialog")]
    [Tooltip(
        "Dialog mit zwei Nodes. Jeder Node enthält die Antworten A, B und C."
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
    [Tooltip(
        "Allgemeiner Zielpunkt für alle Getränke. " +
        "Kann pro Rezept durch Point B überschrieben werden."
    )]
    [SerializeField]
    private Transform defaultOutputPoint;

    [Header("Einstellungen")]
    [Tooltip(
        "Setzt alle Getränke beim Start der Interaktion zurück zu Point A."
    )]
    [SerializeField]
    private bool resetDrinksOnStart = true;

    [Header("Optionaler Quest-Checker")]
    [Tooltip(
        "Nur notwendig, wenn eine bestimmte Kombination " +
        "eine Quest abschließen soll."
    )]
    [SerializeField]
    private SequenceQuestChecker questChecker;

    private const int RequiredChoiceCount = 2;

    private bool sequenceRunning;
    private bool inputLocked;

    private void Awake()
    {
        if (questChecker == null)
        {
            questChecker =
                GetComponent<SequenceQuestChecker>();
        }
    }

    private void Update()
    {
        if (!sequenceRunning || inputLocked)
        {
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            return;
        }

        int choiceCount =
            SequenceChoiceManager.Instance.GetCount();

        if (choiceCount == RequiredChoiceCount)
        {
            inputLocked = true;
            ResolveDrinkSequence();
            return;
        }

        if (choiceCount > RequiredChoiceCount)
        {
            inputLocked = true;
            sequenceRunning = false;

            Debug.LogError(
                "DrinkSequenceTest: Es wurden mehr als zwei Werte gespeichert. " +
                "Prüfe, ob die Dialogantworten einen Wert doppelt hinzufügen."
            );
        }
    }

    /// <summary>
    /// Wird durch NPCInteraction aufgerufen,
    /// wenn der Spieler das Questobjekt ansieht und E drückt.
    /// </summary>
    public void StartDrinkTest()
    {
        if (sequenceRunning)
        {
            Debug.Log(
                "DrinkSequenceTest: Die Drink-Sequenz läuft bereits.");
            return;
        }

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
            emotionController
        );

        Debug.Log(
            "DrinkSequenceTest: Drink-Dialog gestartet.");
    }

    private void ResolveDrinkSequence()
    {
        string selectedSequence =
            GetCurrentSequenceAsLetters();

        sequenceRunning = false;

        Debug.Log(
            "DrinkSequenceTest: Fertige Kombination: " +
            selectedSequence);

        DrinkRecipe matchingRecipe =
            FindRecipe(selectedSequence);

        if (matchingRecipe == null)
        {
            Debug.LogWarning(
                "DrinkSequenceTest: Für die Kombination " +
                selectedSequence +
                " wurde kein passendes Getränk gefunden.");

            return;
        }

        bool wasTeleported =
            TeleportDrink(matchingRecipe);

        if (!wasTeleported)
        {
            return;
        }

        matchingRecipe.onDrinkCreated?.Invoke();

        /*
         * Optional:
         * Der Checker prüft beispielsweise, ob AA die richtige
         * Questkombination ist.
         */
        if (questChecker != null)
        {
            questChecker.CheckSequence();
        }
    }

    private DrinkRecipe FindRecipe(
        string selectedSequence)
    {
        if (drinkRecipes == null ||
            drinkRecipes.Length == 0)
        {
            Debug.LogError(
                "DrinkSequenceTest: Keine Drink Recipes eingetragen.");

            return null;
        }

        for (int i = 0; i < drinkRecipes.Length; i++)
        {
            DrinkRecipe recipe =
                drinkRecipes[i];

            if (recipe == null)
            {
                continue;
            }

            string recipeSequence =
                GetRecipeSequence(recipe);

            if (recipeSequence == selectedSequence)
            {
                return recipe;
            }
        }

        return null;
    }

    private string GetRecipeSequence(
        DrinkRecipe recipe)
    {
        /*
         * Falls Sequence leer ist, wird automatisch
         * der Name des 3D-Objekts verwendet.
         *
         * Beispiel:
         * Objektname "AB" ergibt Kombination AB.
         */
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
                " fehlt das Drink Object.");

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
                " fehlt ein Zielpunkt.");

            return false;
        }

        recipe.drinkObject.SetPositionAndRotation(
            targetPoint.position,
            targetPoint.rotation
        );

        Debug.Log(
            "DrinkSequenceTest: Getränk " +
            recipe.drinkObject.name +
            " für Kombination " +
            GetRecipeSequence(recipe) +
            " wurde ausgegeben.");

        return true;
    }

    public void ResetAllDrinkObjects()
    {
        if (drinkRecipes == null)
        {
            return;
        }

        for (int i = 0; i < drinkRecipes.Length; i++)
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
                recipe.pointA.rotation
            );
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

        for (int i = 0; i < count; i++)
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