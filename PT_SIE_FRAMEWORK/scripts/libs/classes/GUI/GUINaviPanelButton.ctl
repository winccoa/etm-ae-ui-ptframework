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
class GUINaviPanelButton : GUINaviButton
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviPanelButton(const shape &textRef, const shape &iconRef, const shape &frameSelector, const string &childPanel) : GUINaviButton(textRef, iconRef, frameSelector)
  {
    _childPanel = childPanel;
  }

  public void Clicked(){
    ClickedEvent(1, _childPanel, GetPointer());
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
private string _childPanel;
};
