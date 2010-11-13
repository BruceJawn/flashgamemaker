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
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;

	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.ui.Keyboard;
	/**
	* Keyboard Manager
	* @ purpose: Handle the keyboard event
	*/
	public class KeyboardManager extends LoaderDispatcher implements IKeyboardManager {

		private static var _instance:IKeyboardManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _ressourceManager:IRessourceManager=null;
		private var _xmlName:String=null;
		private var _xmlConfig:XMLList=null;
		private var _keys:Dictionary;
		private var _keyCode:Number=0;
		private var _keyStatut:String="UP";//Key is UP or DOWN
		private var _charCode:String;
		private var _prevKeyCode:Number=0;// Previous keys down
		private var _doubleClick:Boolean=false;
		private var _doubleClickLatence:Number=175;
		private var _longClick:Boolean=false;
		private var _longClickLatence:Number=575;
		private var _ctrlKey:Boolean=false;
		private var _shiftKey:Boolean=false;
		private var _timer:Number=0;
		private var _interval:Number=0;

		// INPUTS
		private var _up:Object;
		private var _down:Object;
		private var _left:Object;
		private var _right:Object;
		private var _fire1:Object;
		private var _fire2:Object;
		private var _fire3:Object;
		private var _fire4:Object;
		private var _inputs:Array;

		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		private var _upLeft:Object;
		private var _downLeft:Object;
		private var _upRight:Object;
		private var _downRight:Object;
		private var _anyDirection:Object;
		private var _multiInputs:Array;

		// THE "STICK"
		private var _x:Number=0;
		private var _y:Number=0;
		private var _targetX:Number=0;
		private var _targetY:Number=0;
		private var _angle:Number=0;
		private var _rotation:Number=0;
		private var _magnitude:Number=0;

		public function KeyboardManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use KeyboardManager.getInstance() instead of new.");
			}
			initVar();
			initListener();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IKeyboardManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new KeyboardManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_keys = new Dictionary();
			_keys[39]="RIGHT";
			_keys[37]="LEFT";
			_keys[38]="UP";
			_keys[40]="DOWN";
			initGamePad();
		}
		//------ Init Game Pad ------------------------------------
		private function initGamePad():void {
			_inputs=[_up,_down,_left,_right,_fire1,_fire2,_fire3,_fire4];
			_up=createGamepadInput();
			_down=createGamepadInput();
			_left=createGamepadInput();
			_right=createGamepadInput();
			_fire1=createGamepadInput();
			_fire2=createGamepadInput();
			_fire3=createGamepadInput();
			_fire4=createGamepadInput();

			_upLeft =  createGamepadMultiInput([_up, _left], false);
			_upRight =  createGamepadMultiInput([_up, _right], false);
			_downLeft =  createGamepadMultiInput([_down, _left], false);
			_downRight =  createGamepadMultiInput([_down, _right], false);
			_anyDirection =  createGamepadMultiInput([_up, _down, _left, _right], true);
			_multiInputs = [_upLeft, _upRight, _downLeft, _downRight, _anyDirection];

		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadInput():Object {
			var gamePadInput:Object={isDown:false, isPressed:false,isReleased:false,downTicks:-1,upTicks:-1,mappedKeys:new Array};
			return gamePadInput;
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadMultiInput(inputs:Array, isOr:Boolean):Object {
			var gamePadMultiInput:Object={isDown:false, isPressed:false,isReleased:false,downTicks:-1,upTicks:-1,isOr:isOr, inputs:inputs};
			return gamePadMultiInput;
		}
		//------ On Key Down ------------------------------------
		private function onKeyDown(event:KeyboardEvent):void{
			for each (var gamepadInput:Object in _inputs){
				keyDown(gamepadInput,event.keyCode);
			}
			updateState();
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp(event:KeyboardEvent):void{
			for each (var gamepadInput:Object in _inputs){
				keyUp(gamepadInput,event.keyCode);
			}
			updateState();
		}
		//------ On Key Down ------------------------------------
		private function keyDown(gamepadInput:Object,keyCode:int):void{
			if (gamepadInput.mappedKeys.indexOf(keyCode) > -1){ 
				gamepadInput.isDown = true;
			}
		}
		//------ On Key Up ------------------------------------
		private function keyUp(gamepadInput:Object,keyCode:int):void{
			if (gamepadInput.mappedKeys.indexOf(keyCode) > -1){
				gamepadInput.isDown = false;
			}
		}
		//------ Update State ------------------------------------
		private function updateState():void{
			for each (var gamepadMultiInput:Object in _multiInputs){
				update(gamepadMultiInput);
			}
			if (_up.isDown){
				_targetY = -1;
			}else if (_down.isDown){
				_targetY = 1;
			}else{
				_targetY = 0;
			}
			if (_left.isDown){
				_targetX = -1;
			}else if (_right.isDown){
				_targetX = 1;
			}else{
				_targetX = 0;
			}
			/*var _targetAngle:Number = Math.atan2(_targetX, _targetY);
			if (_isCircle && _anyDirection.isDown){
				_targetX = Math.sin(_targetAngle);
				_targetY = Math.cos(_targetAngle);
			}*/
		}
		//------ Update ------------------------------------
		public function update(gamepadMultiInput:Object):void{
			if (gamepadMultiInput.isOr){
				gamepadMultiInput.isDown = false;
				for each (var gamepadInput:Object in _inputs){
					if (gamepadInput.isDown){
						gamepadMultiInput.isDown = true;
						break;
					}
				}
			}else{
				gamepadMultiInput.isDown = true;
				for each (gamepadInput in gamepadMultiInput.inputs){
					if (!gamepadInput.isDown){
						gamepadMultiInput.isDown = false;
						break;
					}
				}
			}
			if (gamepadMultiInput.isDown){
				gamepadMultiInput.isPressed = gamepadMultiInput.downTicks == -1;
				gamepadMultiInput.isReleased = false;
				gamepadMultiInput.downTicks++;
				gamepadMultiInput.upTicks = -1;
			}else{
				gamepadMultiInput.isReleased = gamepadMultiInput.upTicks == -1;
				gamepadMultiInput.isPressed = false;
				gamepadMultiInput.upTicks++;
				gamepadMultiInput.downTicks = -1;
			}
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.STAGE.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		/*//------ On Key Down ------------------------------------
		private function onKeyDown(evt:KeyboardEvent):void {
			//if (_keyStatut=="UP"||_keyCode!=evt.keyCode) {
			_keyStatut="DOWN";
			initTimer();
			updateKey(evt);
			checkDoubleClick();
			dispatchEvent(evt);
			//}
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp(evt:KeyboardEvent):void {
			_keyStatut="UP";
			updateTimer();
			checkLongClick();
			dispatchEvent(evt);
		}*/
		//------ Update Key ------------------------------------
		private function updateKey(evt:KeyboardEvent):void {
			_prevKeyCode=_keyCode;
			_keyCode=evt.keyCode;
			_shiftKey=evt.shiftKey;
			_ctrlKey=evt.ctrlKey;
			_charCode=String.fromCharCode(evt.charCode).toUpperCase();
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			var interval:Number=getTime()-_timer;
			if (_timer==0||interval>_longClickLatence) {
				_timer=getTime();
				_interval=0;
			} else {
				_interval=getTime()-_timer;
				_timer=0;
			}
		}
		//------ Update Timer ------------------------------------
		private function updateTimer():void {
			_interval=getTime()-_timer;
		}
		//------ Check Double Click ------------------------------------
		private function checkDoubleClick():void {
			if (_interval!=0&&_interval<_doubleClickLatence&&_prevKeyCode==_keyCode) {
				_doubleClick=true;
			} else {
				_doubleClick=false;
			}
		}
		//------ Check Long Click ------------------------------------
		private function checkLongClick():void {
			if (_interval>_longClickLatence) {
				_longClick=true;
			} else {
				_longClick=false;
			}
		}
		//------ Set Keys From Path ------------------------------------
		public function setKeysFromPath(path:String, name:String):void {
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlName=name;
			_ressourceManager.loadXml(path, name);
		}
		//------ On Xml Loading Successful ------------------------------------
		private function onXmlLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			if (_xmlName!=null) {
				var xml:XML=_ressourceManager.getXml(_xmlName);
				setKeysFromXml(xml);
			}
		}
		//------ Set Keys From Xml ------------------------------------
		public function setKeysFromXml(xml:XML):void {
			_xmlConfig=xml.children();
			for each (var xmlChild:XML in _xmlConfig) {
				var keyName:String=xmlChild.name();
				var keyCode:Number=getKeyCode(xmlChild);
				_keys[keyCode]=keyName;
			}
		}
		//------ Set Key ------------------------------------
		public function setKey(keyCode:Number,keyName:String):void {
			_keys[keyCode]=keyName;
		}
		//------ Set Key From Char Code------------------------------------
		public function setKeyFromCharCode(charCode:String,keyName:String):void {
			var keyCode:Number=getKeyCode(charCode);
			_keys[keyCode]=keyName;
		}
		//------ Get Key Code ------------------------------------
		private function getKeyCode(charCode:String):Number {
			var keyCode:Number=charCode.charCodeAt(0);
			return keyCode;
		}
		//---- Get Time ------------------------------------------------
		private function getTime():Number {
			return Time.GetTime();
		}
		//------ Get Key ------------------------------------
		public function getKey():Object {
			var key:Object=new Object();
			key.keyCode=_keyCode;
			key.charCode=_charCode;
			key.keyStatut=_keyStatut;
			key.doubleClick=_doubleClick;
			key.longClick=_longClick;
			key.shiftKey=_shiftKey;
			key.ctrlKey=_ctrlKey;
			key.keyTouch=_keys[_keyCode];
			key.prevTouch=_keys[_prevKeyCode];
			return key;
		}
		//------ Get Xml Config ------------------------------------
		public function getXmlConfig():XMLList {
			return _xmlConfig;
		}
		//------- To String  -------------------------------
		public function ToString():void {
			trace(_xmlConfig);
		}
	}
}