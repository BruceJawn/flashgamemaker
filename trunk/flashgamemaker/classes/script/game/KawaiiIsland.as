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
	public class KawaiiIsland {

		private var _scriptName:String = null;
		private var _entityManager:IEntityManager=null;
		
		public function KawaiiIsland(scriptName:String) {
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
			keyboardInputComponent.setKey(38, "JUMP");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			var keyboardRotationComponent:KeyboardRotationComponent=_entityManager.addComponent("GameEntity","KeyboardRotationComponent","myKeyboardRotationComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("GameEntity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var backGroundComponent:BackGroundComponent= _entityManager.addComponent("GameEntity","BackGroundComponent","myBackGroundComponent");
			backGroundComponent.changeColor("95eaff");
			var scrollingBitmapComponent:ScrollingBitmapComponent=_entityManager.addComponent("GameEntity","ScrollingBitmapComponent","myScrollingBitmapComponent");
			scrollingBitmapComponent.loadGraphic("texture/framework/game/backGround/bladesquad/nuage.jpg","Nuage");
			scrollingBitmapComponent.setLoop(true);
			scrollingBitmapComponent.setScrolling(30,1);
			scrollingBitmapComponent.setPropertyReference("timer",scrollingBitmapComponent._componentName);			
			var groundSphereComponent=_entityManager.addComponent("GameEntity","GroundSphereComponent","myGroundSphereComponent");
			groundSphereComponent.setPropertyReference("progressBar",groundSphereComponent._componentName);
			groundSphereComponent.loadGraphic("texture/framework/game/backGround/groundClip.swf","GroundClip");
			groundSphereComponent.setPropertyReference("keyboardRotation",groundSphereComponent._componentName);
			groundSphereComponent.moveTo(220,1050);
			var swfPlayerComponent=_entityManager.addComponent("GameEntity","SwfPlayerComponent","mySwfPlayerComponent");
			swfPlayerComponent.loadPlayer("xml/framework/game/swfPlayerKawaiiIsland.xml","mySwfPlayer");
			swfPlayerComponent.setPropertyReference("keyboardMove",swfPlayerComponent._componentName);
			swfPlayerComponent.setDirection("Horizontal");
			swfPlayerComponent.setCollision(true);
			swfPlayerComponent.moveTo(120,300);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}