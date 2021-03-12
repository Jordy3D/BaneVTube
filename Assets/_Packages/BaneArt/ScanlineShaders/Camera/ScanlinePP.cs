using UnityEngine;

[ExecuteInEditMode]
public class ScanlinePP : MonoBehaviour
{
  public Material PostProcessMat;
  private void Awake()
  {
    if (PostProcessMat == null)
      enabled = false;
    else
      PostProcessMat.mainTexture = PostProcessMat.mainTexture;
  }

  void OnRenderImage(RenderTexture src, RenderTexture dest) => Graphics.Blit(src, dest, PostProcessMat);
}