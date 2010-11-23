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
		private var _keyboard_gamePad:Object = null;
		
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
			getGamePad();
			update("keyboardInput");
		}
		//------ Get GamePad ------------------------------------
		private function getGamePad():void {
			_keyboard_gamePad = _keyboardManager.getGamePad();
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			component._keyboard_gamePad = _keyboard_gamePad;
			component.actualizeComponent(componentName,componentOwner,component);
		}
		//------ Map Direction ------------------------------------
		public function mapDirection(up:int, down:int, left:int, right:int, replaceExisting:Boolean = false):void{
			_keyboardManager.mapDirection(up,down,left,right,replaceExisting);
		}
		//------ Use WASD ------------------------------------
		public function useWASD(replaceExisting:Boolean = false):void{
			_keyboardManager.useWASD(replaceExisting);
		}
		//------ Use IJKL ------------------------------------
		public function useIJKL(replaceExisting:Boolean = false):void{
			_keyboardManager.useIJKL(replaceExisting);
		}
		//------ Use ZQSD ------------------------------------
		public function useZQSD(replaceExisting:Boolean = false):void{
			_keyboardManager.useZQSD(replaceExisting);
		}
		//------ Map Fire Buttons ------------------------------------
		public function mapFireButtons(fire1:int, fire2:int,fire3:int,fire4:int, replaceExisting:Boolean = false):void{
			_keyboardManager.mapFireButtons(fire1,fire2,fire3,fire4,replaceExisting);
		}
		//------ Use JKLM ------------------------------------
		public function useJKLM(replaceExisting:Boolean = false):void{
			_keyboardManager.useJKLM(replaceExisting);
		}
		//------ Use OKLM ------------------------------------
		public function useOKLM(replaceExisting:Boolean = false):void{
			_keyboardManager.useOKLM(replaceExisting);
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}