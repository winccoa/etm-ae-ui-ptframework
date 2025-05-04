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
class GUINaviExitButton : GUINaviButton
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviExitButton(const shape &textRef, const shape &iconRef, const shape &frameSelector) : GUINaviButton(textRef, iconRef, frameSelector)
  {
  }

  public void Clicked()
  {
    dyn_string dsModSpilt = strsplit(myModuleName(), "_");
    int iModNum = dsModSpilt[dynlen(dsModSpilt)];

    dyn_string dsModuleNames = getVisionNames();
DebugN("dsModuleNames", dsModuleNames, myModuleName(), iModNum, "WinCC_OA_"+iModNum);
    if (dynContains(dsModuleNames, "Tunnel_Model_" + iModNum))
    {
      ModuleOff("Tunnel_Model_" + iModNum);
    }
    else if (dynContains(dsModuleNames, "Vision_" + iModNum))
    {
      ModuleOff("Vision_" + iModNum);
    }
    else if (dynContains(dsModuleNames, "WinCC_OA_" + iModNum))
    {
      DebugN("close main module", "WinCC_OA_" + iModNum);
      ModuleOff("WinCC_OA_" + iModNum);
    }
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

};
