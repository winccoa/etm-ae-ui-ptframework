// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @brief ContextMenu
  @details Is used to easily configure and open a context menu
  @since Version 3.19
  @author Mario Wögrath
  @copyright $copyright
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/DialogFramework"

//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
  @brief Handles the ContextMenu
*/
class ContextMenu {
  //--------------------------------------------------------------------------------
  //@public members
  //--------------------------------------------------------------------------------

  /**
    @brief Adds a PushButton to the context menu
    @param text ... Text to appear in the context menu
    @param answer ... Return value of the PushButton
    @param active ... PushButton enabled:
      Value | Description
      ------|------------
      0     | Disabled
      1     | Enabled
    @param branchName ... Branch name to add the button, empty means no branch
  */
  public void AddPushButton(const string &text, const int &answer, const int active = 1, const string branchName = "") {
    string button = "PUSH_BUTTON," + text + "," + (string) answer + "," + (string) active;
    AddButton(branchName, button);
  }

  /**
    @brief Adds a Seperator to the context menu
    @param branchName ... Branch name to add the button, empty means no branch
  */
  public void AddSeperator(const string branchName = "") {
    string button = "SEPARATOR";
    AddButton(branchName, button);
  }

  /**
    @brief Adds a CheckButton to the context menu
    @param text ... Text to appear in the context menu
    @param answer ... Return value of the CheckButton
    @param active ... CheckButton enabled:
      Value | Description
      ------|------------
      0     | Disabled
      1     | Enabled
    @param checked ... CheckButton checked:
      Value | Description
      ------|------------
      0     | Disabled
      1     | Enabled
    @param branchName ... Branch name to add the button, empty means no branch
  */
  public void AddCheckButton(const string &text, const int &answer, const int checked = 0, const int active = 1, const string branchName = "") {
    string button = "CHECK_BUTTON," + text + "," + (string)answer + "," + (string)active + "," + (string)checked;
    AddButton(branchName, button);
  }

  /**
    @brief Adds a CascadeButton to the context menu
    @param text ... Text to appear in the context menu and name of the branch
    @param active ... CascadeButton enabled:
      Value | Description
      ------|------------
      0     | Disabled
      1     | Enabled
    @param branchName ... Branch name to add the button, empty means no branch
  */
  public void AddCascadeButton(const string &text, const int active = 1, const string branchName = "") {
    string button = "CASCADE_BUTTON," + text + "," + (string)active;
    AddButton(branchName, button);
  }

  /**
    @brief Opens the generic context menu on click
    @return The answer value of the clicked choice, if nothing was clicked returns -1
  */
  public int Open() {
    int answer;
    popupMenu(GetButtonList(), answer);
    return answer;
  }

  public int OpenXY(int x, int y, string font, string foreCol, string backCol) {
    int answer;
    popupMenuXY(GetButtonList(), x, y, answer, font, foreCol, backCol);
    return answer;
  }

  /**
    @brief Clears all buttons of the context menu
  */
  public void Clear() {
    _buttons.clear();
    _branches.clear();
  }

  /**
    @brief Returns list of all buttons including branches
    @return list of buttons
  */
  public dyn_string GetButtonList() {
    dyn_string buttonList = _buttons;
    int branchCount = _branches.count();

    for (int i = 0; i < branchCount; i++) {
      dynAppend(buttonList, _branches.keyAt(i));
      dynAppend(buttonList, _branches.valueAt(i));
    }

    return buttonList;
  }

  public mapping GetBranchlist(){
    return _branches;
  }


  //------------------------------------------------------------------------------
  //@private members
  //------------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  private dyn_string _buttons;
  private mapping _branches;

  /**
    @brief Adds button either to a branch or to button list
    @param branchName ... branch name, can be empty
    @param button ... Button
  */
  private void AddButton(const string &branchName, const string &button) {
    if (branchName.isEmpty()) {
      _buttons.append(button);
    } else {
      AddBranchButton(branchName, button);
    }
  }

  /**
    @Brief Adds button to branch
    @param branchName ... branch name
    @param button ... Button
  */
  private void AddBranchButton(const string &branchName, const string &button) {
    dyn_string branchList = _branches.value(branchName);
    branchList.append(button);
    _branches.insert(branchName, branchList);
  }
};
