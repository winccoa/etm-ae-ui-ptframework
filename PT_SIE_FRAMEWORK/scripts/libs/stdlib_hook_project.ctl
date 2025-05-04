/*
@author Andreas Gruber
Displays an icon on a certain infoArea
@param InfoAreaNr ... nr of the infoArea, "infoArea" + InfoAreaNr must exist in the symbol somewhere, normally by using info_area.pnl as reference
@param dpesForInfoArea ... mapping with DPE names and values
*///C:/Users/z004u6jf/OneDrive - Siemens AG/PT_SIE_FRAMEWORK/scripts/libs/classes/GUI\faceplate.ctl
#uses "classes/GUI/faceplate"
void hook_displayInfoAreaIcon(int InfoAreaNr, mapping dpesForInfoArea)
{
  int iconId;
  string sIcon, sColor, sDpe;
  dyn_dyn_anytype dda;

  if (DebugInfos)   DebugTN("InfoArea #", InfoAreaNr);

  sIcon = stdlib_getInfoAreaIconFile(InfoAreaNr, dpesForInfoArea); // get the Icon for the infoArea#

  if (dbInfoAreaUseDefault[InfoAreaNr]==true)  // normally just display the icon or remove a displayed one
  {
    setValue("infoArea" + InfoAreaNr, "fill", (sIcon=="")?"[solid]":"[pattern,[fit,any," + sIcon + "]]");
  }
  else
  {
    switch (InfoAreaNr)  // if not default, maybe something else maybe should be done
    {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5: setValue("infoArea" + InfoAreaNr, "fill", (sIcon=="")?"[solid]":"[pattern,[fit,any," + sIcon + "]]");
              break;
      case 6: if (mappinglen(dpesForInfoArea)>0)  // dont show icon for alerts, just set the foreCol to the act_state_color
              {
                //setValue("infoArea" + InfoAreaNr, "foreCol", (mappingGetValue(dpesForInfoArea, 1)=="")?"_Transparent":mappingGetValue(dpesForInfoArea, 1));
                sDpe = mappingGetKey(dpesForInfoArea, 1);
                sDpe = dpSubStr(sDpe, DPSUB_SYS_DP_EL);

                if ( dpSubStr(sDpe, DPSUB_SYS) == getSystemName() )
                  dpQuery("SELECT ALERT '_alert_hdl.._alert_color', '_alert_hdl.._last' FROM '"+sDpe+"' WHERE '_alert_hdl.._last' == 1", dda);
                else
                  dpQuery("SELECT ALERT '_alert_hdl.._alert_color', '_alert_hdl.._last' FROM '"+sDpe+"' REMOTE '" + dpSubStr(sDpe, DPSUB_SYS) + "' WHERE '_alert_hdl.._last' == 1", dda);

                if ( dynlen(dda) < 2 )
                  setValue("infoArea" + InfoAreaNr, "foreCol", "_Transparent");
                else
                  setValue("infoArea" + InfoAreaNr, "foreCol", dda[dynlen(dda)][3]);
              }
              break;
      default: break;
    }
  }
}


/*
@author Michael Schmit
function which gives the window title used in the faceplate window
@param sDp    ... datapoint
@param &name  ... Name of the Faceplates
@param panels ... Name of the panels
*/
hook_namingFaceplateTabs(string dp, dyn_langString &name, dyn_string panels)
{
  dyn_string dsTmp;
  langString entry;
  string text;
  int nrOfLangs = getNoOfLangs();

  if (DebugInfos) DebugN("nrOfLangs",nrOfLangs, dynlen(panels));
  //read out the Faceplatetabnames from the messagecatalog
  for (int i=1; i<=dynlen(panels); i++)
  {
    text = panels[i];
    strreplace(text, ".pnl", "");
    strreplace(text, ".xml", "");
    dsTmp = makeDynString();
    for (int j=1; j<=nrOfLangs; j++)
    {
      dsTmp[j] = getCatStr(getLibNameFromDP(dp), text, j-1);
      dyn_errClass de;
      de=getLastError();
      if(dynlen(de)!=0)
      {
        dsTmp[j] = getCatStr("stdlib", text, j-1);
        de=getLastError();
        if(dynlen(de)!=0)
        {
          dsTmp[j]=text;
          DebugN("error!, faceplate-tabname not found for",text, dp);
        }
      }
    }
    entry = dsTmp;
    name[i] = entry;
  }
}

/*
@author Andreas Gruber
Function returns the text used as tooltip on a symbol
@param dp ... Datapoint
@return (langString) ... Tooltip Text
*/
langString hook_objectTooltip(string dp)
{
  return dpGetDescription(dp);
}

