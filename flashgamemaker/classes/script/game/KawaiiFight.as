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

package script.game{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	/**
	* Script Class
	*
	*/
	public class KawaiiFight {

		private var _scriptName:String = null;
		private var _entityManager:IEntityManager=null;
		
		public function KawaiiFight(scriptName:String) {
			initVar(scriptName);
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar(scriptName:String):void {
			_scriptName = scriptName;
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.setKeysFromPath("xml/framework/game/keyboardConfig.xml","KeyboardConfig");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("GameEntity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var systemInfoComponent:SystemInfoComponent = _entityManager.addComponent("GameEntity", "SystemInfoComponent", "mySystInfoComponent");
			var tileMapComponent:TileMapComponent=_entityManager.addComponent("GameEntity","TileMapComponent","myTileMapComponent");
			tileMapComponent.loadMap("xml/framework/game/mapKawaii.xml", "TileMap");
			tileMapComponent.moveTo(160,100);
			var swfPlayerComponent=_entityManager.addComponent("GameEntity","SwfPlayerComponent","mySwfPlayerComponent");
			swfPlayerComponent.loadPlayer("xml/framework/game/swfPlayerKawaiiFight.xml", "mySwfPlayer");
			swfPlayerComponent.setPropertyReference("keyboardMove",swfPlayerComponent._componentName);
			swfPlayerComponent.moveTo(250,100);
			swfPlayerComponent.setIso(true);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}