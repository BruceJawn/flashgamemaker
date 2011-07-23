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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.*;
	
	import utils.keyboard.KeyPad;
	import utils.keyboard.KeyCode;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class KeyboardInputComponent extends Component{

		private var _keyPad:KeyPad = null;
		private var _isListening:Boolean = false;
		private var _shift:Boolean;
		private var _ctrl:Boolean;
		
		public function KeyboardInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
			//initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_keyPad = new KeyPad;
		}
		
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardInput") {
				if(!_isListening){
					_isListening=true;
					initListener();
				}
			}
		}
		//------ On Key Down ------------------------------------
		private function onKeyDown($evt:KeyboardEvent):void {
			_shift=$evt.shiftKey;
			_ctrl=$evt.ctrlKey;
			_keyPad.keyDown($evt.keyCode);
			onKeyFire();
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp($evt:KeyboardEvent):void {
			_shift=$evt.shiftKey;
			_ctrl=$evt.ctrlKey;
			_keyPad.keyUp($evt.keyCode);
			onKeyFire();
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire():void {
			dispatch("onKeyFire");
		}
		//------ On Dispatch ------------------------------------
		private function dispatch($callback:String):void {
			var components:Vector.<Object> = _properties["keyboardInput"];
			for each (var object:Object in components){
				if(object.param.hasOwnProperty($callback)){
					object.param[$callback](_keyPad);
				}
			}
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}