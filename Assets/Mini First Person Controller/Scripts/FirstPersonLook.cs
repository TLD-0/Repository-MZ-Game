using UnityEngine;

public class FirstPersonLook : MonoBehaviour
{
    [SerializeField]
    Transform character;
    public float sensitivity = 2;
    public float smoothing = 1.5f;

    Vector2 velocity;
    Vector2 frameVelocity;


    void Reset()
    {
        // Get the character from the FirstPersonMovement in parents.
        character = GetComponentInParent<FirstPersonMovement>().transform;
    }

    void Start()
    {
        // Lock the mouse cursor to the game screen.
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
    {
        // Get smooth velocity.
        Vector2 mouseDelta = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));
        Vector2 rawFrameVelocity = Vector2.Scale(mouseDelta, Vector2.one * sensitivity);
        frameVelocity = Vector2.Lerp(frameVelocity, rawFrameVelocity, 1 / smoothing);
        velocity += frameVelocity;
        velocity.y = Mathf.Clamp(velocity.y, -90, 90);

        // Rotate camera up-down and controller left-right from velocity.
        transform.localRotation = Quaternion.AngleAxis(-velocity.y, Vector3.right);
        character.localRotation = Quaternion.AngleAxis(velocity.x, Vector3.up);
    }
    public void SetLookRotation(Quaternion worldRotation)
    {
        if (character == null)
        {
            Debug.LogError("FirstPersonLook: Character ist nicht zugewiesen.");
            return;
        }

        Vector3 euler = worldRotation.eulerAngles;

        // Unity speichert Winkel oft als 0–360 statt -180–180.
        float pitch = euler.x;
        if (pitch > 180f)
            pitch -= 360f;

        velocity = new Vector2(euler.y, -pitch);
        frameVelocity = Vector2.zero;

        character.rotation =
            Quaternion.Euler(0f, euler.y, 0f);

        transform.localRotation =
            Quaternion.Euler(pitch, 0f, 0f);
    }
}
