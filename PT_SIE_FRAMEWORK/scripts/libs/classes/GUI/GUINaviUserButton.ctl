// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author n.holzersoellner
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/ContextMenu/ContextMenuCustom"
#uses "classes/GUI/GUINaviButton"


//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
class GUINaviUserButton : GUINaviButton {
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviUserButton(const shape &textRef, const shape &iconRef, const shape &frameSelector) : GUINaviButton(textRef, iconRef, frameSelector) {
    string myUiDp = myUiDpName();
    dpConnect("ChangeUserCB", myUiDp + ".UserName");
  }

  public void Clicked() {
    int answer;
    string dp, user;
    time tStime;
    string loginAsAllowed = "1";
    shared_ptr<ContextMenuCustom> userMenu = new ContextMenuCustom();
    string userManagementAllowed = (getUserPermission(4)) ? "1" : "0";
    string logoutAllowed = (getUserName() != "") ? "1" : "0";
    string changePasswordAllowed = (getUserName() != "") ? "0" : "1";


    if (getKerberosSecurity() > 0) {
      logoutAllowed = "0";
      loginAsAllowed = "0";
      changePasswordAllowed = "0";
    }

    if (isUltralight() && (getUserId() != DEFAULT_USERID)) {
      loginAsAllowed = "0";
    }

    OaAuthFactory factory;
    shared_ptr<OaAuthMethod> auth = factory.getAuth();

    if (!auth.passwordResetEnabled()) {
      dyn_int ids;
      dyn_string osIds;
      dpGet("_Users.UserId", ids, "_Users.OSIDs", osIds);
      int pos = dynContains(ids, getUserId());

      if ((pos > 0) && (dynlen(osIds) >= pos) && (osIds[pos] != "")) {
        changePasswordAllowed = "0";
      }
    }

    userMenu.SetRef("frameSelector");
    userMenu.Clear();
    userMenu.AddPushButton(getCatStr("STD", "Text4"), 1, loginAsAllowed, "");
    userMenu.AddPushButton(getCatStr("STD", "Text5"), 2, logoutAllowed, "");
    userMenu.AddSeperator("");
    userMenu.AddPushButton(getCatStr("STD", "infomenu"), 0, 0, "");
    userMenu.AddPushButton(getCatStr("STD", "Text7"), 4, 1, "");
    userMenu.AddPushButton(getCatStr("STD", "Text8"), 5, 1, "");
    userMenu.AddSeperator("");
    userMenu.AddPushButton(getCatStr("STD", "Text6"), 3, userManagementAllowed, "");
    userMenu.AddSeperator("");
    userMenu.AddPushButton(getCatStr("STD", "changepassword"), 7, changePasswordAllowed, "");
    userMenu.AddSeperator("");
    userMenu.AddPushButton(getCatStr("STD", "Text13"), 6, userManagementAllowed, "");

    answer = userMenu.Open();

    dp = myUiDpName() + ".";
    dpGet(dp + "UserName:_online.._stime", tStime,
          dp + "UserName:_online.._value", user);

    switch (answer) {
      case 1: STD_LoginAs();
        return;

      case 2: STD_LogoutCurrentUser();
        return;

      case 3: ChildPanelOnCentralModal("vision/ud_main.pnl",
                                         getCatStr("STD", "Text6"), makeDynString());
        return;

      case 4: ChildPanelOnCentralModal("vision/MessageInfo1", getCatStr("STD", "Text9"),
                                         makeDynString(getCatStr("STD", "Text7") + ": "
                                             + formatTime("%c", tStime)));
        return;

      case 5: ChildPanelOnCentralModal("vision/UserConnections", getCatStr("STD", "Text8"),
                                         makeDynString());
        return;

      case 6: msc_createFav(getUserName(), "lastScreenView");
        STD_CloseUis();
        return;

      case 7: ChildPanelOnCentralModal("vision/changePassword.pnl", getCatStr("STD", "changepassword"),
                                         makeDynString());
        return;

      default: return;
    }
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

  private void SetUserIcon(const string &name) {
    string userName = name;
    dyn_string userNameParts = stringToDynString(userName, " ");
    char firstInitial = userNameParts.first().left(1);
    char lastInitial;

    if (userNameParts.count() > 1) {
      lastInitial = userNameParts.last().left(1);
    }

    string userInitials = firstInitial + lastInitial;
    if (userInitials.isEmpty())
      userInitials = "~";

    iconRef.SetUserText(userInitials);
    textRef.SetText(getCatStr("SIE", "buttonNavi_user") + ": " + getUserName());
  }

  private void ChangeUserCB(const string &dp, const string &name) {
    if (!name.isEmpty()) {
      SetUserIcon(name);
    } else {
      SetUserIcon(" ");
    }
  }
};
