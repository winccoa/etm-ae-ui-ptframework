// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author n.holzersoellner
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/GUI/GUINaviPanelButton"
#uses "classes/GUI/GUINaviButton"
#uses "classes/Timer/Timer"
#uses "classes/GUI/GUINaviButtonCollection"
#uses "classes/GUI/faceplate"


//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
class GUIBasePanel {
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUIBasePanel(const shape &naviModule, const shape &mainModule, const shape &headerModule, const shape &infoModule, const shape &faceplateModule, const string &Screen) {
    _naviModule = naviModule;
    _mainModule = mainModule;
    _infoModule = infoModule;
    _headerModule = headerModule;
    _faceplateModule = faceplateModule;

    naviModule.ModuleName = ptms_BuildModuleName("naviModule",Screen);
    mainModule.ModuleName = ptms_BuildModuleName("mainModule",Screen);
    infoModule.ModuleName = ptms_BuildModuleName("infoModule",Screen);
    headerModule.ModuleName = ptms_BuildModuleName("headerModule",Screen);
    faceplateModule.ModuleName = ptms_BuildModuleName("faceplateModule",Screen);

    int w, h;
    getValue(self, "size", w, h);

    dyn_int headerSize = _headerModule.sizeAsDyn();
    dyn_int naviSize = _naviModule.sizeAsDyn();

    _naviModule.size(naviSize.at(0), h - headerSize.at(1));
    //If Fullscreen is needed uncomment this section:
    /*
    moduleShowFullScreen(myModuleName());
    */

    //Stylesheet Parameters:
    string cssCode;
    string tooltipStyle = "QToolTip { background-color: oa-color(color-2); color: oa-color(color-std-text); border: none; border-radius: 4px; padding: 4px; font-family: 'Siemens Sans'; font-style: normal; font-weight: 700; font-size: 16px;}";

    string tableHeaderStyle = "QHeaderView::section {background-color: oa-color(color-2); color: oa-color(color-std-text); padding: 4px; border: none;} QTableCornerButton::section { background-color:oa-color(color-2); } QHeaderView{background-color: oa-color(color-2); } QHeaderView::section:hover {background: oa-color(color-ghost--hover); }";

    string aesRowStyle = ("QTableView[type=\"alert_row\"] {font-family: \"Siemens Sans\", sans-serif;font-size: 14px;color: oa-color(color-std-text);background-color: oa-color(color-ghost);border: none;}"
                          "QTableView[type=\"alert_row\"]::item {border: none;padding-left: 10px;line-height: 20px;height: 20px;text-align: center;background-color: oa-color(color-ghost);}"
                          "QTableView[type=\"alert_row\"]::item:hover {background-color: oa-color(color-ghost--hover);}"
                          "QLineEdit[type=\"alert_row\"] {background-color: oa-color(color-ghost);color: oa-color(color-std-text);border: none;}"
                          "QPushButton[type=\"alert_row_up\"],QPushButton[type=\"alert_row_down\"] {background-position: center;border: none;padding: 4px;}"
                          "QPushButton[type=\"alert_row_up\"]:hover {background-color: oa-color(color-ghost--hover);}"
                          "QPushButton[type=\"alert_row_down\"]:hover {background-color: oa-color(color-ghost--hover);}");

    string scrollbarStyle = ("QScrollBar:vertical {width: 8px; margin: 0px; border-radius: 4px;background: oa-color(color-2);}"
                             "QScrollBar:horizontal {height: 8px; margin: 0px; background: oa-color(color-2);}"
                             "QScrollBar:vertical:hover {background: oa-color(color-3);}"
                             "QScrollBar:horizontal:hover {background: oa-color(color-3);}"
                             "QScrollBar::handle:vertical {min-height: 20;border-radius: 4px;background: oa-color(color-5);}"
                             "QScrollBar::handle:horizontal {min-width: 20;border-radius: 4px;background: oa-color(color-5);}"
                             "QScrollBar::handle:vertical:hover {background: oa-color(color-7);}"
                             "QScrollBar::handle:horizontal:hover {background: oa-color(color-7);}"
                             "QScrollBar::add-line:vertical,QScrollBar::sub-line:vertical {background: none;}"
                             "QScrollBar::add-line:horizontal,QScrollBar::sub-line:horizontal {background: none;}"
                             "QScrollBar::add-page:vertical,QScrollBar::sub-page:vertical {background: none;}"
                             "QScrollBar::add-page:horizontal,QScrollBar::sub-page:horizontal {background: none;}");

    string chipStyle = ("QLineEdit[type^=\"fchip_\"] { color: oa-color(color-inv-contrast-text); border: none; border-radius: 12px; font-family: 'Siemens Sans'; font-style: normal; font-weight: 400; font-size: 14px; }"
                        "QLineEdit[type=\"fchip_primary\"] { border-color: oa-color(color-primary); background-color: oa-color(color-primary); }"
                        "QLineEdit[type=\"fchip_alarm\"] { border-color: oa-color(color-alarm); background-color: oa-color(color-alarm); }"
                        "QLineEdit[type=\"fchip_alarm_ref\"] { background-color: oa-color(color-alarm); }"
                        "QLineEdit[type=\"fchip_critical\"] { border-color: oa-color(color-critical); background-color: oa-color(color-critical); }"
                        "QLineEdit[type=\"fchip_warning\"] { border-color: oa-color(color-warning); background-color: oa-color(color-warning); }"
                        "QLineEdit[type=\"fchip_info\"] { border-color: oa-color(color-info); background-color: oa-color(color-info); }"
                        "QLineEdit[type=\"fchip_neutral\"] { border-color: oa-color(color-neutral); background-color: oa-color(color-neutral); }"
                        "QLineEdit[type=\"fchip_success\"] { border-color: oa-color(color-success); background-color: oa-color(color-success); }"
                        "QLineEdit[type=\"fchip_primary\"]:hover { border-color: oa-color(color-primary--hover); background-color: oa-color(color-primary--hover); }"
                        "QLineEdit[type=\"fchip_alarm\"]:hover { border-color: oa-color(color-alarm--hover); background-color: oa-color(color-alarm--hover); }"
                        "QLineEdit[type=\"fchip_critical\"]:hover { border-color: oa-color(color-critical--hover); background-color: oa-color(color-critical--hover); }"
                        "QLineEdit[type=\"fchip_warning\"]:hover { border-color: oa-color(color-warning--hover); background-color: oa-color(color-warning--hover); }"
                        "QLineEdit[type=\"fchip_info\"]:hover { border-color: oa-color(color-info--hover); background-color: oa-color(color-info--hover); }"
                        "QLineEdit[type=\"fchip_neutral\"]:hover { border-color: oa-color(color-neutral--hover); background-color: oa-color(color-neutral--hover); }"
                        "QLineEdit[type=\"fchip_success\"]:hover { border-color: oa-color(color-success--hover); background-color: oa-color(color-success--hover); }");

    string trendStyle = "TrendQT[type=\"primary\"]{border:none;}";

    string splitterStyle = ("QSplitter[type=\"primary\"]::handle { border: 1px solid oa-color(color-4); border-radius: 5px; color: oa-color(color-ghost); background-color: oa-color(color-ghost); }"
                            "QSplitter[type=\"primary\"]::handle:hover { background-color: oa-color(color-ghost--hover); }");

    cssCode = tooltipStyle + tableHeaderStyle + aesRowStyle + scrollbarStyle + chipStyle + trendStyle + splitterStyle;

    self.windowFlags("FramelessWindowHint");
    self.styleSheet(cssCode);
    colorSetActiveScheme("Siemens_Dark");
    setActiveIconTheme("Siemens_Dark");
//     _mainModule.ModuleName = ptms_BuildModuleName("mainModule", myUiNumber());
//     _naviModule.ModuleName = ptms_BuildModuleName("naviModule", myUiNumber());

    setScaleStyle(SCALE_FIT_TO_MODULE, _mainModule.ModuleName);
    setScaleStyle(SCALE_NONE, _naviModule.ModuleName);


    _infoPanelName = "Info_" + createUuid();
    nameCheck(_infoPanelName);

    _mainPanelName = "Main_" + createUuid();
    nameCheck(_mainPanelName);
    _actualPanel = _mainPanelName;
    _menuOpen = TRUE;


    //If title bar is not needed, change this:
    titleBar(TRUE);
  }

