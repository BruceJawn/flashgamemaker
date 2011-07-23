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
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import framework.core.architecture.entity.*;
	
	import utils.mouse.MousePad;
	import utils.time.*;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MouseInputComponent extends Component {
		private var _isListening:Boolean = false;
		
		private var _mousePad:MousePad;
		private var _doubleClick:Boolean = false;
		private var _longClick:Boolean = false;
		private var _longClickLatence:Number = 575;
		private var _timer:Number = 0;
		private var _interval:Number = 0;
		private var _mouseListeners:Array = new Array();
		
		public function MouseInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_mousePad = new MousePad;
			FlashGameMaker.clip.doubleClickEnabled = true;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(MouseEvent.CLICK, onMouseEvent, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent, false, 0, true);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "mouseInput") {
				isListeningMouse($component, $param);
				if(!_isListening){
					_isListening=true;
					initListener();
				}
			}
		}
		//------ On Dispatch ------------------------------------
		private function isListeningMouse($component:Component, $param:Object):void {
			var object:Object = {component:$component,param:$param};
			if($param.isListeningMouse && _mouseListeners.indexOf(object)==-1){
				_mouseListeners.push(object);
			}
		}
		//------ On Dispatch ------------------------------------
		private function dispatch($callback:String):void {
			var components:Vector.<Object> = _properties["mouseInput"];
			for each (var object:Object in components){
				if(object.param.hasOwnProperty($callback)){
					object.param[$callback](_mousePad);
				}
			}
		}
		//------ On MouseEvent ------------------------------------
		private function onMouseEvent($evt:MouseEvent):void {
			updateMouse($evt);
			dispatch("onMouseFire");
		}
		//------ On Mouse Down ------------------------------------
		private function onMouseDown($evt:MouseEvent):void {
			initTimer();
			onMouseEvent($evt);
		}
		//------ On Mouse Up ------------------------------------
		private function onMouseUp($evt:MouseEvent):void {
			updateTimer();
			checkLongClick();
			onMouseEvent($evt);
		}
		
		//------ Update Mouse ------------------------------------
		private function updateMouse($evt:MouseEvent):void {
			_mousePad.mouseEvent = $evt;
			_mousePad.clickDuration = _interval;
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			_timer = getTime();
			_interval = -1;
		}
		//------ Update Timer ------------------------------------
		private function checkTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Update Timer ------------------------------------
		private function updateTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Check Long Click ------------------------------------
		private function checkLongClick():void {
			if(_interval>_longClickLatence){
				_longClick = true;
			}else{
				_longClick = false;
			}
		}
		//---- Get Time ------------------------------------------------
		private function getTime():Number{
			return Time.GetTime();
		}	
		
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}