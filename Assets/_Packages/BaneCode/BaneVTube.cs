using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OpenSee.Bane
{
  public class BaneVTube : MonoBehaviour
  {
    public OpenSeeVRMDriver driver;
    public OpenSeeIKTarget target;

    public KeyCode startLipSyncKey = KeyCode.L;
    public KeyCode recalibrateFacing = KeyCode.O;

    public bool isSyncing;
    void Update()
    {
      if (Input.GetKeyDown(startLipSyncKey))
      {
        isSyncing = !isSyncing;

        driver.initializeLipSync = isSyncing;
        driver.lipSync = isSyncing;
      }

      if (Input.GetKeyDown(recalibrateFacing))
        target.calibrate = true;
    }
  } 
}
