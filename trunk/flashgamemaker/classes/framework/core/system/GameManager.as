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
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	import flash.display.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;

	/**
	* Game Manager Class
	* @ purpose: Store and manage all the interfaces.
	*/
	public class GameManager extends SimpleLoader implements IGameManager {

		private static var _instance:IGameManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _entityManager:IEntityManager=null;
		private var _keyboardManager:IKeyboardManager=null;
		private var _mouseManager:IMouseManager=null;
		private var _serverManager:IServerManager=null;
		private var _timeManager:ITimeManager=null;


		public function GameManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use GameManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IGameManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance=new GameManager  ;
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_keyboardManager=KeyboardManager.getInstance();
			_mouseManager=MouseManager.getInstance();
			_serverManager=ServerManager.getInstance();
			_timeManager=TimeManager.getInstance();
		}
		//------ Load Game ------------------------------------
		public function loadGame(path:String):void {
			startGame();
		}
		//------ Start Game ------------------------------------
		protected function startGame():void {
			removeGraphicListener();
			removeLoadingProgress();
			var entity:IEntity=_entityManager.createEntity("GameEntity");
			var spatialComponent:SpatialComponent=_entityManager.addComponent("GameEntity","SpatialComponent","mySpatialComponent");
			var renderComponent:RenderComponent=_entityManager.addComponent("GameEntity","RenderComponent","myRenderComponent");
			var navigationComponent:NavigationComponent=_entityManager.addComponent("GameEntity","NavigationComponent","myNavigationComponent");
			navigationComponent.setScript("ScriptKawaiiFight");
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}