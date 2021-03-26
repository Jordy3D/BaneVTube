using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
[AddComponentMenu("OldStyle/Pixelate Screen")]
public class PixelatePP : MonoBehaviour
{
  #region Public Properties
  [SerializeField, Range(0, 128)] public int _PixelCount = 42;
  [SerializeField] public Vector2 _ScreenRatio = new Vector2(16, 9);
  [SerializeField] public bool _GreyscaleToggle, _DitherToggle, _DitherSizeToggle, _InvertToggle;
  [SerializeField] public Color _ColourTint = Color.white;
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

    _material.SetFloat("_PixelCount", _PixelCount);
    _material.SetInt("_ScreenXRatio", (int)_ScreenRatio.y);
    _material.SetInt("_ScreenYRatio", (int)_ScreenRatio.x);

    _material.SetInt("_GreyscaleToggle", _GreyscaleToggle ? 1 : 0);
    _material.SetInt("_DitherToggle", _DitherToggle ? 1 : 0);
    _material.SetInt("_DitherSizeToggle", _DitherSizeToggle ? 1 : 0);
    _material.SetInt("_InvertToggle", _InvertToggle ? 1 : 0);

    _material.SetColor("_ColourTint", _ColourTint);

    Graphics.Blit(src, dest, _material);
  }

  #region Public Functions
  public void SetPixelCount(System.Single _val) => _PixelCount = (int)_val;
  #endregion
}
