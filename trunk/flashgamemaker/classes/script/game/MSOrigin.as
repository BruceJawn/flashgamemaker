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
	/**
	* Script Class
	*
	*/
	public class MSOrigin {

		private var _scriptName:String=null;
		private var _entityManager:IEntityManager=null;

		public function MSOrigin(scriptName:String) {
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
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			keyboardMoveComponent.setMode("2Dir");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("GameEntity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var backgroundColorComponent:BackgroundColorComponent=_entityManager.addComponent("GameEntity","BackgroundColorComponent","myBackgroundColorComponent");
			backgroundColorComponent.changeColor("111111");
			var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.addComponent("GameEntity","BitmapPlayerComponent","myBitmapPlayerComponent");
			bitmapPlayerComponent.loadPlayer("xml/framework/game/bitmapPlayerMSOrigin.xml","MSOrigin");
			bitmapPlayerComponent.setPropertyReference("keyboardFire",bitmapPlayerComponent._componentName);
			bitmapPlayerComponent.setCollision(true);
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
			var backgroundComponent:ScrollingBitmapComponent=_entityManager.addComponent("GameEntity","ScrollingBitmapComponent","myBackgroundComponent");
			backgroundComponent.loadGraphic("texture/framework/game/background/ms/bg.png", "MS_BG");
			backgroundComponent.setScrolling(30,5);
			//backgroundComponent.setDirection(swfPlayerComponent.getDirection());
			backgroundComponent.setPropertyReference("timer",backgroundComponent._componentName);
			backgroundComponent.moveTo(0,90);
			var backgroundObjectComponent:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","myBackgroundObjectComponent");
			backgroundObjectComponent.loadGraphic("texture/framework/game/background/ms/object.png", "MS_Object");
			backgroundObjectComponent.moveTo(0,90);
			var statutBarComponent:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","mySTatutBarGraphicComponent");
			statutBarComponent.loadGraphic("texture/framework/game/interface/MsOriginStatutBar.swf", "MsOriginStatutBar");
			statutBarComponent.moveTo(0,310);
			var soundComponent:SoundComponent=_entityManager.addComponent("GameEntity","SoundComponent","mySoundComponent");
			soundComponent.setController("texture/framework/game/interface/soundControl.swf","SoundControl");
			//soundComponent.play("sound/ms/No_Need_to_Reload.mp3","NoNeedToReload", 0.1);
			soundComponent.moveTo(300,5);
			var tweenComponent:TweenComponent=_entityManager.addComponent("GameEntity","TweenComponent","myTweenComponent");
			var healthComponent:HealthComponent=_entityManager.addComponent("GameEntity","HealthComponent","myHealthComponent");
			var keyboardFireComponent:KeyboardFireComponent=_entityManager.addComponent("GameEntity","KeyboardFireComponent","myKeyboardFireComponent");
			var scoreComponent:ScoreComponent=_entityManager.addComponent("GameEntity","ScoreComponent","myScoreComponent");
			scoreComponent.setScore("texture/framework/game/interface/score.png","Score",1);
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponent("GameEntity","RPGTextComponent","myRPGTextComponent");
			rpgTextComponent.loadGraphic("texture/framework/game/interface/rpgText.swf", "RPGText");
			var sequence:String="<rpgText><sequence title='???' icon='unknown?' graphic=''>...Roger...RAS</sequence><sequence title='Squad' icon='Squad' graphic=''>1,2,3,...GO!</sequence></rpgText>";
			rpgTextComponent.setSequence(sequence);
			rpgTextComponent.moveTo(60,50);
			rpgTextComponent.addEventListener("_RPGTextCOMPLETE",onRPGTextComplete);
		}
		//------ On RPG Text Complete ------------------------------------
		private function onRPGTextComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onRPGTextComplete);
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var chronoComponent:ChronoComponent=_entityManager.addComponent("GameEntity","ChronoComponent","myChronoComponent");
			chronoComponent.setChrono("texture/framework/game/interface/chrono.png","Chrono");
			chronoComponent.restart(59);
			chronoComponent.moveTo(180,20);
			chronoComponent.addEventListener(Event.COMPLETE,onChronoComplete);
			var gamePadComponent:GamePadComponent=_entityManager.addComponent("GameEntity","GamePadComponent","myGamePadComponent");
			gamePadComponent.moveTo(100,100);
			var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.getComponent("GameEntity","myBitmapPlayerComponent");
			var backgroundObjectComponent:GraphicComponent=_entityManager.getComponent("GameEntity","myBackgroundObjectComponent");
			var shapeCollisionComponent:ShapeCollisionComponent=_entityManager.addComponent("GameEntity","ShapeCollisionComponent","myShapeCollisionComponent");
			shapeCollisionComponent.setClip(bitmapPlayerComponent,backgroundObjectComponent);
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onChronoComplete);
			_entityManager.removeComponent("GameEntity","myBackgroundComponent");
			_entityManager.removeComponent("GameEntity","myBitmapPlayerComponent");
			_entityManager.removeComponent("GameEntity","myKeyInputComponent");
			_entityManager.removeComponent("GameEntity","mySoundComponent");
			try {
				_entityManager.removeComponent("GameEntity","myRPGTextComponent");
			} catch (e:Error) {
			}
			var gameOver:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","myGOGraphicComponent");
			gameOver.loadGraphic("texture/framework/game/interface/MSGameOver.swf", "GameOver");
			gameOver.addEventListener(Event.COMPLETE,onGameOverComplete);
			gameOver.moveTo(0,30);
			var scoreComponent:ScoreComponent=_entityManager.getComponent("GameEntity","myScoreComponent");
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
			trace(_scriptName);
		}
	}
}