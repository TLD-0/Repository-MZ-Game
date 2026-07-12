using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using TMPro;
using UnityEngine.SceneManagement;
using System.Collections;

public class CanvasController : MonoBehaviour
{
    public Button TitleButton;
    public Button StartButton;
    public Button EndButton;
    public Button SettingsButton;
    public TMP_Text text;

    public GameObject SchriftTitle;
    public GameObject SchriftMainMenu;

    public GameObject HausEnd;
    public GameObject HausStart;
    public GameObject HausSettings;

    public GameObject SchriftEnd;
    public GameObject SchriftStart;
    public GameObject SchriftSettings;

    private Vector3 orgScaleStart;
    private Vector3 orgScaleEnd;
    private Vector3 orgScaleSettings;

    private bool hoverable;
    private bool start;
     private bool started;

    private Coroutine coHausEnd;
    private Coroutine coHausStart;
    private Coroutine coHausSettings;

    public Material StandardMaterial;
    public Material HoverMaterial;

    public GameObject StartHoverZielObjekt;
    public GameObject EndHoverZielObjekt;
    public GameObject SettingsHoverZielObjekt;
    private Renderer rendStartZiel;
    private Renderer rendEndZiel;
    private Renderer rendSettingsZiel;

    void Start()
    {
        SchriftTitle.transform.position = new Vector3(165f, 49f, 100f);
        SchriftMainMenu.transform.position = new Vector3(135f, -200f, 80f);

        HausEnd.transform.position = new Vector3(-1030f, -441f, 110f);
        HausSettings.transform.position = new Vector3(-75.5f, 420.5f, 252.1f);
        HausStart.transform.position = new Vector3(931f, -588f, 302f);

        SetupButtonEvents(TitleButton, "Title");
        SetupButtonEvents(StartButton, "Start");
        SetupButtonEvents(EndButton, "End");
        SetupButtonEvents(SettingsButton, "Settings");

        if (SchriftStart != null) orgScaleStart = SchriftStart.transform.localScale;
        if (SchriftEnd != null) orgScaleEnd = SchriftEnd.transform.localScale;
        if (SchriftSettings != null) orgScaleSettings = SchriftSettings.transform.localScale;

        hoverable = true;
        start = false;
        started = false;

        if (StartHoverZielObjekt != null) rendStartZiel = StartHoverZielObjekt.GetComponent<Renderer>();
        if (EndHoverZielObjekt != null) rendEndZiel = EndHoverZielObjekt.GetComponent<Renderer>();
        if (SettingsHoverZielObjekt != null) rendSettingsZiel = SettingsHoverZielObjekt.GetComponent<Renderer>();

        SetBaseMaterials();

    }

    void SetupButtonEvents(Button button, string buttonName)
    {
        if (button == null)
        {
            Debug.LogWarning($"Der Button '{buttonName}' wurde im Inspector nicht zugewiesen!");
            return;
        }
        button.onClick.AddListener(() => OnButtonClick(buttonName));

        EventTrigger trigger = button.gameObject.GetComponent<EventTrigger>();
        if (trigger == null)
        {
            trigger = button.gameObject.AddComponent<EventTrigger>();
        }

        EventTrigger.Entry entryEnter = new EventTrigger.Entry();
        entryEnter.eventID = EventTriggerType.PointerEnter;
        entryEnter.callback.AddListener((data) => { OnButtonHover(button, buttonName); });
        trigger.triggers.Add(entryEnter);

        EventTrigger.Entry entryExit = new EventTrigger.Entry();
        entryExit.eventID = EventTriggerType.PointerExit;
        entryExit.callback.AddListener((data) => { OnButtonHoverExit(button, buttonName); });
        trigger.triggers.Add(entryExit);
    }

    void OnButtonClick(string buttonName)
    {
        Debug.Log($"Geklickt: {buttonName}");

        if (text != null)
        {
            text.text = $"Du hast den {buttonName}-Button gedrückt!";
        }

        if (buttonName == "Title")
        {
            TitleButton.gameObject.SetActive(false);
            text.gameObject.SetActive(false);
            StartCoroutine(Starten());
        }

        if (start == true)
        {
        if (buttonName == "Start")
        {
            SceneManager.LoadScene("Map Test");
        }
        else if (buttonName == "End")
        {
            Debug.Log("Spiel wird beendet...");
            Application.Quit();
        }
        else if (buttonName == "Settings")
        {
        }
    }
}


IEnumerator Starten()
    {
        StarteTitleBewegung();
        yield return new WaitForSeconds(3f);

        SchriftMainMenu.transform.position = new Vector3(135f, -150f, 80f);
        StarteMainMenuBewegung();

        StartCoroutine(HausEndbewegung());
        StartCoroutine(HausStartbewegung());
        StartCoroutine(HausSettingsbewegung());

        yield return new WaitForSeconds(3f);
        start = true;
        started = true;
    }

