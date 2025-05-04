// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @brief This file contains the definition of the GUINaviButton class.
  @details The GUINaviButton class represents a navigation button in a graphical user interface.
  @copyright $copyright
  @author n.holzersoellner
*/


/**
 * @class GUINaviButton
 * @brief Represents a navigation button in a graphical user interface.
 * @details The GUINaviButton class provides functionality to create and manipulate navigation buttons in a GUI.
 */
class GUINaviButton
{

#event ClickedEvent(int mode, anytype value, shared_ptr<GUINaviButton> button)

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /**
   * @brief Default constructor for GUINaviButton class.
   * @param textRef The reference to the shape representing the button's text.
   * @param iconRef The reference to the shape representing the button's icon.
   * @param frameSelector The reference to the shape representing the button's frame selector.
   */
  public GUINaviButton(const shape &textRef, const shape &iconRef, const shape &frameSelector)
  {
    _textRef = textRef;
    _iconRef = iconRef;
    _frameSelector = frameSelector;
  }

  /**
   * @brief Sets the hover color of the button.
   * @param hover A boolean indicating whether the button is being hovered over.
   */
  public void SetHoverColor(const bool &hover)
  {
    _frameSelector.backCol((hover) ? colorGhostHover : _currentBackColor);
    _textRef.SetForeColor((hover) ? colorTextHover : colorText);
  }

  /**
   * @brief Sets the active state of the button.
   * @param active A boolean indicating whether the button is active.
   */
  public void SetActive(const bool &active)
  {
    _currentBackColor = (active) ? colorGhostSelected : colorGhost;
    _frameSelector.backCol(_currentBackColor);
    _iconRef.SetSelBackCol((active) ? colorPrimary : colorGhost);
  }

  /**
   * @brief Sets the icon of the button.
   * @param fill The fill string for the button's icon.
   */
  public void SetIcon(const string &fill){
    _iconRef.SetIcon(fill);
  }

  /**
   * @brief Sets the text of the button.
   * @param text The text to be displayed on the button.
   */
  public void SetText(const langString &text)
  {
    _textRef.SetText(text);
  }

  /**
   * @brief Sets the visibility of the button.
   * @param visible A boolean indicating whether the button is visible.
   */
  public void SetVisible(const bool &visible)
  {
    _textRef.SetVisible(visible);
  }

  /**
   * @brief Handles the button click event.
   * @details Throws an error indicating that the Clicked function is not defined.
   */
  public void Clicked(){
    throw(makeError("", PRIO_SEVERE, ERR_PARAM, 0, "Clicked Function not defined."));
  }

  /**
   * @brief Sets the pointer to another GUINaviButton object.
   * @param button A shared pointer to the GUINaviButton object.
   */
  public void SetPointer(shared_ptr<GUINaviButton> button){
    assignPtr(_button, button);
  }

  /**
   * @brief Gets the pointer to another GUINaviButton object.
   * @return A shared pointer to the GUINaviButton object.
   */
  public shared_ptr<GUINaviButton> GetPointer(){
    return _button;
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
  private shape _iconRef;
  private shape _textRef;
  private shape _frameSelector;

  private shared_ptr<GUINaviButton> _button;

  private string _currentBackColor;

  private const string colorGhost = "color-ghost";
  private const string colorGhostHover = "color-ghost--hover";
  private const string colorGhostSelected = "color-ghost--selected";
  private const string colorPrimary = "color-primary";
  private const string colorText = "color-soft-text";
  private const string colorTextHover = "color-std-text";
};
