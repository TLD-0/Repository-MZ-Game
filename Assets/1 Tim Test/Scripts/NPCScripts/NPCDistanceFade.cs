using UnityEngine;

public class NPCDistanceFade : MonoBehaviour
{
    public SpriteRenderer farShadowSprite;
    public SpriteRenderer nearShadowSprite;
    public SpriteRenderer realSprite;

    public Transform player;

    // Übergang Far -> Near
    public float farStartFadeDistance = 25f;
    public float farEndFadeDistance = 15f;

    // Übergang Near -> Real
    public float nearStartFadeDistance = 25f;
    public float nearEndFadeDistance = 5f;

    void Update()
    {
        if (player == null) return;

        float distance = Vector3.Distance(player.position, transform.position);

        float farAlpha;
        float nearAlpha;
        float realAlpha;

        // ---------- FAR ----------
        if (distance >= 30f)
        {
            farAlpha = 1f;
        }
        else if (distance > 25f)
        {
            // 30 -> 25 : 100% -> 50%
            farAlpha = Mathf.Lerp(0.5f, 1f, Mathf.InverseLerp(25f, 30f, distance));
        }
        else
        {
            farAlpha = 0f;
        }

        // ---------- NEAR ----------
        if (distance >= 30f)
        {
            nearAlpha = 0f;
        }
        else if (distance > 25f)
        {
            // 30 -> 25 : 0% -> 100%
            nearAlpha = 1f - Mathf.InverseLerp(25f, 30f, distance);
        }
        else if (distance > 20f)
        {
            nearAlpha = 1f;
        }
        else if (distance > 10f)
        {
            // 20 -> 10 : 100% -> 0%
            nearAlpha = Mathf.InverseLerp(10f, 20f, distance);
        }
        else
        {
            nearAlpha = 0f;
        }

        // ---------- REAL ----------
        if (distance >= 15f)
        {
            realAlpha = 0f;
        }
        else if (distance > 5f)
        {
            // 20 -> 10 : 0% -> 100%
            realAlpha = 1f - Mathf.InverseLerp(5f, 15f, distance);
        }
        else
        {
            realAlpha = 1f;
        }

        SetAlpha(farShadowSprite, farAlpha);
        SetAlpha(nearShadowSprite, nearAlpha);
        SetAlpha(realSprite, realAlpha);
    }

    void SetAlpha(SpriteRenderer sr, float alpha)
    {
        if (sr == null) return;

        Color c = sr.color;
        c.a = Mathf.Clamp01(alpha);
        sr.color = c;
    }
}