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
class GUINaviMenuButton : GUINaviButton
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviMenuButton(const shape &textRef, const shape &iconRef, const shape &frameSelector) : GUINaviButton(textRef, iconRef, frameSelector)
  {
    SetOpen(FALSE);
  }

  public void Clicked()
  {
    ClickedEvent(2, "", nullptr);
  }

  public void SetOpen(bool open)
  {
    SetIcon((open) ? openedFillString : closedFillString);
  }
//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
  private const string openedFillString = "[pattern,[fit,any,white/double-chevron-left.svg]]";
  private const string closedFillString = "[pattern,[fit,any,white/double-chevron-right.svg]]";
};
