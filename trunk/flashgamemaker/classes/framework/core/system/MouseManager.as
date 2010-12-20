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
*Under this licence you are free to copy, adapt and distrubute the work. 
*You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import utils.loader.*;
	import utils.time.*;
	
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	* Mouse Manager
	* @ purpose: Handle the mouse event
	*/
	public class MouseManager extends LoaderDispatcher implements IMouseManager {

		private static var _instance:IMouseManager=null;
		private static var _allowInstanciation:Boolean=false;
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
		
		public function MouseManager() {
			if (! _allowInstanciation || _instance!=null) {
				throw new Error("Error: Instantiation failed: Use MouseManager.getInstance() instead of new.");
			}
			initVar();
			initListener();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IMouseManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new MouseManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			FlashGameMaker.STAGE.doubleClickEnabled = true;
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.STAGE.addEventListener(MouseEvent.CLICK, onClick);
			FlashGameMaker.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.STAGE.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.STAGE.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseMove);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.STAGE.removeEventListener(MouseEvent.CLICK, onClick);
			FlashGameMaker.STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.STAGE.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.STAGE.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseMove);
		}
		//------ On Click ------------------------------------
		private function onClick(evt:MouseEvent):void {
			updateMouse(evt);
			dispatchEvent(evt);
		}
		//------ On Double Click ------------------------------------
		private function onDoubleClick(evt:MouseEvent):void {
			updateMouse(evt);
			dispatchEvent(evt);
		}
		//------ On Mouse Down ------------------------------------
		private function onMouseDown(evt:MouseEvent):void {
			initTimer();
			updateMouse(evt);
			dispatchEvent(evt);
		}
		//------ On Mouse Up ------------------------------------
		private function onMouseUp(evt:MouseEvent):void {
			updateTimer();
			updateMouse(evt);
			checkLongClick();
			dispatchEvent(evt);
		}
		//------ On Mouse Move ------------------------------------
		private function onMouseMove(evt:MouseEvent):void {
			updateMouse(evt);
			dispatchEvent(evt);
		}
		//------ On Mouse Wheel ------------------------------------
		private function onMouseWheel(evt:MouseEvent):void {
			updateMouse(evt);
			dispatchEvent(evt);
		}
		//------ Update Mouse ------------------------------------
		private function updateMouse(evt:MouseEvent):void {
			_targetName= evt.target.name;
			_target = evt.target;
			_type = evt.type;
			_stageX = evt.stageX;
			_stageY = evt.stageY;
			_buttonDown = evt.buttonDown;
			_shiftKey = evt.shiftKey;
			_ctrlKey = evt.ctrlKey;
			_delta = evt.delta;
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
		//------ Hide Cursor ------------------------------------
		public function hideCursor():void {
			Mouse.hide();
		}
		//------ Show Cursor ------------------------------------
		public function showCursor():void {
			Mouse.show();
		}
		//------- To String  -------------------------------
		public function ToString():void{
            trace(_targetName, _target, _longClick);
        }
	}
}