using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OpenSee.Bane
{
  public class OpenSeeVRMController : MonoBehaviour
  {
    OpenSeeVRMDriver driver;

    private void Awake()
    {
      driver = GetComponent<OpenSeeVRMDriver>();
    }

    public void SetEyeOpenedThreshold(System.Single _val) => driver.eyeOpenedThreshold = _val;
    public void SetEyeClosedThreshold(System.Single _val) => driver.eyeClosedThreshold = _val;
    public void SetAutoBlnk(System.Single _val) => driver.autoBlink = _val == 1;
  } 
}