  public void Initialize() {
//     RootPanelOnModule(_headerPanel, _headerPanelName, _headerModule.ModuleName, makeDynString());
//     RootPanelOnModule(_infoPanel, _infoPanelName, _infoModule.ModuleName, makeDynString());
//     RootPanelOnModule(_naviPanel, _naviPanelName, _naviModule.ModuleName, makeDynString());
//     RootPanelOnModule(_faceplatePanel, _infoPanelName, _faceplateModule.ModuleName, makeDynString());

//     dpConnect("UserChangeCB", FALSE, "System1:General.authorization.position:_online.._value");
//     int val;
//     dpGet("System1:General.authorization.position:_online.._value", val);
//     UserChangeCB("System1:General.authorization.position:_online.._value", val);
//     dpConnect("ET200ALMCB", TRUE, "System1:General.maintenanceNeeded:_online.._value");
//     while(!isPanelOpen(p,m))
//     { delay(0,10); }
//
    assignPtr(_naviButtons, invokeMethod(getShape(_naviModule.ModuleName(), rootPanel(_naviModule.ModuleName()), ""), "GetGuiNaviButtonCollection"));
    classConnect(this, ClickedCB, _naviButtons, GUINaviButtonCollection::ClickedEvent);

    if (_menuOpen) {
      ClickedCB(2, "", nullptr);
    }

    if (getPath(PANELS_REL_PATH, "tunnel/tunnelBase.pnl") != "")
      ClickedCB(1, "tunnel/tunnelBase.pnl",_naviButtons.GetByIndex(0));

//     dyn_string alertDps = makeDynString("S2SOS1.response.emergencyAlert",
//                                         "S2BFA1.response.fireAlarm",
//                                         "General.S1DOOR1FeedbackOpen");
//
//
//     for (int i = 0; i < alertDps.count(); i++) {
//       dpConnectUserData("VideoCB", "video_alarm_txt_" + (i + 1), 0, alertDps.at(i));
//     }

    dpConnect("HomePanelCB", 0, "_Ui_" + myManNum() + ".UserName");

    classConnect(this, HideNavi, _hideNavi, Timer::TimerDone);
  }

