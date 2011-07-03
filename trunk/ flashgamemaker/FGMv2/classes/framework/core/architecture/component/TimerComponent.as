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
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.core.architecture.entity.*;
	import framework.core.system.ITimeManager;
	import framework.core.system.TimeManager;
	
	import utils.time.Time;
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
		
		public function TimerComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar();
			_initListener();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("timer");
		}
		//------ Init Listener ------------------------------------
		private function _initListener():void {
			_timer = new Timer(_timer_delay, _timer_count);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			_timer.start()
		}
		//------ Remove Listener ------------------------------------
		private function _removeListener():void {
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
		}
		//------ On Tick ------------------------------------
		private function _onTimer(evt:TimerEvent):void {
			//update("timer");
		}
		//------Stop ------------------------------------
		public function stop():void {
			_timer.stop();
		}
		//------ On Timer Complete ------------------------------------
		private function _onTimerComplete(evt:TimerEvent):void {
			trace("Timer Complete");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
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