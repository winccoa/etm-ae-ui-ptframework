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
  #uses "classes/GUI/GUINaviPanelButton"


  //--------------------------------------------------------------------------------
  // Variables and Constants

  //--------------------------------------------------------------------------------
  /**
  */
  /**
   * @class GUINaviButtonCollection
   * @brief Represents a collection of GUINaviButton objects.
   *
   * The GUINaviButtonCollection class provides methods to manage a collection of GUINaviButton objects.
   * It allows adding, removing, and accessing buttons in the collection, as well as performing operations
   * on all buttons in the collection, such as setting their visibility or making them inactive.
   */
  class GUINaviButtonCollection
  /**
   * @brief A collection of GUINaviButton objects.
   */
  {
    #event ClickedEvent(int mode, anytype value, shared_ptr<GUINaviButton> button)

    //--------------------------------------------------------------------------------
    //@public members
    //--------------------------------------------------------------------------------

    //------------------------------------------------------------------------------
    /**
     * @brief The Default Constructor.
     */
    public GUINaviButtonCollection()
    {
    }

    /**
     * @brief Checks if the collection contains a specific button.
     * @param button The button to check for.
     * @return True if the button is found in the collection, false otherwise.
     */
    public bool Contains(shared_ptr<GUINaviButton> button) {
      int count = Count();

      for (int i = 0; i < count; i++) {
        if (GetByIndex(i) == button) {
          return TRUE;
        }
      }

      return FALSE;
    }

    /**
     * @brief Gets the button at the specified index.
     * @param index The index of the button to retrieve.
     * @return The button at the specified index.
     * @throws An error if the index is higher than the collection count.
     */
    public shared_ptr<GUINaviButton> GetByIndex(const int &index) {

      if (index >= Count()) {
        throw (makeError("", PRIO_SEVERE, ERR_PARAM, 0, __FUNCTION__ + ", Index is higher than collection count"));
      }

      return _buttons.at(index);
    }

    /**
     * @brief Gets the number of buttons in the collection.
     * @return The number of buttons in the collection.
     */
    public int Count() {
      return _buttons.count();
    }

    /**
     * @brief Appends a button to the collection.
     * @param button The button to append.
     * @throws An error if the collection already contains the item.
     */
    public void Append(shared_ptr<GUINaviButton> button){
      if (Contains(button)) {
        throw (makeError("", PRIO_SEVERE, ERR_PARAM, 0, __FUNCTION__ + ", Collection already contains item"));
      }

      _buttons.append(button);
      classConnect(this, ClickedEvent, button, GUINaviButton::ClickedEvent);
    }

    /**
     * @brief Removes a button from the collection.
     * @param button The button to remove.
     * @throws An error if the item doesn't exist in the collection.
     */
    public void Remove(shared_ptr<GUINaviButton> button) {
      int count = Count();

      for (int i = 0; i < count; i++) {
        if (equalPtr(GetByIndex(i), button)) {
          RemoveByIndex(i);
          return;
        }
      }

      throw (makeError("", PRIO_SEVERE, ERR_PARAM, 0, __FUNCTION__ + ", Item doesn't exist in collection"));
    }

    /**
     * @brief Removes a button from the collection by index.
     * @param index The index of the button to remove.
     * @throws An error if the index is higher than the collection count.
     */
    public void RemoveByIndex(const int &index) {
      if (index >= Count()) {
        throw (makeError("", PRIO_SEVERE, ERR_PARAM, 0, __FUNCTION__ + ", Index is higher than collection count"));
      }

      _buttons.removeAt(index);
    }

    /**
     * @brief Sets the visibility of all buttons in the collection.
     * @param visible The visibility state to set.
     */
    public void SetVisible(const bool &visible){
      int count = Count();

      for(int i = 0; i < count; i++){
        _buttons.at(i).SetVisible(visible);
      }
    }

    /**
     * @brief Clears the collection, removing all buttons.
     */
    public void Clear() {
      _buttons.clear();
    }

    /**
     * @brief Sets all buttons in the collection to inactive.
     */
    public SetInactive() {
      int buttonCount = _buttons.count();
      for(int i = 0; i < buttonCount; i++){
        _buttons.at(i).SetActive(FALSE);
      }
    }

    //--------------------------------------------------------------------------------
    //@protected members
    //--------------------------------------------------------------------------------

    //--------------------------------------------------------------------------------
    //@private members
    //--------------------------------------------------------------------------------
    private vector<shared_ptr<GUINaviButton> > _buttons;
  };
