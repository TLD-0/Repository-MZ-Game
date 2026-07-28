using System;
using System.Collections.Generic;
using UnityEngine;

public class CloudMoodManager : MonoBehaviour
{
    public static CloudMoodManager Instance
    {
        get;
        private set;
    }

    [Serializable]
    private class CloudMoodTarget
    {
        [Tooltip(
            "Renderer des Wolkenobjekts, dessen Material " +
            "durch MoodValue verändert werden soll."
        )]
        public Renderer targetRenderer;

        [Tooltip(
            "Index des TestClouds-Materials im Renderer. " +
            "Bei nur einem Material normalerweise 0."
        )]
        [Min(0)]
        public int materialIndex = 0;

        [NonSerialized]
        public Material runtimeMaterial;
    }

    [Header("Wolkenobjekte")]
    [Tooltip(
        "Alle Wolkenobjekte, deren TestClouds-Material " +
        "denselben MoodValue erhalten soll."
    )]
    [SerializeField]
    private List<CloudMoodTarget> moodTargets =
        new List<CloudMoodTarget>();

    [Header("Shader Property")]
    [Tooltip(
        "Interner Reference Name der MoodValue-Property " +
        "im TestClouds-Shader."
    )]
    [SerializeField]
    private string moodPropertyName = "_MoodValue";

    [Header("Startwert")]
    [Tooltip(
        "Liest den Startwert aus dem ersten gültigen " +
        "TestClouds-Material."
    )]
    [SerializeField]
    private bool readStartValueFromMaterial = true;

    [Tooltip(
        "Wird verwendet, wenn Read Start Value From Material " +
        "deaktiviert ist."
    )]
    [SerializeField]
    private float startMoodValue = 0f;

    [Header("Optionale Begrenzung")]
    [Tooltip(
        "Begrenzt MoodValue auf Minimum und Maximum."
    )]
    [SerializeField]
    private bool clampMoodValue = false;

    [SerializeField]
    private float minimumMoodValue = -10f;

    [SerializeField]
    private float maximumMoodValue = 10f;

    private int moodPropertyId;
    private bool initialized;

    public float CurrentMoodValue
    {
        get;
        private set;
    }

    private void Awake()
    {
        if (Instance != null &&
            Instance != this)
        {
            Debug.LogWarning(
                "CloudMoodManager: Es existiert bereits ein " +
                "CloudMoodManager. Die zusätzliche Komponente " +
                "wird entfernt.",
                this);

            Destroy(this);
            return;
        }

        Instance = this;

        Initialize();
    }

    private void OnDestroy()
    {
        if (Instance == this)
        {
            Instance = null;
        }
    }

    private void Initialize()
    {
        if (initialized)
        {
            return;
        }

        if (moodTargets == null ||
            moodTargets.Count == 0)
        {
            Debug.LogError(
                "CloudMoodManager: Es wurden keine " +
                "Wolkenobjekte eingetragen.",
                this);

            return;
        }

        if (string.IsNullOrWhiteSpace(
                moodPropertyName))
        {
            Debug.LogError(
                "CloudMoodManager: Mood Property Name ist leer.",
                this);

            return;
        }

        moodPropertyId =
            Shader.PropertyToID(
                moodPropertyName);

        int validTargetCount = 0;
        bool startValueWasRead = false;

        for (int i = 0;
             i < moodTargets.Count;
             i++)
        {
            CloudMoodTarget target =
                moodTargets[i];

            if (target == null)
            {
                Debug.LogWarning(
                    "CloudMoodManager: Element " +
                    i +
                    " ist leer.",
                    this);

                continue;
            }

            if (target.targetRenderer == null)
            {
                Debug.LogError(
                    "CloudMoodManager: Bei Element " +
                    i +
                    " wurde kein Target Renderer eingetragen.",
                    this);

                continue;
            }

            Material[] materials =
                target.targetRenderer.materials;

            if (target.materialIndex < 0 ||
                target.materialIndex >= materials.Length)
            {
                Debug.LogError(
                    "CloudMoodManager: Material Index " +
                    target.materialIndex +
                    " ist bei " +
                    target.targetRenderer.gameObject.name +
                    " ungültig. Der Renderer besitzt " +
                    materials.Length +
                    " Material beziehungsweise Materialien.",
                    target.targetRenderer);

                continue;
            }

            target.runtimeMaterial =
                materials[target.materialIndex];

            if (target.runtimeMaterial == null)
            {
                Debug.LogError(
                    "CloudMoodManager: Auf " +
                    target.targetRenderer.gameObject.name +
                    " wurde am Material Index " +
                    target.materialIndex +
                    " kein Material gefunden.",
                    target.targetRenderer);

                continue;
            }

            if (!target.runtimeMaterial.HasProperty(
                    moodPropertyId))
            {
                Debug.LogError(
                    "CloudMoodManager: Das Material " +
                    target.runtimeMaterial.name +
                    " auf " +
                    target.targetRenderer.gameObject.name +
                    " besitzt keine Shader-Property namens " +
                    moodPropertyName +
                    ".",
                    target.targetRenderer);

                target.runtimeMaterial = null;
                continue;
            }

            validTargetCount++;

            /*
             * Der Startwert wird nur aus dem ersten
             * gültigen Material gelesen.
             *
             * Anschließend wird derselbe Wert auf alle
             * anderen Wolkenmaterialien übertragen.
             */
            if (readStartValueFromMaterial &&
                !startValueWasRead)
            {
                CurrentMoodValue =
                    target.runtimeMaterial.GetFloat(
                        moodPropertyId);

                startValueWasRead = true;
            }
        }

        if (validTargetCount == 0)
        {
            Debug.LogError(
                "CloudMoodManager: Es wurde kein gültiges " +
                "TestClouds-Material gefunden.",
                this);

            return;
        }

        if (!readStartValueFromMaterial ||
            !startValueWasRead)
        {
            CurrentMoodValue =
                startMoodValue;
        }

        initialized = true;

        /*
         * Gleichen Startwert auf Wolkendecke
         * und Wolkenboden anwenden.
         */
        ApplyMoodValue();

        Debug.Log(
            "CloudMoodManager: Initialisiert. " +
            validTargetCount +
            " Wolkenmaterialien verwenden MoodValue " +
            CurrentMoodValue +
            ".",
            this);
    }

    public void AddMoodValue(
        int amount)
    {
        if (amount == 0)
        {
            return;
        }

        if (!initialized)
        {
            Initialize();
        }

        if (!initialized)
        {
            return;
        }

        SetMoodValue(
            CurrentMoodValue + amount);
    }

    public void SetMoodValue(
        float newValue)
    {
        if (!initialized)
        {
            Initialize();
        }

        if (!initialized)
        {
            return;
        }

        if (clampMoodValue)
        {
            newValue =
                Mathf.Clamp(
                    newValue,
                    minimumMoodValue,
                    maximumMoodValue);
        }

        CurrentMoodValue =
            newValue;

        ApplyMoodValue();

        Debug.Log(
            "CloudMoodManager: MoodValue wurde auf " +
            CurrentMoodValue +
            " geändert.",
            this);
    }

    private void ApplyMoodValue()
    {
        if (moodTargets == null)
        {
            return;
        }

        for (int i = 0;
             i < moodTargets.Count;
             i++)
        {
            CloudMoodTarget target =
                moodTargets[i];

            if (target == null ||
                target.runtimeMaterial == null)
            {
                continue;
            }

            target.runtimeMaterial.SetFloat(
                moodPropertyId,
                CurrentMoodValue);
        }
    }
}