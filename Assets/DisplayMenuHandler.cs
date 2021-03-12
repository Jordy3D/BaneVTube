using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DisplayMenuHandler : MonoBehaviour
{
  public KeyCode hideMenuKey = KeyCode.Y;

  public GameObject mainMenuPanel;
  public GameObject[] menuPanels; //menuDisplayPanel, glitchDisplayPanel;

  public UnityEvent onMenuToggleEvent;

  bool menuDisplayVisible;
  // Start is called before the first frame update
  void Start()
  {
    SetMenuDisplayVisible(false);

    DisableAllOtherGameObjects();
  }

  public void Update()
  {
    if (Input.GetKeyDown(hideMenuKey))
      onMenuToggleEvent.Invoke();
  }

  #region Original Toggles and Sets
  public void ToggleMenuDisplay()
  {
    menuDisplayVisible = !menuDisplayVisible;
    mainMenuPanel.SetActive(menuDisplayVisible);
  }

  public void SetMenuDisplayVisible(bool _state)
  {
    menuDisplayVisible = _state;
    mainMenuPanel.SetActive(_state);
  }
  #endregion

  public void TogglePanelDisplay(int _menuIndex)
  {
    GameObject panel = menuPanels[_menuIndex];
    bool isActive = !panel.activeInHierarchy;
    panel.SetActive(isActive);
    if (isActive)
      DisableAllOtherGameObjects(panel);
  }

  public void DisableAllOtherGameObjects(GameObject _activePanel = null)
  {
    if (_activePanel)
    {
      foreach (GameObject panel in menuPanels)
        panel.SetActive(false);

      _activePanel.SetActive(true);
    }
  }
}
