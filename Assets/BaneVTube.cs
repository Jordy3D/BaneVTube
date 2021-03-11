using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using OpenSee;

public class BaneVTube : MonoBehaviour
{
  public OpenSeeVRMDriver driver;
  public OpenSeeIKTarget target;

  public KeyCode startLipSyncKey = KeyCode.L;
  public KeyCode recalibrateFacing = KeyCode.O;

  public bool isSyncing;
  // Start is called before the first frame update
  void Start()
  {

  }

  // Update is called once per frame
  void Update()
  {
    if (Input.GetKeyDown(startLipSyncKey))
    {
      isSyncing = !isSyncing;

      driver.initializeLipSync = isSyncing;
      driver.lipSync = isSyncing;
    }

    if (Input.GetKeyDown(recalibrateFacing))
    {
      target.calibrate = true;
    }
  }
}
