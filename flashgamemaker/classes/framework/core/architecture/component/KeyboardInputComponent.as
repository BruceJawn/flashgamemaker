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
	import framework.core.system.KeyboardManager;
	import framework.core.system.IKeyboardManager;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class KeyboardInputComponent extends Component{

		private var _keyboardManager:IKeyboardManager = null;
		private var _key:Object = null;
		
		public function KeyboardInputComponent(componentName:String, componentOwner:IEntity){
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_keyboardManager = KeyboardManager.getInstance();
			_keyboardManager.register(this);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardInput", _componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			var dispatcher:EventDispatcher = _keyboardManager.getDispatcher();
			dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, onKeyFire);
			dispatcher.addEventListener(KeyboardEvent.KEY_UP, onKeyFire);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			var dispatcher:EventDispatcher = _keyboardManager.getDispatcher();
			dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyFire);
			dispatcher.removeEventListener(KeyboardEvent.KEY_UP, onKeyFire);
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire(evt:KeyboardEvent):void {
			getKey();
			update("keyboardInput");
		}
		//------ Get Key ------------------------------------
		private function getKey():void {
			_key = _keyboardManager.getKey();
			var keyObject:String="KeyInput KeyStatut:"+_key.keyStatut+" ,KeyTouch:"+_key.keyTouch;
			keyObject+=" ,KeyCode:"+_key.keyCode+" ,CharCode:"+_key.charCode+" ,DoubleClick:"+_key.doubleClick;
			keyObject+=" ,LongClick:"+_key.longClick+" ,Shift:"+_key.shiftKey+" ,Ctrl:"+_key.ctrlKey;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			component._key = _key;
			component.refresh();
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}