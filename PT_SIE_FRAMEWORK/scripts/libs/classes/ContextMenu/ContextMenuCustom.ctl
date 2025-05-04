// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author m.woegrath
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/ContextMenu/ContextMenu"


//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
  Handles a custom Context menu
  @details Opens the context menu buttons in an wincc oa panel
*/
class ContextMenuCustom : ContextMenu
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public ContextMenuCustom()
  {
  }

  /**
    @brief Opens a panel as context menu in relation to a parent reference
      Opens the panel "objects_parts/ContextMenu/popup.xml" in relation to a parent reference.
      This Panel can be modified and saved in the project.
    @warning CascadeButtons are not implemented yet
    @param ref ... Parent reference
    @return The answer value of the clicked choice in the panel, if nothing was clicked returns -1
  */
  public int Open()
  {
    int answer;

    int x, y;
    int w, h;
    int xPos, yPos;
    int xAbsolute, yAbsolute;
    int wScreen, hScreen;

    if (!shapeExists(_ref))
    {
      DialogFramework::warning(makeMapping("text", "Button '" + _ref + "' doesn't exist"));
      return -1;
    }

    dyn_int dynsize;
    getValue(_ref, "position", x, y,
             "size", w,h);

//     w = dynsize.at(0);
//     h = dynsize.at(1);

    dyn_int size = getPanelSize(PopupRef);

    panelPosition(myModuleName(), "", xAbsolute, yAbsolute);
    getScreenSize(wScreen, hScreen);

    int yPopup = 0;
    dyn_string buttonList = GetButtonList();
    int buttonListCount = buttonList.count();

    for (int i = 0; i < buttonListCount; i++)
    {
      dyn_string button = buttonList.at(i).split(",");

      dyn_int refSize;

      switch (button.at(0))
      {
        case "SEPARATOR": refSize = getPanelSize(SeperatorRef); break;

        case "PUSH_BUTTON": refSize = getPanelSize(PushButtonRef); break;

        case "CHECK_BUTTON": refSize = getPanelSize(CheckButtonRef); break;

        default: refSize = makeDynInt(0, 10); break;
      }

      yPopup += refSize.at(1);
    }

    if ((yAbsolute + y + yPopup) > hScreen)
    {
      y -= yPopup;
    }
    else
    {
      y += 42;
    }

    x += w/* - size.at(0)*/;

    dyn_anytype panel = makeDynAnytype(myModuleName(), getPath(PANELS_REL_PATH, PopupRef), myPanelName(), "popup",
                                       x, y,
                                       1.0, true,
                                       makeDynString("$Items:" + dynStringToString(buttonList, "~")), false,
                                       makeMapping("windowFlags", "Popup")); //open child panel as popup

    dyn_anytype ret;
    childPanel(panel, ret);

    return (ret.count()) ? ret.at(0) : -1;
  }

  /**
    @brief Sets Button Referenz
    @param ref
  */
  public void SetRef(const string &ref)
  {
    _ref = ref;
  }

  /**
    @brief Builds the panel with given buttons
      Adds the different types of items a context menu can have to the current panel.
    @param buttons ... Given buttons
  */
  public static void BuildPopup(const dyn_string &buttons)
  {
    int posY = 0;

    for (int i = 0; i < buttons.count(); i++)
    {
      dyn_string item = buttons.at(i).split(",");

      dyn_int refSize;

      switch (item.at(0))
      {
        case "SEPARATOR": addSymbol(myModuleName(), myPanelName(), SeperatorRef, (string)i, "", 0, posY); refSize = getPanelSize(SeperatorRef); break;

        case "PUSH_BUTTON": addSymbol(myModuleName(), myPanelName(), PushButtonRef, (string)i, makeDynString("$Text:" + item.at(1), "$Answer:" + item.at(2), "$Active:" + item.at(3)), 0, posY); refSize = getPanelSize(PushButtonRef); break;

        case "CHECK_BUTTON": addSymbol(myModuleName(), myPanelName(), CheckButtonRef, (string)i, makeDynString("$Text:" + item.at(1), "$Answer:" + item.at(2), "$Checked:" + item.at(3), "$Active:" + item.at(4)), 0, posY); refSize = getPanelSize(CheckButtonRef); break;

        default: refSize = makeDynInt(0, 10); break;
      }

      posY += refSize.at(1) - 1;
    }


    setPanelSize(myModuleName(), myPanelName(), FALSE, 200, posY);
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

  private const string PopupRef = "IX/objects_parts/ContextMenu/popup.xml";
  private string _ref;
  private static const string SeperatorRef = "IX/objects_parts/ContextMenu/popup_seperator.xml"; //!< Panel reference of a Seperator in the panel context menu
  private static const string PushButtonRef = "IX/objects_parts/ContextMenu/popup_pushbutton.xml"; //!< Panel reference of a PushButton in the panel context menu
  private static const string CheckButtonRef = "IX/objects_parts/ContextMenu/popup_checkbutton.xml"; //!< Panel refrence of a CheckButton in the panel context menu
};
