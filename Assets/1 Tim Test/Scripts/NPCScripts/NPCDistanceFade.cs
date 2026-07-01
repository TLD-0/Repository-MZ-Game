using UnityEngine;

public class NPCDistanceFade : MonoBehaviour
{
    public SpriteRenderer shadowSprite;
    public SpriteRenderer realSprite;

    public Transform player;

    public float startFadeDistance = 15f;
    public float endFadeDistance = 5f;

    void Update()
    {
        if (player == null) return;

        float distance = Vector3.Distance(player.position, transform.position);

        float t = Mathf.InverseLerp(startFadeDistance, endFadeDistance, distance);

        // t = 0 (weit weg) -> Shadow sichtbar
        // t = 1 (nah) -> Real sichtbar

        SetAlpha(shadowSprite, 1f - t);
        SetAlpha(realSprite, t);
    }

    void SetAlpha(SpriteRenderer sr, float alpha)
    {
        if (sr == null) return;

        Color c = sr.color;
        c.a = Mathf.Clamp01(alpha);
        sr.color = c;
    }
}
