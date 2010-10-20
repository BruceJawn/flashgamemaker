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
*   A full copy of the license is available at http://www.gnu.org/licenses/fdl-1.3-standalone.html.
*
*/

package framework{
	import framework.core.system.*;
	import framework.core.architecture.component.ComponentReference;
	import script.ScriptReference;
	
	import flash.events.EventDispatcher;
	/**
	* Framework Class
	* @ purpose: Initialize the framework
	*/
	public class Framework{

		private var _interfaceManager:IInterfaceManager;
		private var _gameManager:IGameManager;
		
		public function Framework() {
			initClassReference();
			//initInterface("xml/framework/interface.xml");
			initGame("xml/framework/game.xml");
		}
		//------ Init Class Reference  ------------------------------------
		private  function initClassReference():void{
			new ComponentReference();
			new ScriptReference();
		}
		//------ Init Interface ------------------------------------
		private function initInterface(path:String):void {
			initInterfaceVar(path);
			initInterfaceListener();
		}
		//------ Init InterfaceVar ------------------------------------
		private function initInterfaceVar(path:String):void {
			_interfaceManager = InterfaceManager.getInstance();
			_interfaceManager.preloadInterface(path);
		}
		//------ Init Interface Listener ------------------------------------
		private function initInterfaceListener():void {
			var interfaceDispatcher:EventDispatcher = _interfaceManager.getDispatcher();
			interfaceDispatcher.addEventListener(InterfaceEvent.COMPLETE,onInterfaceLoadingSuccessful);
			interfaceDispatcher.addEventListener(InterfaceEvent.NAVIGATION_CHANGE,onInterfaceNavigationChange);
		}
		//------ On Interface Loading Successful ------------------------------------
		private function onInterfaceLoadingSuccessful(evt:InterfaceEvent):void {
			_interfaceManager.goToScreen("MenuScreen");
		}
		//------ On Interface Navigation Change ------------------------------------
		private function onInterfaceNavigationChange(evt:InterfaceEvent):void {
			var currentScreen:String = _interfaceManager.getCurrentScreen();
			if(currentScreen=="GameScreen"){
				initGame("xml/framework/game.xml");
			}
		}
		//------ Init Game ------------------------------------
		private function initGame(path:String):void {
			initGameVar(path);
			//initGameListener();
		}
		//------ Init Game Var ------------------------------------
		private function initGameVar(path:String):void {
			_gameManager = GameManager.getInstance();
			_gameManager.loadGame(path);
		}
		/*//------ Init Game Listener ------------------------------------
		public function initGameListener():void {
			var gameDispatcher:EventDispatcher = _gameManager.getDispatcher();
			gameDispatcher.addEventListener(GameEvent.NAVIGATION_CHANGE,onNavigationChange);
		}
		//------ On Game Navigation Change ------------------------------------
		public function onGameNavigationChange(evt:GameEvent):void {
			
		}*/
	}
}