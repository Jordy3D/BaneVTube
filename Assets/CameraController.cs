using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
  public Camera _Camera;
  public Transform _CameraPivot;
  [SerializeField] public float _Height;
  [SerializeField] public Vector3 _CameraRotation;

  private void Start()
  {
    _Camera = GetComponent<Camera>();
    _CameraPivot = transform.parent;
    _CameraRotation = _CameraPivot.rotation.eulerAngles;

    _Height = transform.position.y;
  }

  private void Update()
  {
    if (_CameraPivot.position.y != _Height)
      _CameraPivot.position = new Vector3(_CameraPivot.position.x, _Height, _CameraPivot.position.z);
    if (_CameraPivot.rotation.eulerAngles != _CameraRotation)
      _CameraPivot.rotation = Quaternion.Euler(_CameraRotation);
  }

  #region Public Functions
  public void SetHeight(System.Single _val) => _Height = _val;
  public void SetCamRotX(System.Single _val) => _CameraRotation.x = _val;
  public void SetCamRotY(System.Single _val) => _CameraRotation.y = _val;
  public void SetCamRotZ(System.Single _val) => _CameraRotation.z = _val;
  #endregion
}
