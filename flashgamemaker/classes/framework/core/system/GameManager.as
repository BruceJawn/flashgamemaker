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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system {
	import utils.loader.*;
	import framework.core.architecture.entity.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	
	/**
	* Game Manager Class
	* @ purpose: Store and manage all the interfaces.
	*/
	public class GameManager extends SimpleLoader implements IGameManager{
		
		private static var _instance:IGameManager=null;
		private static var _allowInstanciation:Boolean = false;
		private var _keyboardManager:IKeyboardManager = null;
		private var _mouseManager:IMouseManager = null;
		private var _serverManager:IServerManager = null;
		private var _entityManager:IEntityManager = null;
		
		public function GameManager(){
			if(!_allowInstanciation){
				 throw new Error("Error: Instantiation failed: Use GameManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IGameManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance = new GameManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_keyboardManager = KeyboardManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_serverManager = ServerManager.getInstance();
			_entityManager = EntityManager.getInstance();
		}
		//------ Load Game ------------------------------------
		public function loadGame(path:String):void{
			initLoadingProgress();
			loadXmlsFromPath(path, "Game");
		}
		//------ On Xml Loading Successful ------------------------------------
		protected override function onXmlLoadingSuccessful(evt:Event):void {
			removeXmlListener();
			//initConfig();
			preloadTexture();
		}
		//------ Init Config ------------------------------------
		private function initConfig():void{
			var keyboardXml:XML = _ressourceManager.getXml("KeyboardConfig");
			if(keyboardXml!=null){
				_keyboardManager.setKeys(keyboardXml);
			}
			var serverXml:XML = _ressourceManager.getXml("ServerConfig");
			if(serverXml!=null){
				_serverManager.setConnection(serverXml);
				_serverManager.startConnection();
			}
		}
		//------ Preload Texture ------------------------------------
		private function preloadTexture():void{
			var textureXml:XML = _ressourceManager.getXml("Texture");
			loadGraphicsFromXml(textureXml, "Texture");
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			removeGraphicListener();
			removeLoadingProgress();
			startGame();
		}
		//------ Start Game ------------------------------------
		protected  function startGame():void {
			var entity:IEntity = _entityManager.createEntity("Entity");
			//-- In order to import your component  classes in the compiled SWF and use them at runtime --
			//-- please insert your component classes in the Entity Manager inside the initClassRef() function --
			//_entityManager.addComponent("Entity", "KeyboardInputComponent");
			//_entityManager.addComponent("Entity", "MouseInputComponent");
			//_entityManager.addComponent("Entity", "ServerInputComponent");
			_entityManager.addComponent("Entity", "RenderComponent");
			_entityManager.addComponent("Entity", "SpatialComponent");
			_entityManager.addComponent("Entity", "SystemInfoComponent");
		}
	}
}