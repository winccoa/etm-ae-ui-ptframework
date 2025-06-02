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
#event StartTimer()
#event StopTimer()

  //------------------------------------------------------------------------------
  /** The Default Constructor.
  */
  public Timer(const int &delaytime)
  {
    _delaytime = delaytime;
    classConnect(this, StartTimerCB, this, StartTimer);
    classConnect(this, StopTimerCB, this, StopTimer);
  }

  /**
    @brief Function to start timer in new thread.
  */
  public void Start()
  {
    StartTimer();
  }

  /**
    @brief Function to stop timer thread.
  */
  public void Stop()
  {
    StopTimer();
  }

//--------------------------------------------------------------------------------
//@protected members
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
  /**
    @brief Timer thread function.
  */
  private void TimerThread()
  {
    while (1)
    {
      TimerDone();
      delay(_delaytime);
    }
  }

  /**
    @brief Callback function to start timer thread.
  */
  private void StartTimerCB() synchronized(_threadId)
  {
    if (_threadId < 0)
    {
      _threadId = startThread(this, TimerThread);
    }
  }

  /**
    @brief Callback function to stop timer thread.
  */
  private void StopTimerCB() synchronized(_threadId)
  {
    if (_threadId >= 0)
    {
      stopThread(_threadId);
    }

    _threadId = -1;
  }
 
  private int _delaytime; //!< The delay time in seconds.
  private int _threadId = -1; //!< The thread ID of the timer thread.
};
