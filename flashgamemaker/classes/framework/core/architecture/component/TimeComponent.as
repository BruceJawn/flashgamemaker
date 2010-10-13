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

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import utils.time.Time;
	import framework.core.system.TimeManager;
	import framework.core.system.ITimeManager;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	/**
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TimeComponent extends GraphicComponent {
		private var _timeManager:ITimeManager = null;
		private var _virtualTime:TextField=null;
		private var _realTime:TextField=null;
		private var _time_virtualTime:Object = null;
		private var _time_realTime:Object = null;
		
		public function TimeComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_time_virtualTime = new Object();
			_time_realTime = new Object();
			
			_virtualTime = new TextField();
			_virtualTime.width=200;
			_realTime = new TextField();
			_realTime.width=_virtualTime.width;
			addChild(_virtualTime);			
			addChild(_realTime);			
			_realTime.y+=15;
			
			_timeManager = TimeManager.getInstance();
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			var dispatcher:EventDispatcher = _timeManager.getDispatcher();
			dispatcher.addEventListener(TimerEvent.TIMER, onTick);
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			var dispatcher:EventDispatcher = _timeManager.getDispatcher();
			dispatcher.removeEventListener(TimerEvent.TIMER, onTick);
		}
		//------ On Tick ------------------------------------
		private function onTick(evt:TimerEvent):void {
			getTime();
			updateText();
		}
		//------ Update Text ------------------------------------
		private function updateText():void {
			var virtualTime:String="Day: "+_time_virtualTime.day
			virtualTime +=" , Time: "+_time_virtualTime.hour+":"+_time_virtualTime.min+":"+_time_virtualTime.sec;
			_virtualTime.text = virtualTime;
			var realTime:String="Day: "+_time_realTime.day
			realTime +=" , Time: "+_time_realTime.hour+":"+_time_realTime.min+":"+_time_realTime.sec;
			_realTime.text = realTime;
		}
		//------ Get Time ------------------------------------
		public function getTime():void {
			_time_virtualTime = _timeManager.getVirtualTime();
			_time_realTime = _timeManager.getRealTime();
		}
	}
}