  public string GetInfoPanelName() {
    return _infoPanelName;
  }
//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

  private shared_ptr<Timer> _hideNavi = new Timer(1);
  private shared_ptr<GUINaviButtonCollection> _naviButtons;
  private shape _naviModule;
  private shape _mainModule;
  private shape _infoModule;
  private shape _headerModule;
  private shape _faceplateModule;

//   private string _headerPanel = "para/PanelTopology/templates/USERDEFINED/headerPanel.pnl";
//   private string _infoPanel = "para/PanelTopology/templates/USERDEFINED/infoPanel.pnl";
//   private string _naviPanel = "para/PanelTopology/templates/USERDEFINED/naviPanel.pnl";
//   private string _mainPanel = "tunnel/tunnelBase.pnl";
//   private string _faceplatePanel = "/IX/faceplates/faceplateSideModuleBasePanel";

  private string _actualPanel;
  private string _mainPanelName;

  private string _infoPanelName;

  private bool _menuOpen = TRUE;
  private bool bLogged = TRUE;

  private const int Admin = 1;
  private const int User = 2;
  private const int Customer = 3;
  private const int User1 = 4;
  private const int Admin_2 = 0;

  private void ClickedCB(const int &mode, const anytype &value , shared_ptr<GUINaviButton> button) {

    dyn_int moduleSize;
    dyn_int newModuleSize;
    dyn_string params;
    int moduleHeight;
    anytype _value = value;

    switch (mode) {
      case 1:
        _mainPanelName = "Main_" + createUuid();

        if (_value.contains("tunnel")) {
          dyn_string tmp = _value.split("|");

          if (tmp.count() > 1) {
            params = makeDynString("$sectorName:" + tmp.at(1));
          } else {
            params = makeDynString("$sectorName:" + "");
          }

          _value = tmp.at(0);
        }

        if (_value.contains("gis")) {
          _mainPanelName = _mainPanelName + "_GIS";
        }

        nameCheck(_mainPanelName);
        PanelOffModule(_actualPanel, _mainModule);

        if (_value.contains("settings")) {
          params = makeDynString("$infoPanelName:" + _infoPanelName);
        }
        if (!openPtPanel(_value, _mainPanelName, _mainModule.ModuleName(), params))
          RootPanelOnModule(_value, _mainPanelName, _mainModule.ModuleName(), params);
        _actualPanel = _mainPanelName;
        _naviButtons.SetInactive();
        button.SetActive(TRUE);
        Faceplate::triggerOpenFaceplate("", FALSE);
        break;

      case 2:
        moduleSize = naviModule.sizeAsDyn();
        moduleHeight = moduleSize.at(1);

        if (!_menuOpen) {
          newModuleSize = makeDynInt(300, moduleHeight);

          if (moduleSize != newModuleSize) {
            for (int i = 0; i < _naviButtons.Count(); i++) {
              if (getTypeName(_naviButtons.GetByIndex(i)) == "GUINaviMenuButton") {
                _naviButtons.GetByIndex(i).SetOpen(!_menuOpen);
              }

              _naviButtons.GetByIndex(i).SetVisible(TRUE);
            }

            setPanelSize(_naviModule.ModuleName(), rootPanel(_naviModule.ModuleName()), false, newModuleSize.at(0), newModuleSize.at(1));
            animateWait(_naviModule, "sizeAsDyn", moduleSize, newModuleSize, makeMapping("duration", 500));
          }

          _menuOpen = TRUE;
          _hideNavi.Start();
        } else {
          newModuleSize = makeDynInt(50, moduleHeight);

          if (moduleSize != newModuleSize) {
            animateWait(_naviModule, "sizeAsDyn", moduleSize, newModuleSize, makeMapping("duration", 500));
            setPanelSize(_naviModule.ModuleName(), rootPanel(_naviModule.ModuleName()), false, newModuleSize.at(0), newModuleSize.at(1));

            for (int i = 0; i < _naviButtons.Count(); i++) {
              if (getTypeName(_naviButtons.GetByIndex(i)) == "GUINaviMenuButton") {
                _naviButtons.GetByIndex(i).SetOpen(!_menuOpen);
              }

              _naviButtons.GetByIndex(i).SetVisible(FALSE);
            }
          }

          _menuOpen = FALSE;
          _hideNavi.Stop();
        }

        break;
    }
  }

