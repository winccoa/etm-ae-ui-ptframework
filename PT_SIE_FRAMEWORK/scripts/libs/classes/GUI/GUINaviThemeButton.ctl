// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author n.holzersoellner
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/GUI/GUINaviButton"


//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
class GUINaviThemeButton : GUINaviButton
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviThemeButton(const shape &textRef, const shape &iconRef, const shape &frameSelector) : GUINaviButton(textRef, iconRef, frameSelector)
  {
  }

  public void Clicked()
  {
    string activeTheme = colorGetActiveScheme();
    colorSetActiveScheme((activeTheme != darkTheme) ? darkTheme : lightTheme);
    setActiveIconTheme((activeTheme != darkTheme) ? darkTheme : lightTheme);
    setApplicationProperty("styleSheet", getApplicationProperty("styleSheet"));
    triggerGlobalEvent("ColorSchemeChanged");
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

  private const string darkTheme = "Siemens_Dark";
  private const string lightTheme = "Siemens_Light";
};
