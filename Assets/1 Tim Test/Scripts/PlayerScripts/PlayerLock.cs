using UnityEngine;

public class PlayerLock : MonoBehaviour
{
    [Header("References")]
    public FirstPersonMovement movementScript;
    public FirstPersonLook lookScript;

    private Rigidbody rb;
    private bool locked;
    private Vector3 lockedPosition;
    private Quaternion lockedRotation;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void LateUpdate()
    {
        if (!locked)
            return;

        transform.SetPositionAndRotation(
            lockedPosition,
            lockedRotation);
    }

    public void LockPlayer(Transform playerPoint, Transform cameraPoint)
    {
        if (playerPoint == null)
        {
            Debug.LogError("PlayerLock: PlayerPoint fehlt.");
            return;
        }

        if (movementScript != null)
            movementScript.enabled = false;

        if (lookScript != null)
            lookScript.enabled = false;

        lockedPosition = playerPoint.position;
        lockedRotation = playerPoint.rotation;

        locked = true;

        if (rb != null)
        {
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            rb.isKinematic = true;
        }

        transform.SetPositionAndRotation(
            lockedPosition,
            lockedRotation);

        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    public void UnlockPlayer()
    {
        locked = false;

        if (rb != null)
        {
            rb.isKinematic = false;
        }

        if (movementScript != null)
            movementScript.enabled = true;

        if (lookScript != null)
            lookScript.enabled = true;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }
}