/*
@author Markus Trummer
function which answers has a user authoization for a DPE
@return 0 ... user has no authorization
        1 ... user has authorization
       <0 ... function is not implemented
@param sDpe ... datapoint
@param sUserName ... user for which the function checks the authorization
*/
int hook_hasUserAuthorization(string sDpe, string sUserName)//attention, this function has to exist!
{
  //this function has to return :
  // 0 if user has no authorization
  // 1 if user has authorization
  // <0 if default implementation should be used (chech authorization form _auth config)

  return -9;
}

/*
@author Andreas Gruber
opens the Faceplate of a symbol
@param dp ... Datapoint
*/
void hook_openFaceplate(string dp)
{
  string sLibFct = builtHookName(dp, "hook_libLicenseAvailable");

  if ( !isFunctionDefined(sLibFct) )
  {
    throwError(makeError("", PRIO_WARNING, ERR_PARAM, 72, "'"+sLibFct+"'"));
    return;
  }

  if(!hook_libLicenseAvailable(dp))
  {
    stdlib_openPanelInvalidLicense(FALSE);
    return;
  }

  dyn_int diSize;
  string sPanel;
  dyn_string dsParameter;
  int iX, iY;

  sPanel="objects_parts/faceplates/framework/faceplate_main.pnl";
  dsParameter=makeDynString("$DP:"+dp);

  // add Dollar Parameter with global ref name of the calling object to the faceplate
  if ((string)TEXT_PARENT_REF_NAME.text!="")
    dynAppend(dsParameter, "$CALLING_OBJECT_REF_PATH:" + (string)TEXT_PARENT_REF_NAME.text);

  getCursorPosition(iX, iY, true);

  if (globalExists("FACEPLATELIB_LOADED")) //for PT SIE template
  {
 //   execScript("#uses \"classes/GUI/faceplate\"\nmain(){}");
    string sParams;


    for (int i = 1; i <= dynlen(dsParameter); i++)
    {
      sParams += "§" + dsParameter[i];
    }
    Faceplate::triggerOpenFaceplate(dp+"§"+dp+"§"+ sPanel +"§"+dpTypeName(dp)+ sParams + "§$STDLIB:1");
//     callFunction("Faceplate::triggerOpenFaceplate", dp+"§"+dp+"§"+ sPanel +"§"+dpTypeName(dp)+ sParams + "§STDLIB");
  }
  else if (gFaceplateModal)
  {
    ChildPanelOnRelativModal(sPanel, hook_faceplateWindowTitle(dp), dsParameter, 0, 0);
  }
  else
  {
    // Do not draw the faceplate at the right screen edge, keep it on one screen
    // LIMITATIONS:
    // 1) displays have to be the same size
    // 2) displays have to be horizontally aligned
    // 3) faceplates will be aligned only on the X coordinate

    int margin = 737; // the x size of the opened faceplate
    int iXPos;
    int iXPosRel;
    int iYPosRel;
    int iXScreenSize;
    int tmp;

    getCursorPosition(iXPos, tmp, true);
    getCursorPosition(iXPosRel, iYPosRel);
    getScreenSize(iXScreenSize, tmp);

    int iXPosRelToWindow = iXPosRel;
    int iOneScreenSizeX = iXScreenSize / getScreenCount();
    if (margin > iOneScreenSizeX) // larger margin than screen size
    {
      margin = iOneScreenSizeX;
    }

    int iXPosLocal = iXPos;
    if (iXPosLocal >= 0)
    {
      while (iXPosLocal > iOneScreenSizeX)
      {
        iXPosLocal -= iOneScreenSizeX;
      }
    }
    else
    {
      while (iXPosLocal < 0)
      {
        iXPosLocal += iOneScreenSizeX;
      }
    }

    int fromScreenEdge = iOneScreenSizeX - iXPosLocal;
    float zoomFactor;
    getZoomFactor(zoomFactor, myModuleName());

    if ( fromScreenEdge < margin )  // on the right margin
    {
      int iNewPos = iXPosRel + fromScreenEdge - margin;
      ChildPanelOn(sPanel, hook_faceplateWindowTitle(dp), dsParameter, iNewPos/zoomFactor, (iYPosRel + 10)/zoomFactor);
    }
    else
    {
      ChildPanelOn(sPanel, hook_faceplateWindowTitle(dp), dsParameter, iXPosRelToWindow/zoomFactor, (iYPosRel + 10)/zoomFactor);
    }
  }
}

