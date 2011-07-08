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
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import framework.core.architecture.entity.IEntity;
	
	/**
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TimerComponent extends Component {
		
		private var _currentCount:Number = 0;
		private var _counterMax:Number = 10;
		private var _timeline:Dictionary;
		private var _isRunning:Boolean = false;
		
		public function TimerComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar($prop:Object):void {
			_timeline = new Dictionary();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("timer");
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			addEventListener(Event.ENTER_FRAME, onTimer);
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			removeEventListener(Event.ENTER_FRAME, onTimer);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeProperty($propertyName:String):void {
			var components:Vector.<Object> = _properties[$propertyName];
			if ($propertyName == "timer" && components) {
				for each (var object:Object in components){
					actualizePropertyComponent($propertyName, object.component);
				}
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "timer") {
				super.actualizePropertyComponent($propertyName,$component, $param);
				addToTimeline($component, $param);
			}
		}
		//------ Add To Timeline  ------------------------------------
		private function addToTimeline($component:Component, $param:Object):void {
			if(!_isRunning){
				start();
			}
			if (!$param || !($param.delay && $param.callback)) {
				throw new Error("A delay and callback function are required as parameters to be registered by TimerComponent!!");
			}
			if($param.delay==1){
				throw new Error("A delay 1 will result in infinite loop!!");
			}
			if($param.delay > _counterMax){
				_counterMax = $param.delay;
			}
			var minFactor:Number = minFactor($param.delay);
			if(!_timeline[minFactor]){
				_timeline[minFactor]= new Dictionary();
			}
			if(!_timeline[minFactor][$param.delay]){
				_timeline[minFactor][$param.delay]= [$param.delay];
			}
			_timeline[minFactor][$param.delay].push({component:$component,callback:$param.callback});
		}
		//------ On Tick ------------------------------------
		private function onTimer($evt:Event):void {
			_currentCount++;
			if(_currentCount>1){
				var minFactor:Number = minFactor(_currentCount);
				if(_timeline[minFactor]){
					for each (var array:Array in _timeline[minFactor]){
						if(array[0]<=_currentCount && _currentCount%array[0]==0){
							for each (var object:Object in array){
								if(object.hasOwnProperty("callback")){
									object.callback();
								}
							}
						}
					}
				}
				if(_currentCount>=_counterMax){
					_currentCount=0;
				}
			}
		}
		//------ Min Factor ------------------------------------
		private function minFactor(num:Number):Number {
			var i:Number = 2;
			while (num%i !=0){
				i++
			}
			return i;
		}
		//------Stop ------------------------------------
		public function start():void {
			if(!_isRunning){
				initListener();
				_isRunning = true;
			}
		}
		//------Stop ------------------------------------
		public function stop():void {
			if(!_isRunning){
				removeListener();
				_isRunning = false;
			}
		}
		//------Reset ------------------------------------
		public function reset():void {
			stop()
			_currentCount = 0;
			start();
		}
		//------ On Timer Complete ------------------------------------
		private function onTimerComplete():void {
			trace("Timer Complete");
		}
	}
}