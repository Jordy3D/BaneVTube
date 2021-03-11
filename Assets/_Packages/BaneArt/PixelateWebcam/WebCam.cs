using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WebCam : MonoBehaviour
{
  public WebCamTexture webcamTexture;
  public Material targetMat;

  public List<string> deviceNames = new List<string>();

  public int device = 1;

  // Start is called before the first frame update
  void Start()
  {
    GetWebCam();
  }

  void GetWebCam()
  {
    WebCamDevice[] devices = WebCamTexture.devices;

    print(devices.Length);

    for (int i = 0; i < devices.Length; i++)
    {
      deviceNames.Add(devices[i].name);
      if (i == device)
      {
        webcamTexture = new WebCamTexture(devices[i].name, 1, 512);

        print(devices[i].name + " // " + webcamTexture.height + " // " + webcamTexture.requestedHeight);
      }
    }

    targetMat.SetTexture("_WebCam", webcamTexture);

    webcamTexture.Play();
  }
}
