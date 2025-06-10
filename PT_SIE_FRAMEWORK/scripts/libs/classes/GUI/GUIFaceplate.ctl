// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author atw121x7
*/

global const bool FACEPLATELIB_LOADED; //!< Indicates if the faceplate library is loaded.

/**
 * @brief The GUIFaceplate class provides methods to manage faceplates in the GUI.
 */
class GUIFaceplate
{
  public static dyn_function_ptr _faceplateToOpen; //!< Stores the function pointers for faceplates to be opened.

  /**
   * @brief The Default Constructor.
  */
  private GUIFaceplate()
  {
  }

  /**
    * @brief Get the current screen number based on the module name.
    * @param module The module name to check. Defaults to the current module name.
    * @return The screen number as an integer.
  */
  public static int GetMyScreenNum(const string module = myModuleName())
  {
    if (!patternMatch("WinCC_OA_*", module))
    {
      shape rootPanelShape = getShape(module + "." + rootPanel(module) + ":");
      shape modShape = rootPanelShape.parentShape();
      shape modPanel = modShape.panel();
      module = modPanel.moduleName();

      if (!patternMatch("mainModule_*", module) && !patternMatch("WinCC_OA_*", module))
      {
        return GetMyScreenNum(module);
      }
    }

    dyn_string dsSplit = strsplit(module, "_");
    return dsSplit.last();
  }

  /**
   * @brief Adds a function pointer to the list of faceplates to be opened.
   * @param faceplateToOpen The function pointer for the faceplate.
   * @param monitorNr The monitor number where the faceplate should be opened. Defaults to -1, which uses the current screen number.
  */
  public static void AddFunctionPtr(const function_ptr &faceplateToOpen, int monitorNr = -1)
  {
    if (monitorNr == -1)
    {
      monitorNr = GetMyScreenNum();
    }

    _faceplateToOpen.insertAt(monitorNumber, faceplateToOpen);
  }

  /**
   * @brief Triggers the opening of a faceplate on the specified panel.
   * @param panel The name of the panel where the faceplate should be opened.
   * @param open A boolean indicating whether to open (TRUE) or close (FALSE) the faceplate. Defaults to TRUE.
  */
  public static TriggerOpenFaceplate(const string &panel, const bool open = TRUE)
  {
    triggerEvent(_faceplateToOpen.at(GetMyScreenNum()), panel, open);
  }
};
