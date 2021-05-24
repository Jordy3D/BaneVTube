using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OpenSee.Bane
{
  public class ModelController : MonoBehaviour
  {
    [SerializeField] public float _Height;
    [SerializeField] public Vector3 _ModelRotation;

    private void Start()
    {
      _ModelRotation = transform.rotation.eulerAngles;

      _Height = transform.position.y;
    }

    private void Update()
    {
      if (transform.position.y != _Height)
        transform.position = new Vector3(transform.position.x, _Height, transform.position.z);

      if (transform.rotation.eulerAngles != _ModelRotation)
        transform.rotation = Quaternion.Euler(_ModelRotation);
    }

    #region Public Functions
    public void SetHeight(System.Single _val) => _Height = _val;
    public void SetModelRotX(System.Single _val) => _ModelRotation.x = _val;
    public void SetModelRotY(System.Single _val) => _ModelRotation.y = _val;
    public void SetModelRotZ(System.Single _val) => _ModelRotation.z = _val;
    #endregion
  }

}