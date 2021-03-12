using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
[AddComponentMenu("glitch/Analogue Glitch")]
public class AnalogueGlitch : MonoBehaviour
{
  #region Public Properties
  [SerializeField, Range(0, 1)]
  public float _ScanLineJitter;
  [SerializeField, Range(0, 1)]
  public float _VerticalJump;
  [SerializeField, Range(0, 1)]
  public float _HorizontalShake;
  [SerializeField, Range(-1, 1)]
  public float _ColourDrift;
  #endregion

  #region Private Properties
  [SerializeField] Shader _shader;
  Material _material;
  float _verticalJumpTime;
  #endregion

  #region MonoBehaviour Functions
  private void OnRenderImage(RenderTexture source, RenderTexture destination)
  {
    if (_material == null)
    {
      _material = new Material(_shader);
      _material.hideFlags = HideFlags.DontSave;
    }

    _verticalJumpTime += Time.deltaTime * _VerticalJump * 11.3f;
    var sl_thresh = Mathf.Clamp01(1.0f - _ScanLineJitter * 1.2f);
    var sl_disp = 0.002f + Mathf.Pow(_ScanLineJitter, 3) * 0.05f;
    _material.SetVector("_ScanLineJitter", new Vector2(sl_disp, sl_thresh));

    var vj = new Vector2(_VerticalJump, _verticalJumpTime);
    _material.SetVector("_VerticalJump", vj);
    _material.SetFloat("_HorizontalShake", _HorizontalShake * 0.2f);

    var cd = new Vector2(_ColourDrift * 0.04f, Time.time * 606.11f);
    _material.SetVector("_ColourDrift", cd);

    Graphics.Blit(source, destination, _material);
  }
  #endregion

  #region Public Functions
  public void SetScanlineJitter(System.Single _val) => _ScanLineJitter = _val;
  public void SetVerticalJump(System.Single _val) => _VerticalJump = _val;
  public void SetHorizontalShake(System.Single _val) => _HorizontalShake = _val;
  public void SetColourDrift(System.Single _val) => _ColourDrift = _val;
  #endregion
}