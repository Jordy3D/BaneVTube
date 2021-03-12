using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoftRotateWithBone : MonoBehaviour
{
  public Transform trackingBone;
  public float rotationModifier = .5f;

  public bool followX, followY, followZ;
  public Vector3 followVector = new Vector3(0f, 0f, 0f);

  void Update()
  {
    Quaternion trackRotation = trackingBone.rotation;
    Quaternion localRotation = transform.localRotation;
    
    //Vector3 track = new Vector3(followX ? trackRotation.x * rotationModifier : localRotation.x,
    //                            followY ? trackRotation.y * rotationModifier : localRotation.y,
    //                            followZ ? trackRotation.z * rotationModifier : localRotation.z);
    Vector3 modified = trackRotation.eulerAngles * rotationModifier;
    Vector3 track = localRotation.eulerAngles;
    track.x = track.x * modified.x * followVector.x;
    track.y = track.y * modified.y * followVector.y;
    track.z = track.z * modified.z * followVector.z;
    
    transform.localRotation = Quaternion.Euler(track);
  }
}
