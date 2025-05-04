// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author m.woegrath
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
class Timer
{
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------
#event TimerDone()
  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public Timer(const int &delaytime)
  {
    _delaytime = delaytime;
  }

  /**
    @brief Function to start timer in new thread
  */
  public void Start()
  {
    _threadId = startThread(this, TimerThread);
  }

  public void Stop()
  {
    if (_threadId >= 0)
    {
      stopThread(_threadId);
      _threadId = -1;
    }
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
  /**
    @brief Timer thread function
  */
  private void TimerThread()
  {
    while (1)
    {
      TimerDone();
      delay(_delaytime);
    }
  }

  private int _delaytime;
  private int _threadId = -1;
};
