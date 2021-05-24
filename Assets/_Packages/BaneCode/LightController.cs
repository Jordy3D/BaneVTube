using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OpenSee.Bane
{
  [RequireComponent(typeof(Light))]
  public class LightController : MonoBehaviour
  {
    public Light _Light;
    [SerializeField] public float _Brightness;
    [SerializeField] public Vector3 _LightRotation;

    private void Start()
    {
      _Light = GetComponent<Light>();
      _Brightness = _Light.intensity;
      _LightRotation = transform.rotation.eulerAngles;
    }

    private void Update()
    {
      if (_Light.intensity != _Brightness)
        _Light.intensity = _Brightness;
      if (transform.rotation.eulerAngles != _LightRotation)
        transform.rotation = Quaternion.Euler(_LightRotation);
    }

    #region Public Functions
    public void SetBrightness(System.Single _val) => _Brightness = _val;
    public void SetLightRotX(System.Single _val) => _LightRotation.x = _val;
    public void SetLightRotY(System.Single _val) => _LightRotation.y = _val;
    public void SetLightRotZ(System.Single _val) => _LightRotation.z = _val;
    #endregion
  } 
}
