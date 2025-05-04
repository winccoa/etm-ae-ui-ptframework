// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author atw121x7
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants
global const bool FACEPLATELIB_LOADED;
//--------------------------------------------------------------------------------
/**
*/
class Faceplate
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------
  public static dyn_function_ptr dfpfaceplateToOpen;
  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  private Faceplate()
  {
  }

  public static int getMyScreenNum(string sModule = myModuleName())
  {
    if (!patternMatch("WinCC_OA_*", sModule))
    {
      shape shRootPanel = getShape(sModule + "." + rootPanel(sModule) + ":");
      shape shModShape = shRootPanel.parentShape();
//   DebugN("mtmtmt::", myModuleName(), myPanelName(), shRootPanel, shModShape, getStackTrace());
      shape shModPanel = shModShape.panel();
      sModule = shModPanel.moduleName();

      if (!patternMatch("mainModule_*", sModule) && !patternMatch("WinCC_OA_*", sModule))
      {
        return getMyScreenNum(sModule);
      }
    }

    dyn_string dsSplit = strsplit(sModule, "_");
    return dsSplit.last();
  }
  public static void addFunctionPtr(function_ptr fpfaceplateToOpen, int iMonitorNr = -1)
  {
    if (iMonitorNr == -1)
      iMonitorNr = getMyScreenNum();
    dfpfaceplateToOpen[iMonitorNr] = fpfaceplateToOpen;
  }
  public static triggerOpenFaceplate(string sPanel, bool bOpen=TRUE)
  {
    triggerEvent(dfpfaceplateToOpen[getMyScreenNum()], sPanel, bOpen);
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

};
