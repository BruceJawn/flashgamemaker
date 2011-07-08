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

	/**
	* Script Class
	*
	*/
	public class KawaiiIsland {

		private var _entityManager:IEntityManager=null;
		
		public function KawaiiIsland() {
			initVar();
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			//var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponentFromName("GameEntity","KeyboardInputComponent","myKeyInputComponent") as KeyboardInputComponent;
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponentFromName("GameEntity","KeyboardMoveComponent","myKeyMoveComponent") as KeyboardMoveComponent;
			keyboardMoveComponent.setMode("2Dir");
			var keyboardRotationComponent:KeyboardRotationComponent=_entityManager.addComponentFromName("GameEntity","KeyboardRotationComponent","myKeyboardRotationComponent") as KeyboardRotationComponent;
			var animationComponent:AnimationComponent=_entityManager.addComponentFromName("GameEntity","AnimationComponent","myAnimationComponent") as AnimationComponent;
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponentFromName("GameEntity","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponentFromName("GameEntity","ProgressBarComponent","myProgressBarComponent") as ProgressBarComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("GameEntity","TimerComponent","myTimerComponent") as TimerComponent;
			var scrollingBitmapComponent:ScrollingBitmapComponent=_entityManager.addComponentFromName("GameEntity","ScrollingBitmapComponent","myScrollingBitmapComponent") as ScrollingBitmapComponent;
			scrollingBitmapComponent.loadGraphic("../texture/framework/game/background/bladesquad/nuage.jpg");
			scrollingBitmapComponent.setLoop(true);
			scrollingBitmapComponent.setScrolling(30,1);
			scrollingBitmapComponent.registerPropertyReference("timer");			
			var groundSphereComponent:GroundSphereComponent=_entityManager.addComponentFromName("GameEntity","GroundSphereComponent","myGroundSphereComponent") as GroundSphereComponent;
			groundSphereComponent.loadGraphic("../texture/framework/game/background/groundClip.swf");
			groundSphereComponent.registerPropertyReference("progressBar");
			groundSphereComponent.registerPropertyReference("keyboardRotation");
			//groundSphereComponent.setRotation(2);
			groundSphereComponent.moveTo(220,1050);
			var swfPlayerComponent:SwfPlayerComponent=_entityManager.addComponentFromName("GameEntity","SwfPlayerComponent","mySwfPlayerComponent") as SwfPlayerComponent;
			swfPlayerComponent.loadGraphic("../texture/framework/game/charset/bladesquad/kidClip.swf");
			swfPlayerComponent.registerPropertyReference("keyboardMove");
			swfPlayerComponent.registerPropertyReference("keyboardAttack");
			//swfPlayerComponent.setCollision(true);
			swfPlayerComponent.moveTo(120,300);
			var swfEnnemyComponent:SwfPlayerComponent=_entityManager.addComponentFromName("GameEntity","SwfPlayerComponent","mySwfEnnemyComponent") as SwfPlayerComponent;
			swfEnnemyComponent.loadGraphic("../texture/framework/game/charset/bladesquad/kidClip.swf");
			swfEnnemyComponent.registerPropertyReference("health");
			swfEnnemyComponent.moveTo(200,300);
			var healthComponent:HealthComponent=_entityManager.addComponentFromName("GameEntity","HealthComponent","myHealthComponent") as HealthComponent;
			var keyboardAttackComponent:KeyboardAttackComponent=_entityManager.addComponentFromName("GameEntity","KeyboardAttackComponent","myKeyboardAttackComponent") as KeyboardAttackComponent;
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponentFromName("GameEntity","RPGTextComponent","myRPGTextComponent") as RPGTextComponent;
			rpgTextComponent.loadGraphic("../texture/framework/game/interface/rpgText.swf");
			var sequence:String="<rpgText><sequence title='Welcome' icon='unknown?' graphic=''>Welcome to Kawaii Island</sequence><sequence title='Introduction' icon='Hero' graphic=''>Kawaii Island is a beautifull world...</sequence></rpgText>";
			rpgTextComponent.setSequence(sequence);
			rpgTextComponent.moveTo(60,20);
			var gamePadComponent:GamePadComponent=_entityManager.addComponentFromName("GameEntity","GamePadComponent","myGamePadComponent") as GamePadComponent;
			gamePadComponent.hideAll();
			gamePadComponent.moveTo(-40,300);
			gamePadComponent.showButton("_left");
			gamePadComponent.showButton("_right");
			gamePadComponent.showButton("_up");
			gamePadComponent.showButton("_down");
			gamePadComponent.showButton("_button1");
			gamePadComponent.moveButton("_button1",300,25);
			gamePadComponent.showButton("_button2");
			gamePadComponent.moveButton("_button2",340,25);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}