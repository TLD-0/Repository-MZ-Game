using UnityEngine;

public class DialogueTeleportPoint : MonoBehaviour
{
    [Header("Teleport-Verbindung")]
    [Tooltip(
        "Dieses Asset muss auch in der entsprechenden " +
        "Dialogantwort ausgewählt werden."
    )]
    [SerializeField]
    private DialogueTeleportDestination destination;

    public DialogueTeleportDestination Destination
    {
        get { return destination; }
    }

    public static bool TryGetDestination(
        DialogueTeleportDestination requestedDestination,
        out Transform targetTransform)
    {
        targetTransform = null;

        if (requestedDestination == null)
        {
            return false;
        }

        DialogueTeleportPoint[] points =
            FindObjectsByType<DialogueTeleportPoint>(
                FindObjectsInactive.Exclude,
                FindObjectsSortMode.None);

        DialogueTeleportPoint foundPoint = null;

        for (int i = 0;
             i < points.Length;
             i++)
        {
            DialogueTeleportPoint point =
                points[i];

            if (point == null ||
                point.destination != requestedDestination)
            {
                continue;
            }

            /*
             * Mehrere aktive Punkte dürfen nicht dasselbe
             * Destination-Asset verwenden.
             */
            if (foundPoint != null)
            {
                Debug.LogError(
                    "DialogueTeleportPoint: Das Teleport-Ziel " +
                    requestedDestination.name +
                    " wird von mehreren aktiven Objekten verwendet.",
                    point);

                return false;
            }

            foundPoint = point;
        }

        if (foundPoint == null)
        {
            return false;
        }

        targetTransform =
            foundPoint.transform;

        return true;
    }
}