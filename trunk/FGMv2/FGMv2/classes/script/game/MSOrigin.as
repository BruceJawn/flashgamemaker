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

	import flash.events.*;
	import flash.geom.Point;
	/**
	* Script Class
	*
	*/
	public class MSOrigin {

		private var _entityManager:IEntityManager=null;

		public function MSOrigin() {
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
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponentFromName("GameEntity","KeyboardMoveComponent","myKeyMoveComponent") as KeyboardMoveComponent;
			keyboardMoveComponent.setMode("2Dir");
			var animationComponent:AnimationComponent=_entityManager.addComponentFromName("GameEntity","AnimationComponent","myAnimationComponent") as AnimationComponent;
			var mouseMoveComponent:MouseMoveComponent=_entityManager.addComponentFromName("GameEntity","MouseMoveComponent","myMouseMoveComponent") as MouseMoveComponent;
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponentFromName("GameEntity","ProgressBarComponent","myProgressBarComponent") as ProgressBarComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("GameEntity","TimerComponent","myTimerComponent") as TimerComponent;
			var aiComponent:AIComponent=_entityManager.addComponentFromName("GameEntity","AIComponent","myAIComponent") as AIComponent;
			var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.addComponentFromName("GameEntity","BitmapPlayerComponent","myBitmapPlayerComponent") as BitmapPlayerComponent;
			bitmapPlayerComponent.registerPropertyReference("keyboardMove");
			bitmapPlayerComponent.registerPropertyReference("keyboardFire");
			bitmapPlayerComponent.loadPlayer("../xml/framework/game/bitmapPlayerMSOrigin.xml","MSOrigin");
			//bitmapPlayerComponent.setCollision(true);
			bitmapPlayerComponent.moveTo(50,200);
			bitmapPlayerComponent.setAnim("WALK",2);
			bitmapPlayerComponent.setAnim("WALK_UP",13);
			bitmapPlayerComponent.setAnim("WALK_DOWN",6);
			bitmapPlayerComponent.setAnim("ATTACK",1);
			bitmapPlayerComponent.setAnim("JUMP",8);
			bitmapPlayerComponent.setAnim("JUMP_DOWN",10);
			bitmapPlayerComponent.setAnim("SIT",5);
			bitmapPlayerComponent.setAnim("STATIC_DOWN",4);
			bitmapPlayerComponent.setAnim("STATIC_UP",11);
			var ennemyPlayerComponent:BitmapPlayerComponent=_entityManager.addComponentFromName("GameEntity","BitmapPlayerComponent","myEnnemyPlayerComponent") as BitmapPlayerComponent;
			ennemyPlayerComponent.registerPropertyReference("AI");
			ennemyPlayerComponent.registerPropertyReference("mouseMove");
			ennemyPlayerComponent.loadPlayer("../xml/framework/game/bitmapPlayerMSOrigin.xml","MSOrigin");
			aiComponent.setAI(ennemyPlayerComponent,"follow",bitmapPlayerComponent);
			ennemyPlayerComponent.moveTo(-40,200);
			ennemyPlayerComponent.setAnim("WALK",2);
			ennemyPlayerComponent.setAnim("WALK_UP",13);
			ennemyPlayerComponent.setAnim("WALK_DOWN",6);
			ennemyPlayerComponent.setAnim("ATTACK",1);
			ennemyPlayerComponent.setAnim("JUMP",8);
			ennemyPlayerComponent.setAnim("JUMP_DOWN",10);
			ennemyPlayerComponent.setAnim("SIT",5);
			ennemyPlayerComponent.setAnim("STATIC_DOWN",4);
			ennemyPlayerComponent.setAnim("STATIC_UP",11);
			var backgroundComponent:ScrollingBitmapComponent=_entityManager.addComponentFromName("GameEntity","ScrollingBitmapComponent","myBackgroundComponent") as ScrollingBitmapComponent;
			backgroundComponent.registerPropertyReference("progressBar");
			backgroundComponent.registerPropertyReference("timer");
			backgroundComponent.loadGraphic("texture/framework/game/background/ms/bg.png");
			backgroundComponent.setScrolling(30,3);
			backgroundComponent.setScrollingTarget(bitmapPlayerComponent);
			backgroundComponent.moveTo(0,90);
			/*var backgroundObjectComponent:GraphicComponent=_entityManager.addComponentFromName("GameEntity","GraphicComponent","myBackgroundObjectComponent");
			backgroundObjectComponent.loadGraphic("texture/framework/game/background/ms/object.png", "MS_Object");
			backgroundObjectComponent.moveTo(0,90);
			*/
			var statutBarComponent:GraphicComponent=_entityManager.addComponentFromName("GameEntity","GraphicComponent","mySTatutBarGraphicComponent") as GraphicComponent;
			statutBarComponent.registerPropertyReference("progressBar");
			statutBarComponent.loadGraphic("../texture/framework/game/interface/MsOriginStatutBar.swf");
			statutBarComponent.moveTo(0,310);
			var soundComponent:SoundComponent=_entityManager.addComponentFromName("GameEntity","SoundComponent","mySoundComponent") as SoundComponent;
			//soundComponent.setController("texture/framework/game/interface/soundControl.swf","SoundControl");
			//soundComponent.play("sound/ms/No_Need_to_Reload.mp3","NoNeedToReload", 0.1);
			soundComponent.moveTo(300,5);
			var healthComponent:HealthComponent=_entityManager.addComponentFromName("GameEntity","HealthComponent","myHealthComponent") as HealthComponent;
			var keyboardFireComponent:KeyboardFireComponent=_entityManager.addComponentFromName("GameEntity","KeyboardFireComponent","myKeyboardFireComponent") as KeyboardFireComponent;
			keyboardFireComponent.loadGraphic("../texture/framework/game/fx/bullet.png");
			keyboardFireComponent.setBullets(60,20,10,20,new Point(10,10),60);
			keyboardFireComponent.addPlayer(ennemyPlayerComponent);
			var scoreComponent:ScoreComponent=_entityManager.addComponentFromName("GameEntity","ScoreComponent","myScoreComponent") as ScoreComponent;
			scoreComponent.setScore("../texture/framework/game/interface/score.png","Score",1);
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponentFromName("GameEntity","RPGTextComponent","myRPGTextComponent") as RPGTextComponent;
			rpgTextComponent.loadGraphic("../texture/framework/game/interface/rpgText.swf");
			var sequence:String="<rpgText><sequence title='???' icon='unknown?' graphic=''>...Roger...RAS</sequence><sequence title='Squad' icon='Squad' graphic=''>1,2,3,...GO!</sequence></rpgText>";
			rpgTextComponent.setSequence(sequence);
			rpgTextComponent.moveTo(60,50);
			rpgTextComponent.addEventListener("_RPGTextCOMPLETE",onRPGTextComplete);
		}
		//------ On RPG Text Complete ------------------------------------
		private function onRPGTextComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onRPGTextComplete);
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponentFromName("GameEntity","KeyboardInputComponent","myKeyInputComponent") as KeyboardInputComponent;
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponentFromName("GameEntity","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var chronoComponent:ChronoComponent=_entityManager.addComponentFromName("GameEntity","ChronoComponent","myChronoComponent") as ChronoComponent;
			chronoComponent.setChrono("../texture/framework/game/interface/chrono.png","Chrono");
			chronoComponent.restart(59);
			chronoComponent.moveTo(180,20);
			chronoComponent.addEventListener(Event.COMPLETE,onChronoComplete);
			var gamePadComponent:GamePadComponent=_entityManager.addComponentFromName("GameEntity","GamePadComponent","myGamePadComponent") as GamePadComponent;
			gamePadComponent.moveTo(100,100);
			//var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.getComponent("GameEntity","myBitmapPlayerComponent") as BitmapPlayerComponent;
			//var shapeCollisionComponent:ShapeCollisionComponent=_entityManager.addComponentFromName("GameEntity","ShapeCollisionComponent","myShapeCollisionComponent") as ShapeCollisionComponent;
			//shapeCollisionComponent.setClip(bitmapPlayerComponent,backgroundObjectComponent);
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onChronoComplete);
			_entityManager.removeComponentFromName("GameEntity","myBackgroundComponent");
			_entityManager.removeComponentFromName("GameEntity","myBitmapPlayerComponent");
			_entityManager.removeComponentFromName("GameEntity","myEnnemyPlayerComponent");
			_entityManager.removeComponentFromName("GameEntity","myKeyInputComponent");
			_entityManager.removeComponentFromName("GameEntity","mySoundComponent");
			var gameOver:GraphicComponent=_entityManager.addComponentFromName("GameEntity","GraphicComponent","myGOGraphicComponent") as GraphicComponent;
			gameOver.loadGraphic("../texture/framework/game/interface/MSGameOver.swf");
			gameOver.addEventListener(Event.COMPLETE,onGameOverComplete);
			gameOver.moveTo(0,30);
			var scoreComponent:ScoreComponent=_entityManager.getComponent("GameEntity","myScoreComponent") as ScoreComponent;
		}
		//------ On Game Over Complete ------------------------------------
		private function onGameOverComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onGameOverComplete);
			evt.target._graphic.playBt.addEventListener(MouseEvent.CLICK,onGameOverPlayClick);
		}
		//------ On Game Over Play Click ------------------------------------
		private function onGameOverPlayClick(evt:Event):void {
			evt.target.removeEventListener(MouseEvent.CLICK,onGameOverPlayClick);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}