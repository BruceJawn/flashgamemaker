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
	
	import utils.time.*;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MouseInputComponent extends Component {
		private var _isListening:Boolean = false;
		
		private var _targetName:String;
		private var _target:Object;
		private var _type:String;
		private var _stageX:Number = 0;
		private var _stageY:Number = 0;
		private var _shiftKey:Boolean = false;
		private var _delta:Number = 0;
		private var _ctrlKey:Boolean = false;
		private var _buttonDown:Boolean = false;
		private var _longClick:Boolean = false;
		private var _longClickLatence:Number = 575;
		private var _timer:Number = 0;
		private var _interval:Number = 0;
		private var _mouseObject:Object;
		private var _mouseListeners:Array = new Array();
		
		public function MouseInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
			//initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			FlashGameMaker.clip.doubleClickEnabled = true;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			//FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(MouseEvent.CLICK, onClick);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "mouseInput") {
				super.actualizePropertyComponent($propertyName,$component, $param);
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
			var target:Component;
			if(_mouseObject.target is Component){
				target = _mouseObject.target;
			}else if (_mouseObject.target && _mouseObject.target.parent is Component){
				target = _mouseObject.target.parent;
			}
			if(target && target.propertyReferences["mouseInput"]){
				var param:Object = target.propertyReferences["mouseInput"];
				if(param.hasOwnProperty($callback)){
					param[$callback](_mouseObject);
				}
			}
		}
		//------ On Dispatch ------------------------------------
		private function dispatchMouseListeners($evt:String):void {
			for each (var object:Object in _mouseListeners){
				if($evt == "onMouseMove" && object.param.hasOwnProperty("onMouseMove")){
					object.param["onMouseMove"](_mouseObject);
				}else if($evt == "onMouseDown" && object.param.hasOwnProperty("onMouseDown")){
					object.param["onMouseDown"](_mouseObject);
				}else if($evt == "onMouseUp" && object.param.hasOwnProperty("onMouseUp")){
					object.param["onMouseUp"](_mouseObject);
				}else if($evt == "onMouseClick" && object.param.hasOwnProperty("onMouseClick")){
					object.param["onMouseClick"](_mouseObject);
				}else if($evt == "onMouseOver" && object.param.hasOwnProperty("onMouseOver")){
					object.param["onMouseOver"](_mouseObject);
				}else if($evt == "onMouseOut" && object.param.hasOwnProperty("onMouseOut")){
					object.param["onMouseOut"](_mouseObject);
				}
			}
		}
		//------ On MouseEvent ------------------------------------
		private function onMouseEvent($evt:MouseEvent, eventName:String):void {
			updateMouse($evt);
			dispatch(eventName);
			dispatchMouseListeners(eventName);
		}
		//------ On Click ------------------------------------
		private function onClick($evt:MouseEvent):void {
			onMouseEvent($evt, "onClick");
		}
		//------ On Double Click ------------------------------------
		private function onDoubleClick($evt:MouseEvent):void {
			onMouseEvent($evt, "onDoubleClick");
		}
		//------ On Mouse Down ------------------------------------
		private function onMouseDown($evt:MouseEvent):void {
			initTimer();
			onMouseEvent($evt, "onMouseDown");
		}
		//------ On Mouse Up ------------------------------------
		private function onMouseUp($evt:MouseEvent):void {
			updateTimer();
			checkLongClick();
			onMouseEvent($evt, "onMouseUp");
		}
		//------ On Mouse Move ------------------------------------
		private function onMouseMove($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseMove");
		}
		//------ On Mouse Over ------------------------------------
		private function onMouseOver($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseOver");
		}
		//------ On Mouse Out ------------------------------------
		private function onMouseOut($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseOut");
		}
		//------ On Mouse Wheel ------------------------------------
		private function onMouseWheel($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseWheel");
		}
		//------ Update Mouse ------------------------------------
		private function updateMouse($evt:MouseEvent):void {
			_targetName= $evt.target.name;
			_target = $evt.target;
			_type = $evt.type;
			_stageX = $evt.stageX;
			_stageY = $evt.stageY;
			_buttonDown = $evt.buttonDown;
			_shiftKey = $evt.shiftKey;
			_ctrlKey = $evt.ctrlKey;
			_delta = $evt.delta;
			_mouseObject = getMouse();
		}
		//------ Get Mouse ------------------------------------
		public function getMouse():Object {
			var mouse:Object=new Object();
			mouse.type = _type;
			mouse.targetName = _targetName;
			mouse.target = _target;
			mouse.stageX = _stageX;
			mouse.stageY = _stageY;
			mouse.buttonDown = _buttonDown;
			mouse.longClick = _longClick;
			mouse.shiftKey = _shiftKey;
			mouse.ctrlKey = _ctrlKey;
			mouse.delta = _delta;
			return mouse;
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			_timer = getTime();
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