/*
@author Michael Schmit
function which creates the PopUpMenu
@return functions for the pop up menu
@param sDp ... datapoint
@param &dsMenueEntry ... MenueEntry
@param &dsFunction ... Functions
*/
hook_projectFillPopUpMenu(string sDp, dyn_string &dsMenueEntry, dyn_string &dsFunction)
{
  string sDpMonitor, sPara, sHelp, sAlarm, sEvents, sTrend;

  sDpMonitor = getCatStr("stdlib","DpMonitor");
  sPara      = getCatStr("stdlib","Para"     );
  sHelp      = getCatStr("stdlib","Help"     );
  sAlarm     = getCatStr("stdlib","Alarm"    );
  sEvents    = getCatStr("stdlib","Events"   );
  sTrend     = getCatStr("stdlib","Trend"    );

  dsMenueEntry= makeDynString("PUSH_BUTTON", sPara          + ", "+PARA+"     ,  " + ((isModeExtended() && getUserPermission(32))?"1":"0"),
                              "PUSH_BUTTON", sAlarm         + ", "+ALARMS+"   ,  " + TRUE,
                              "PUSH_BUTTON", sEvents        + ", "+EVENTS+ "  ,  " + TRUE,
                              "PUSH_BUTTON", sDpMonitor     + ", "+DPMONITOR+",  " + TRUE,
                              "PUSH_BUTTON", sTrend         + ", "+TREND+"    ,  " + TRUE,
                              "PUSH_BUTTON", sHelp          + ", "+HELP+"     ,  " + TRUE
                              );


 dsFunction=makeDynString("OpenDpMonitor(\""+sDp+"\");","OpenPara(\""+sDp+"\");","OpenHelp(\""+sDp+"\");","OpenAlerts(\""+sDp+"\");","OpenEvents(\""+sDp+"\");","OpenTrend(\""+sDp+"\");");
}

/*
@author Markus Trummer
function for adding and removing faceplate tabs before opening the faceplate
@param sDp ... datapoint for which the faceplate will be opened
@param &ds_panels ... panels which will be opend
@param &ds_pfad ... paths of the panels
*/
void hook_faceplateTabsToOpen (string sDp, dyn_string &ds_panels, dyn_string &ds_pfad)
{
}

/*
@author Andreas Gruber
function for checking visibility of the elementary symbol, will be connected by AND with the rule result
@param sDpe ... datapoint element for which the visibility will be checked
@param sUser ... current user, is used by PocketClient
@return (bool) ... visible or not
*/
bool hook_visibleElementarySymbol (string sDpe, string sUser="")
{
//  if(sUser=="")
//    sUser = getUserName();

  //return hook_hasDpeAnActiveAdress(sDpe);
  return true;
}

/*
@author Andreas Gruber
function for checking enabled of the elementary symbol, will be connected by AND with the rule result
@param sDpe ... datapoint element for which enabled will be checked
@param sUser ... current user, is used by PocketClient
@return (bool) ... visible or not
*/
bool hook_enableElementarySymbol (string sDpe, string sUser="")
{
  //use default permission check
  if(sUser=="")
    sUser = getUserName();
  return hasUserAuthorization(sDpe, sUser);

  //if you don't want to use permission check
  //return true;
}

/*
@author Andreas Gruber
function for checking highlight of the elementary symbol,  will be connected by OR with the rule result
@param sDpe ... datapoint element for which highlight will be checked
@return (bool) ... highlight or not
*/
bool hook_highlightElementarySymbol (string sDpe, string sUser="")
{
//  if(sUser=="")
//    sUser = getUserName();
  return false;
}


/*
@author Markus Trummer
function which gives the headline used in the faceplates
@return the headline text
@param sDp ... datapoint
*/
langString hook_faceplateHeadline(string sDp)
{
  langString lsHeadline = hook_getFaceplateHeadline(sDp);
  if ( lsHeadline == "" ) lsHeadline = dpGetDescription(sDp);
  return lsHeadline;
}

/*
@author Markus Trummer
function which gives the window title used in the faceplate window
@return the window title text
@param sDp ... datapoint
*/
langString hook_faceplateWindowTitle(string sDp)
{
  langString lsWindowTitle = hook_getFaceplateWindowTitle(sDp);
  if ( lsWindowTitle == "" ) lsWindowTitle = dpGetAlias(sDp);
  if ( lsWindowTitle == "" ) lsWindowTitle = dpSubStr(sDp, DPSUB_SYS_DP);
  return lsWindowTitle;
}
