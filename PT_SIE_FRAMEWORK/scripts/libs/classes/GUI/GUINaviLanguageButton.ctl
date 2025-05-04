// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author n.holzersoellner
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "classes/ContextMenu/ContextMenuCustom"
#uses "classes/GUI/GUINaviButton"


//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
class GUINaviLanguageButton : GUINaviButton
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public GUINaviLanguageButton(const shape &textRef, const shape &iconRef, const shape &frameSelector) : GUINaviButton(textRef, iconRef, frameSelector)
  {
  }

  public void Clicked()
  {
    int answer;
    shared_ptr<ContextMenuCustom> languageMenu = new ContextMenuCustom();
    languageMenu.Clear();

    dyn_string dsLangs;

  	for(int i=0;i<getNoOfLangs();i++)
  	{
      languageMenu.AddPushButton(getCatStr("trans",getLocale(i)), i+1, 1, "");
      dynAppend(dsLangs, getLocale(i));
  	}
  /*
    languageMenu.AddPushButton("Deutsch", DE, 1, "");
    languageMenu.AddPushButton("English", EN, 1, "");
    languageMenu.AddPushButton("Español", ES, 1, "");
    languageMenu.AddPushButton("Français", FR, 1, "");
    languageMenu.AddPushButton("Türkçe", TR, 1, "");
    languageMenu.AddPushButton("简体中文", CN, 1, "");*/
    answer = languageMenu.Open();
  // DebugN("llllllllllllllllang changed", answer, dsLangs[answer]);
    if (answer > 0)
    {
      changeLang(dsLangs[answer]);
    }
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
  private const int DE = 0;
  private const int EN = 1;
  private const int ES = 2;
  private const int FR = 3;
  private const int TR = 4;
  private const int CN = 5;
};
