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
    Vector3 track = new Vector3(followX ? trackingBone.rotation.x * rotationModifier : transform.localRotation.x,
                                followY ? trackingBone.rotation.y * rotationModifier : transform.localRotation.y,
                                followZ ? trackingBone.rotation.z * rotationModifier : transform.localRotation.z);
    transform.localRotation = Quaternion.Euler(track);
  }
}
