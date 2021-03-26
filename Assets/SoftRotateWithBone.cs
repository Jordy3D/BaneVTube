using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoftRotateWithBone : MonoBehaviour
{
  public Transform trackingBone;
  public float rotationModifier = .5f;

  public bool followX, followY, followZ;

  void Update()
  {
    Quaternion trackRotation = trackingBone.rotation;
    Quaternion localRotation = transform.localRotation;

    Vector3 track = new Vector3(followX ? trackRotation.x * rotationModifier : localRotation.x,
                                followY ? trackRotation.y * rotationModifier : localRotation.y,
                                followZ ? trackRotation.z * rotationModifier : localRotation.z);

    transform.localRotation = Quaternion.Euler(track);
  }
}