  /**
    @brief Function that allows changing user on runtime
    @param dp ... string dp
    @param user ... int user
  */
  private void UserChangeCB(const string &dp, const int &user) {

    bool auth;
    bool change;
    string myUiDp = myUiDpName();


    dpGet("General.authorization.idKeyRecognized", auth,
          "TUNNEL_DEMO_SETTINGS.login.SiriusActID_on", change);


    if (auth && change) {
      STD_LogoutCurrentUser();
      bLogged = FALSE;
      delay(0,250);

      switch (user) {
        case Admin:
          setUserId(getUserId("Admin"), "Admin123#");
          break;

        case Admin_2:
          setUserId(getUserId("Admin"), "Admin123#");
          break;

        case User:
          setUserId(getUserId("User"), "User123#");
          break;

        case Customer:
          setUserId(getUserId("Customer"), "Customer123#");
          break;

        case User1:
          setUserId(getUserId("User1"), "User1123#");
          break;
      }
      dpSet(myUiDp + ".UserName", getUserName());
    }

    if (!auth && change && (user != 0)) {
      STD_LogoutCurrentUser();

      ChildPanelOnParentModal("vision/Message_Warning.pnl",
                              "warning", rootPanel(),
                              makeDynString("$Txt:Id Key not recognized, please insert a correct ID stick"), 100, 100);

    }

    if (user == 0 && (!auth && change)) {
      STD_LogoutCurrentUser();
    }
  }

