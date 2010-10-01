/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://flashgamemakeras3.blogspot.com/
*   Group:        http://groups.google.com.au/group/flashgamemaker
*   Google Code:  http://code.google.com/p/flashgamemaker/downloads/list
*   Source Forge: https://sourceforge.net/projects/flashgamemaker/files/
*/

/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*  
*   Permission is granted to copy, distribute and/or modify this document
*   under the terms of the GNU Free Documentation License, Version 1.3
*   or any later version published by the Free Software Foundation;
*   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*   Under this licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import utils.loader.*;
	import utils.time.*;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	/**
	* Time Manager
	* @ purpose: Handle the time
	*/
	public class TimeManager extends LoaderDispatcher implements ITimeManager {

		private static var _instance:ITimeManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _timer:Timer = null;
		private var _delay:Number = 100;
		private var _beginTime:Number = 0;
		private var _currentTime:Number = 0;
		
		public function TimeManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use TimeManager.getInstance() instead of new.");
			}
			initVar();
			initListener();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():ITimeManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new TimeManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_beginTime = Time.GetTime();
			_delay = 100;
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
		}
		//------ On Tick ------------------------------------
		private function onTick(evt:TimerEvent):void {
			updateVirtualTime();
			updateRealTime()
			dispatchEvent(evt);
		}
		//------ Update Time ------------------------------------
		private function updateRealTime():Number {
			_currentTime = Time.GetTime();
			return _currentTime;
		}
		//------ Update Time ------------------------------------
		private function updateVirtualTime():Number {
			_currentTime = (Time.GetTime()-_beginTime);
			return _currentTime;
		}
		//------ Get Virtual Time ------------------------------------
		public function getVirtualTime():Object {
			return getTime(updateVirtualTime());
		}
		//------ Get Real Time ------------------------------------
		public function getRealTime():Object {
			return getTime(updateRealTime());
		}
		//------ Get Time ------------------------------------
		public function getTime(currentTime:Number):Object {
			var time:Object = {day:Time.GetDay(currentTime) ,hour:Time.GetHour(currentTime) ,min:Time.GetMin(currentTime) ,sec:Time.GetSec(currentTime)};
			return time;
		}
		//------- ToString -------------------------------
		 public  function ToString():void{
           
        }
	}
}