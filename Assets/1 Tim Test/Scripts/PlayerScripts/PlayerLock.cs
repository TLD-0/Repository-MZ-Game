using UnityEngine;

public class PlayerLock : MonoBehaviour
{
    private bool locked = false;

    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        if (locked)
        {
            //Debug.Log(transform.position);

            transform.position = lockedPosition;
            transform.rotation = lockedRotation;
        }
    }

    private Vector3 lockedPosition;
    private Quaternion lockedRotation;

    public void LockPlayer(Transform targetPoint)
    {
        Debug.Log("LockPlayer wurde aufgerufen");
        Debug.Log(targetPoint.position);

        locked = true;

        lockedPosition = targetPoint.position;
        lockedRotation = targetPoint.rotation;

        Debug.Log("Teleportiere zu: " + lockedPosition);

        transform.position = lockedPosition;
        transform.rotation = lockedRotation;

        Rigidbody rb = GetComponent<Rigidbody>();

        if(rb != null)
        {
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            rb.useGravity = false;
            rb.isKinematic = true;
        }

        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    public void UnlockPlayer()
    {
        locked = false;

        Rigidbody rb = GetComponent<Rigidbody>();

        if(rb != null)
        {
            rb.useGravity = true;
            rb.isKinematic = false;
        }
    }
}