    void OnButtonHover(Button button, string buttonName)
    {
        string bereinigterName = buttonName.Trim();

        if (start == true) {
        if (hoverable == false)
        {
            HausReset();
            
        }

        if (hoverable == true) {
        if (bereinigterName == "Start" && SchriftStart != null)
        {
                    if (rendStartZiel != null) rendStartZiel.material = HoverMaterial;
                    hoverable = false;
            SchriftStart.transform.localScale = orgScaleStart * 1.1f;
            StartCoroutine(HausEndbewegungHover());
            StartCoroutine(HausSettingsbewegungHover());

                    StartCoroutine(HausStartbewegungExit());
                }
        else if (bereinigterName == "End" && SchriftEnd != null)
        {
                    if (rendEndZiel != null) rendEndZiel.material = HoverMaterial;
                    hoverable = false;
                SchriftEnd.transform.localScale = orgScaleEnd * 1.1f;
            StartCoroutine(HausStartbewegungHover());
            StartCoroutine(HausSettingsbewegungHover());

                    StartCoroutine(HausEndbewegungExit());
                }
        else if (bereinigterName == "Settings" && SchriftSettings != null)
        {
                    if (rendSettingsZiel != null) rendSettingsZiel.material = HoverMaterial;
                    hoverable = false;
                SchriftSettings.transform.localScale = orgScaleSettings * 1.1f;
            StartCoroutine(HausEndbewegungHover());
            StartCoroutine(HausStartbewegungHover());

                    StartCoroutine(HausSettingsbewegungExit());
                }
            }

        }
    }

    void OnButtonHoverExit(Button button, string buttonName)
    {
        string bereinigterName = buttonName.Trim();

        if (start == true)
        {
            if (bereinigterName == "Start" && SchriftStart != null)
        {
                SchriftStart.transform.localScale = orgScaleStart;
            StartCoroutine(HausSettingsbewegungExit());
            StartCoroutine(HausEndbewegungExit());

                StartCoroutine(HausStartbewegungHover());
                SetBaseMaterials();

            }
        else if (bereinigterName == "End" && SchriftEnd != null)
        {
                
                SchriftEnd.transform.localScale = orgScaleEnd;
            StartCoroutine(HausStartbewegungExit());
            StartCoroutine(HausSettingsbewegungExit());

                StartCoroutine(HausEndbewegungHover());
                SetBaseMaterials();

            }
        else if (bereinigterName == "Settings" && SchriftSettings != null)
        {
                SchriftSettings.transform.localScale = orgScaleSettings;
            StartCoroutine(HausEndbewegungExit());
            StartCoroutine(HausStartbewegungExit());

            StartCoroutine(HausSettingsbewegungHover());

            SetBaseMaterials();
            }
    }
    }



    public void StarteMainMenuBewegung()
    {
        if (SchriftTitle != null)
        {
            StartCoroutine(SchriftMainMenuRoutine());
        }
    }

    private void HausReset()
    {
        
        HausEnd.transform.position = new Vector3(-571.9f, -264f, 72.6f);
        HausSettings.transform.position = new Vector3(-101.4f, 244.1f, 276.7f);
        HausStart.transform.position = new Vector3(463.6f, -298.2f, 276.4f);

        SchriftStart.transform.localScale = orgScaleStart;
        SchriftEnd.transform.localScale = orgScaleEnd ;
        SchriftSettings.transform.localScale = orgScaleSettings ;

        hoverable = true;

    }

    private IEnumerator SchriftMainMenuRoutine()
    {
        Transform objTransform = SchriftMainMenu.transform;
        float dauer = 3f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = new Vector3(135f, -200f, 80f);
        Vector3 zielPosition = new Vector3(135f, 50f, 80f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    public void StarteTitleBewegung()
    {
        if (SchriftTitle != null) 
        {
            StartCoroutine(SchriftTitleRoutine());
        }
    }

    private IEnumerator SchriftTitleRoutine()
    {
        Transform objTransform = SchriftTitle.transform;
        float dauer = 2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = new Vector3(165f, 50f, 100f);
        Vector3 zielPosition = new Vector3(165f, -200f, 100f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausEndbewegung()
    {
        Transform objTransform = HausEnd.transform;
        float dauer = 3f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 492.5f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausEndbewegungHover()
    {
        Transform objTransform = HausEnd.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * -20f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausEndbewegungExit()
    {
        Transform objTransform = HausEnd.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 20f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
        yield return new WaitForSeconds(0.3f);
        // HausReset();
    }

    private IEnumerator HausStartbewegung()
    {
        Transform objTransform = HausStart.transform;
        float dauer = 2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 550.6f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausStartbewegungHover()
    {
        Transform objTransform = HausStart.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * -30);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }
    private IEnumerator HausStartbewegungExit()
    {
        Transform objTransform = HausStart.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 30);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
        yield return new WaitForSeconds(0.3f);
        //HausReset();
    }

    private IEnumerator HausSettingsbewegung()
    {
        Transform objTransform = HausSettings.transform;
        float dauer = 1.5f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 180f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausSettingsbewegungHover()
    {
        Transform objTransform = HausSettings.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * -20f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
    }

    private IEnumerator HausSettingsbewegungExit()
    {
        Transform objTransform = HausSettings.transform;
        float dauer = 0.2f;
        float abgelaufeneZeit = 0f;
        Vector3 startPosition = objTransform.position;
        Vector3 zielPosition = startPosition + (objTransform.up * 20f);

        while (abgelaufeneZeit < dauer)
        {
            abgelaufeneZeit += Time.deltaTime;
            float fortschritt = abgelaufeneZeit / dauer;
            objTransform.position = Vector3.Lerp(startPosition, zielPosition, fortschritt);
            yield return null;
        }
        objTransform.position = zielPosition;
        yield return new WaitForSeconds(0.3f);
        //HausReset();
    }

    private void SetBaseMaterials()
    {
        if (StandardMaterial != null)
        {
            if (rendStartZiel != null) rendStartZiel.material = StandardMaterial;
            if (rendEndZiel != null) rendEndZiel.material = StandardMaterial;
            if (rendSettingsZiel != null) rendSettingsZiel.material = StandardMaterial;
        }
    }

}