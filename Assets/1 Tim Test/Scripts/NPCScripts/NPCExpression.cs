using UnityEngine;

[CreateAssetMenu(
    fileName = "New NPC Expression",
    menuName = "Dialogue System/NPC Expression"
)]
public class NPCExpression : ScriptableObject
{
    [Header("Anzeigename")]
    [SerializeField]
    private string displayName;

    public string DisplayName
    {
        get
        {
            if (string.IsNullOrWhiteSpace(displayName))
            {
                return name;
            }

            return displayName;
        }
    }
}