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
	public class TimerComponent extends Component {
		
		private var _timer:Timer = null;
		private var _timer_delay:Number = 30;
		private var _timer_count:Number = 0;
		
		public function TimerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("timer", _componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_timer = new Timer(_timer_delay, _timer_count);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start()
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		//------ On Tick ------------------------------------
		private function onTimer(evt:TimerEvent):void {
			update("timer");
		}
		//------ On Timer Complete ------------------------------------
		private function onTimerComplete(evt:TimerEvent):void {
			trace("Timer Complete");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			component._timer_count+= _timer_delay;
			component.actualizeComponent(componentName,componentOwner,component);
			if(component._timer_on==false){
				component._timer_on=true;
			}
			if(component._timer_count>=component._timer_delay){
				component._timer_count=0;
			}
		}
	}
}