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
			var entity:IEntity=_entityManager.createEntity("Entity");
			//-- In order to import your component  classes in the compiled SWF and use them at runtime --
			//-- please insert your component classes in the Entity Manager inside the initClassRef() function --
			//-- or instanciate your component as follow --
			var spatialComponent:SpatialComponent=_entityManager.addComponent("Entity","SpatialComponent","mySpatialComponent");
			var renderComponent:RenderComponent=_entityManager.addComponent("Entity","RenderComponent","myRenderComponent");
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("Entity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.setKeysFromPath("xml/framework/game/keyboardConfig.xml","KeyboardConfig");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("Entity","KeyboardMoveComponent","myKeyMoveComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("Entity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("Entity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("Entity","ProgressBarComponent","myProgressBarComponent");
			//var serverInputComponent:ServerInputComponent=_entityManager.addComponent("Entity", "ServerInputComponent", "myServerInputComponent");
			//serverInputComponent.setConnectionFromPath("xml/framework/game/serverConfig.xml", "ServerConfig");
			//serverInputComponent.setConnection("localhost",4444);
			//var multiPlayerComponent:MultiPlayerComponent=_entityManager.addComponent("Entity", "MultiPlayerComponent", "myMultiPlayerComponent");
			//var messageComponent:MessageComponent=_entityManager.addComponent("Entity", "MessageComponent", "myMessageComponent");
			//messageComponent.loadGraphic("texture/framework/interface/messageClip.swf", "MessageClip");
			var timerComponent:TimerComponent=_entityManager.addComponent("Entity","TimerComponent","myTimerComponent");
			//var systemInfoComponent:SystemInfoComponent = _entityManager.addComponent("Entity", "SystemInfoComponent", "mySystInfoComponent");
			//var timeComponent:TimeComponent =_entityManager.addComponent("Entity", "TimeComponent", "myTimeComponent");
			//var tileMapComponent:TileMapComponent = _entityManager.addComponent("Entity", "TileMapComponent", "myTileMapComponent");
			//tileMapComponent.loadMap("xml/framework/game/map.xml", "TileMap");
			//var bitmapPlayerComponent:BitmapPlayerComponent = _entityManager.addComponent("Entity", "BitmapPlayerComponent", "myBitmapPlayerComponent");
			//bitmapPlayerComponent.loadPlayer("xml/framework/game/bitmapPlayer.xml", "BitmapPlayer");
			//bitmapPlayerComponent.setIso(true);
			var swfPlayerComponent=_entityManager.addComponent("Entity","SwfPlayerComponent","mySwfPlayerComponent");
			swfPlayerComponent.loadPlayer("xml/framework/game/swfPlayer.xml","SwfPlayer");
			swfPlayerComponent.setPropertyReference("jaugeMove",swfPlayerComponent._componentName);
			swfPlayerComponent.moveTo(20,230);
			//swfPlayerComponent.setIso(true);
			//var textComponent:TextComponent = _entityManager.addComponent("Entity", "TextComponent", "myTextComponent");
			//textComponent.setText("FlashGameMaker");
			//textComponent.setFormat("Times New Roman",30, 0xFF0000);
			//var soundComponent:SoundComponent = _entityManager.addComponent("Entity", "SoundComponent", "mySoundComponent");
			var jaugeComponent:JaugeComponent=_entityManager.addComponent("Entity","JaugeComponent","myJaugeComponent");
			jaugeComponent.moveTo(200,310);
			var jaugeMoveComponent:JaugeMoveComponent=_entityManager.addComponent("Entity","JaugeMoveComponent","myJaugeMoveComponent");
			//var chronoComponent:ChronoComponent = _entityManager.addComponent("Entity","ChronoComponent","myChronoComponent");
			var factoryComponent:FactoryComponent=_entityManager.addComponent("Entity","FactoryComponent","myFactoryComponent");
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}