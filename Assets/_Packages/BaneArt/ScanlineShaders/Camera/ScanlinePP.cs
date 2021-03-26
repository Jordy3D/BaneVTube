using UnityEngine;

[ExecuteInEditMode]
public class ScanlinePP : MonoBehaviour
{
  #region Public Properties
  [SerializeField, Range(0, 1)] public float _ScanlineTransparency = 0.12f;
  [SerializeField] public Vector2 _ScanlineSpeed = new Vector2(0, 0.1f);
  [SerializeField] public Vector2 _ScanlineTextureScale = new Vector2(0.3f, 0.3f);
  [SerializeField] public Texture _ScanlineTexture;
  #endregion

  #region Private Properties
  [SerializeField] Shader _shader;
  Material _material;
  #endregion

  //private void Awake()
  //{
  //  if (_material == null)
  //    enabled = false;
  //  else
  //    _material.mainTexture = _material.mainTexture;
  //}

  void OnRenderImage(RenderTexture src, RenderTexture dest)
  {
    if (_material == null)
    {
      _material = new Material(_shader);
      _material.hideFlags = HideFlags.DontSave;
    }

    _material.SetVector("_ScanlineSpeed", _ScanlineSpeed);
    _material.SetFloat("_ScanlineTransparency", _ScanlineTransparency);

    _material.SetTextureScale("_ScanlineTexture", _ScanlineTextureScale);
    _material.SetTexture("_ScanlineTexture", _ScanlineTexture);

    Graphics.Blit(src, dest, _material);
  }

  #region Public Functions
  public void SetScanlineTransparency(System.Single _val) => _ScanlineTransparency = _val;
  #endregion
}