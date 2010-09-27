﻿/*
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
		private var _keys:Dictionary;
		private var _keyCode:Number = 0;
		private var _keyStatut:String="UP"; //Key is UP or DOWN
		private var _charCode:String;
		private var _prevKeyCode:Number = 0; // Previous keys down
		private var _doubleClick:Boolean = false;
		private var _doubleClickLatence:Number = 175;
		private var _longClick:Boolean = false;
		private var _longClickLatence:Number = 575;
		private var _ctrlKey:Boolean = false;
		private var _shiftKey:Boolean = false;
		private var _timer:Number = 0;
		private var _interval:Number = 0;
		
		public function KeyboardManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use KeyboardManager.getInstance() instead of new.");
			}
			initVar();
			initListener();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IKeyboardManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new KeyboardManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_keys = new Dictionary();
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
		//------ On Key Down ------------------------------------
		private function onKeyDown(evt:KeyboardEvent):void {
			if(_keyStatut=="UP"){
				_keyStatut= "DOWN"; 
				initTimer();
				updateKey(evt);
				checkDoubleClick();
				dispatchEvent(evt);
			}
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp(evt:KeyboardEvent):void {
			_keyStatut= "UP"; 
			updateTimer();
			checkLongClick();
			dispatchEvent(evt);
		}
		//------ Update Key ------------------------------------
		private function updateKey(evt:KeyboardEvent):void {
			_prevKeyCode = _keyCode;
			_keyCode = evt.keyCode;
			_shiftKey = evt.shiftKey;
			_ctrlKey = evt.ctrlKey;
			_charCode = String.fromCharCode(evt.charCode).toUpperCase();
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			var interval:Number = getTime() - _timer;
			if (_timer==0 || interval>_longClickLatence){
				_timer = getTime();
				_interval = 0;
			}else{
				 _interval = getTime() - _timer;
				 _timer = 0;
			}
		}
		//------ Update Timer ------------------------------------
		private function updateTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Check Double Click ------------------------------------
		private function checkDoubleClick():void {
			if(_interval!=0 && _interval<_doubleClickLatence && _prevKeyCode == _keyCode ){
				_doubleClick = true;
			}else{
				_doubleClick = false;
			}
		}
		//------ Check Long Click ------------------------------------
		private function checkLongClick():void {
			if(_interval>_longClickLatence){
				_longClick = true;
			}else{
				_longClick = false;
			}
		}
		//------ Set Keys ------------------------------------
		public function setKeys(xml:XML):void {
			var xmlList:XMLList = xml.children();
			for each (var xmlChild:XML in xmlList) {
				var keyName:String = xmlChild.name();
				var keyCode:Number = getKeyCode(xmlChild);
				_keys[keyCode] = keyName;
			}			
		}
		//------ Get Key Code ------------------------------------
		private function getKeyCode(charCode:String):Number {
			var keyCode:Number=charCode.charCodeAt(0);
			return keyCode;
		}
		//---- Get Time ------------------------------------------------
	    private function getTime():Number{
		  return Time.GetTime();
	    }	
		//------ Get Key ------------------------------------
		public function getKey():Object {
			var key:Object=new Object();
			key.keyCode = _keyCode;
			key.charCode = _charCode;
			key.keyStatut = _keyStatut;
			key.doubleClick = _doubleClick;
			key.longClick = _longClick;
			key.shiftKey = _shiftKey;
			key.ctrlKey = _ctrlKey;
			key.keyTouch = _keys[_keyCode];
			return key;
		}
		//------- To String  -------------------------------
		public function ToString():void{
            trace(_keyCode,_charCode, _doubleClick , _longClick);
        }
	}
}