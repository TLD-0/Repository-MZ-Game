using UnityEngine;
using System.Collections.Generic;

public class MouseHoverOutline : MonoBehaviour
{
    [Header("References")]
    public Camera playerCamera;
    public Material outlineMaterial;

    [Header("Settings")]
    public float maxDistance = 5f;

    private Renderer currentRenderer;
    private Material[] originalMaterials;

    void Update()
    {
        Ray ray = playerCamera.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out RaycastHit hit, maxDistance))
        {
            // Prüfen ob das Objekt das gewünschte Script besitzt
            if (hit.collider.GetComponent<QuestInteractObject>() != null)
            {
                Renderer renderer = hit.collider.GetComponent<Renderer>();

                if (renderer != null && renderer != currentRenderer)
                {
                    RemoveOutline();

                    currentRenderer = renderer;
                    originalMaterials = renderer.sharedMaterials;

                    List<Material> mats = new List<Material>(originalMaterials);
                    mats.Add(outlineMaterial);

                    renderer.materials = mats.ToArray();
                }

                return;
            }
        }

        RemoveOutline();
    }

    void RemoveOutline()
    {
        if (currentRenderer != null)
        {
            currentRenderer.materials = originalMaterials;
            currentRenderer = null;
            originalMaterials = null;
        }
    }
}