  private void VideoCB(const string &keyWord, const string &dp, const bool &value) {
    langString descrip;

    if (value == TRUE) {
      if ((keyWord == "video_alarm_txt_1") || (keyWord == "video_alarm_txt_2"))
        ClickedCB(1, "tunnel/tunnelBase.pnl|Sector2", _naviButtons.GetByIndex(0));


      string alertTxt = dpSubStr(dp, DPSUB_DP) + ": " + getCatStr("tunnelDemo", keyWord);
      ChildPanelOn("ref/video_alarmCamera.pnl", "Cameras", makeDynString("$alarmText:" + alertTxt), 50, 50);
    }
  }



  private void HomePanelCB(const string &dp, const string &user) {
    langString descrip;
    ClickedCB(1, "tunnel/tunnelBase.pnl", _naviButtons.GetByIndex(0));

  }

  /**
    @brief Function open Maintenance panel
    @param dp ... string dp
    @param value ... bool value
  */
  private void ET200ALMCB(const string &dp, const bool &value) {
    if (value) {
      ChildPanelOnParentModal("vision/MessageWarning_Maintenance.pnl",
                              "warning", rootPanel(),
                              makeDynString("$Txt:Failure of ET 200SP Modules in control cabinet 1!Do you want to view the manual?"), 100, 100);
    }
  }

  private void HideNavi() {
    dyn_int position = _naviModule.positionAsDyn();
    dyn_int size = _naviModule.sizeAsDyn();

    int posX, posY;
    int x, y;

    getValue("", "mapToGlobal", position.at(0), position.at(1), posX, posY);

    getCursorPosition(x, y, TRUE);

    if ((x >= posX && x <= posX + size.at(0)) && (y >= posY && y <= posY + size.at(1))) {
      return;
    }

    ClickedCB(2, "", nullptr);
  }

  private bool openPtPanel(anytype _value, string _mainPanelName, string _mainModule, dyn_string params)
  {
//     DebugN("open pane PT?", _value, _mainPanelName, _mainModule, params);


  int error = pt_checkPanelTopologyCache();

  // error==-1 dpGet-error
  if (error<0)
  {
    error=-1;
    return false;
  }

  if (((int)_value) == (string)_value) //is already pt pos
  {
    pt_panelOn3(_value, _naviModule.ModuleName());
    return true;
  }

//   indices = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.panelNumber:_online.._value"];
//   parents = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.parentNumber:_online.._value"];
//   alerts  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.sumAlertNumber:_online.._value"];
//   names   = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.nodeName:_online.._value"];
//   panels  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.fileName:_online.._value"];
//   types   = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.panelType:_online.._value"];
//   modules = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.moduleName:_online.._value"];
//   icons   = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.iconName:_online.._value"];
//   menuBar    = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.menuBar:_online.._value"];
//   iconBar    = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.iconBar:_online.._value"];
//   modals  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.modal:_online.._value"];
//   centered= g_PanelTopologyCache[ systemPrefix + "_PanelTopology.centered:_online.._value"];
//   parameters = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.parameter:_online.._value"];
//   permissions = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.permissionBit:_online.._value"];
//   description  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.description:_online.._value"];
//   locality  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.locality:_online.._value"];
//   functionality  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.functionality:_online.._value"];
//   panellink  = g_PanelTopologyCache[ systemPrefix + "_PanelTopology.panelLink:_online.._value"];
//     DebugN("open pane PT content:", g_PanelTopologyCache);
    //
    string systemPrefix = getSystemName();



    for (int i = 1; i <= dynlen(g_PanelTopologyCache[systemPrefix + "_PanelTopology.fileName:_online.._value"]); i++)
    {
      if (g_PanelTopologyCache[systemPrefix + "_PanelTopology.fileName:_online.._value"][i] == _value)
      {
        pt_panelOn3(i, "mainModule_"+myUiNumber());
//         return false; //for testing
        return true;
      }
    }
    return false;
  }
};
