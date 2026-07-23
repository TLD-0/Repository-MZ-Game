using System;
using UnityEngine;
using UnityEngine.Events;

public class DrinkSequenceTest : MonoBehaviour
{
    [Serializable]
    public class DrinkRecipe
    {
        [Header("Antwortkombination")]
        [Tooltip("Genau drei Buchstaben: A, B oder C. Beispiel: AAB")]
        public string sequence = "AAA";

        [Header("3D-Objekt")]
        [Tooltip("Das Objekt, das nach der fertigen Kombination erscheinen soll.")]
        public Transform drinkObject;

        [Tooltip("Ausgangsposition des Objekts.")]
        public Transform pointA;

        [Tooltip("Zielposition des Objekts.")]
        public Transform pointB;

        [Header("Optionales Event")]
        [Tooltip("Wird ausgelöst, nachdem das Getränk teleportiert wurde.")]
        public UnityEvent onDrinkCreated;
    }

    [Header("Dialog")]
    public DialogueData drinkDialogue;

    [Header("Dialog-Positionen")]
    public Transform playerPoint;
    public Transform cameraPoint;
    public NPCEmotionController emotionController;

    [Header("Getränke und Kombinationen")]
    [SerializeField]
    private DrinkRecipe[] drinkRecipes;

    [Header("Einstellungen")]
    [SerializeField]
    private bool resetDrinksOnStart = true;

    [Header("Optionaler Quest-Checker")]
    [Tooltip(
        "Optional: Hier kann ein vorhandener SequenceQuestChecker " +
        "eingetragen werden, falls nur eine bestimmte Kombination korrekt ist."
    )]
    [SerializeField]
    private SequenceQuestChecker questChecker;

    private const int RequiredChoiceCount = 3;

    private bool sequenceRunning;
    private bool inputLocked;

    public void StartDrinkTest()
    {
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

        SequenceChoiceManager.Instance.StartSequence("Drink");

        DialogueManager.Instance.StartDialogue(
            drinkDialogue,
            playerPoint,
            cameraPoint,
            emotionController
        );
    }

    // Diese drei Methoden werden von den Dialogantworten aufgerufen.

    public void ChooseA()
    {
        AddDrinkChoice(1);
    }

    public void ChooseB()
    {
        AddDrinkChoice(2);
    }

    public void ChooseC()
    {
        AddDrinkChoice(3);
    }

    private void AddDrinkChoice(int value)
    {
        if (!sequenceRunning)
        {
            Debug.LogWarning(
                "DrinkSequenceTest: Es läuft derzeit keine Drink-Sequenz.");
            return;
        }

        if (inputLocked)
        {
            Debug.LogWarning(
                "DrinkSequenceTest: Die drei Antworten wurden bereits ausgewählt.");
            return;
        }

        if (SequenceChoiceManager.Instance == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: SequenceChoiceManager fehlt.");
            return;
        }

        SequenceChoiceManager.Instance.AddValue(value);

        int currentCount =
            SequenceChoiceManager.Instance.GetCount();

        Debug.Log(
            "Drink-Auswahl " +
            currentCount +
            " von " +
            RequiredChoiceCount +
            " gespeichert."
        );

        if (currentCount == RequiredChoiceCount)
        {
            inputLocked = true;
            ResolveDrinkSequence();
        }
    }

    private void ResolveDrinkSequence()
    {
        string selectedSequence = GetCurrentSequenceAsLetters();

        Debug.Log(
            "Fertige Drink-Sequenz: " + selectedSequence);

        DrinkRecipe matchingRecipe =
            FindRecipe(selectedSequence);

        if (matchingRecipe == null)
        {
            Debug.LogWarning(
                "DrinkSequenceTest: Für die Kombination " +
                selectedSequence +
                " wurde kein Getränk eingetragen."
            );

            sequenceRunning = false;
            return;
        }

        TeleportDrink(matchingRecipe);

        if (matchingRecipe.onDrinkCreated != null)
        {
            matchingRecipe.onDrinkCreated.Invoke();
        }

        // Optional: Überprüft, ob diese Kombination
        // die richtige Quest-Kombination ist.
        if (questChecker != null)
        {
            questChecker.CheckSequence();
        }

        sequenceRunning = false;
    }

    private DrinkRecipe FindRecipe(string selectedSequence)
    {
        if (drinkRecipes == null)
        {
            return null;
        }

        for (int i = 0; i < drinkRecipes.Length; i++)
        {
            DrinkRecipe recipe = drinkRecipes[i];

            if (recipe == null)
            {
                continue;
            }

            string recipeSequence =
                NormalizeSequence(recipe.sequence);

            if (recipeSequence == selectedSequence)
            {
                return recipe;
            }
        }

        return null;
    }

    private void TeleportDrink(DrinkRecipe recipe)
    {
        if (recipe.drinkObject == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Bei Kombination " +
                recipe.sequence +
                " fehlt das 3D-Objekt."
            );
            return;
        }

        if (recipe.pointB == null)
        {
            Debug.LogError(
                "DrinkSequenceTest: Bei Kombination " +
                recipe.sequence +
                " fehlt Punkt B."
            );
            return;
        }

        recipe.drinkObject.SetPositionAndRotation(
            recipe.pointB.position,
            recipe.pointB.rotation
        );

        Debug.Log(
            "Getränk für " +
            NormalizeSequence(recipe.sequence) +
            " wurde zu Punkt B teleportiert."
        );
    }

    public void ResetAllDrinkObjects()
    {
        if (drinkRecipes == null)
        {
            return;
        }

        for (int i = 0; i < drinkRecipes.Length; i++)
        {
            DrinkRecipe recipe = drinkRecipes[i];

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
        string result = "";

        int count = SequenceChoiceManager.Instance.GetCount();

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

    private static string NormalizeSequence(string sequence)
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