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
	import framework.add.architecture.component.*;
	
	import flash.events.Event;
	/**
	* Script Class
	*
	*/
	public class Korizon {

		private var _scriptName:String=null;
		private var _entityManager:IEntityManager=null;

		public function Korizon(scriptName:String) {
			initVar(scriptName);
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar(scriptName:String):void {
			_scriptName=scriptName;
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			//var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("GameEntity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var backGroundColorComponent:BackgroundColorComponent= _entityManager.addComponent("GameEntity","BackgroundColorComponent","myBackgroundColorComponent");
			backGroundColorComponent.changeColor("000000");
			var header:GraphicComponent= _entityManager.addComponent("GameEntity","GraphicComponent","KorizonHeader");
			header.loadGraphic("texture/framework/game/interface/korizon/header.gif", "KorizonHeader");
			var statut:GraphicComponent= _entityManager.addComponent("GameEntity","GraphicComponent","KorizonStatut");
			statut.loadGraphic("texture/framework/game/interface/korizon/statutBar.png", "KorizonStatut");
			statut.moveTo(0,101);
			var box2D:Box2DComponent = _entityManager.addComponent("GameEntity", "Box2DComponent", "myBox2DComponent");
			box2D.makeBox(0, 200, FlashGameMaker.WIDTH, 350);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}