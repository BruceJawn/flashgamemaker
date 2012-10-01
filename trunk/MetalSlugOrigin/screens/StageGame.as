/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://Frameworkas3.blogspot.com/
*   Group:        http://groups.google.com.au/group/Framework
*   Google Code:  http://code.google.com/p/Framework/downloads/list
*   Source Forge: https://sourceforge.net/projects/Framework/files/
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
package screens{
	import com.adobe.serialization.json.JSON;
	import data.Data;
	
	import customClasses.*;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	import framework.Framework;
	import framework.component.add.GamePadComponent;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	import framework.system.IRessourceManager;
	import framework.system.ISoundManager;
	import framework.system.RessourceManager;
	import framework.system.SoundManager;
	
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.loader.SimpleLoader;
	import utils.popforge.WavURLPlayer;
	import utils.richardlord.*;

	/**
	 * Game
	 */
	public class StageGame extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _player1:LFE_ObjectComponent=null;
		private var _player2:LFE_ObjectComponent=null;
		private var _graphicManager:IGraphicManager = null;
		private var _battleField:ScrollingBitmapComponent = null;
		private var _forests:GraphicComponent = null;
		private var _forestm2:ScrollingBitmapComponent = null;
		private var _forestm3:GraphicComponent = null
		
		public function StageGame(){
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			initVar();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("MSOrigin","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("MSOrigin","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("MSOrigin","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			bitmapRenderComponent.scrollEnabled = false;
			Framework.SetChildIndex(bitmapRenderComponent, Framework.numChildren - 1);
			var keyPad:KeyPad = new KeyPad(true);
			keyPad.useZQSD();
			keyPad.useArrows();
			keyPad.mapFireButtons(KeyCode.I,KeyCode.O,KeyCode.P,221);
			var player:LFE_ObjectComponent = LFE_Object.CreateObject(1,null,keyPad);
			player.registerPropertyReference("keyboardInput");
			player.moveTo(0,300);
			//player1.setTimeMultiplicator(10);
			var gamePad:GamePadComponent = EntityFactory.CreateGamePad("GamePad1", 20,520,keyPad);
			
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			
			var backgroundComponent:ScrollingBitmapComponent=_entityManager.addComponent("GameEntity","ScrollingBitmapComponent","myBackgroundComponent");
			backgroundComponent.setPropertyReference("progressBar",backgroundComponent._componentName);
			backgroundComponent.setPropertyReference("timer",backgroundComponent._componentName);
			//backgroundComponent.graphic = _graphicManager.getGraphic(Data.BACKGROUND[0].path);
			backgroundComponent.setScrolling(30,3);
			backgroundComponent.setScrollingTarget(bitmapPlayerComponent);
			backgroundComponent.moveTo(0,90);
			
			/*var statutBarComponent:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","myStatutBarGraphicComponent");
			statutBarComponent.setPropertyReference("progressBar",statutBarComponent._componentName);
			statutBarComponent.loadGraphic("texture/framework/game/interface/MsOriginStatutBar.swf", "MsOriginStatutBar");
			statutBarComponent.moveTo(0,310);*/
			
			/*var scoreComponent:ScoreComponent=_entityManager.addComponent("GameEntity","ScoreComponent","myScoreComponent");
			scoreComponent.setScore("texture/framework/game/interface/score.png","Score",1);*/
			
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponent("GameEntity","RPGTextComponent","myRPGTextComponent");
			rpgTextComponent.loadGraphic(Framework+"assets/rpgText.swf", "RPGText");
			var sequence:String="<rpgText><sequence title='???' icon='unknown?' graphic=''>...Roger...RAS</sequence><sequence title='Squad' icon='Squad' graphic=''>1,2,3,...GO!</sequence></rpgText>";
			rpgTextComponent.setSequence(sequence);
			rpgTextComponent.moveTo(60,50);
			rpgTextComponent.addEventListener("_RPGTextCOMPLETE",onRPGTextComplete);
		}
		//------ On RPG Text Complete ------------------------------------
		private function onRPGTextComplete(evt:Event):void {
			/*evt.target.removeEventListener(Event.COMPLETE,onRPGTextComplete);
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var chronoComponent:ChronoComponent=_entityManager.addComponent("GameEntity","ChronoComponent","myChronoComponent");
			chronoComponent.setChrono("texture/framework/game/interface/chrono.png","Chrono");
			chronoComponent.restart(59);
			chronoComponent.moveTo(180,20);
			chronoComponent.addEventListener(Event.COMPLETE,onChronoComplete);
			var gamePadComponent:GamePadComponent=_entityManager.addComponent("GameEntity","GamePadComponent","myGamePadComponent");
			gamePadComponent.moveTo(100,100);
			//var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.getComponent("GameEntity","myBitmapPlayerComponent");
			//var shapeCollisionComponent:ShapeCollisionComponent=_entityManager.addComponent("GameEntity","ShapeCollisionComponent","myShapeCollisionComponent");
			//shapeCollisionComponent.setClip(bitmapPlayerComponent,backgroundObjectComponent);
			*/
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete(evt:Event):void {
			/*evt.target.removeEventListener(Event.COMPLETE,onChronoComplete);
			_entityManager.removeComponent("GameEntity","myBackgroundComponent");
			_entityManager.removeComponent("GameEntity","myBitmapPlayerComponent");
			_entityManager.removeComponent("GameEntity","myEnnemyPlayerComponent");
			_entityManager.removeComponent("GameEntity","myKeyInputComponent");
			_entityManager.removeComponent("GameEntity","mySoundComponent");
			var gameOver:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","myGOGraphicComponent");
			gameOver.loadGraphic("texture/framework/game/interface/MSGameOver.swf", "GameOver");
			gameOver.addEventListener(Event.COMPLETE,onGameOverComplete);
			gameOver.moveTo(0,30);
			var scoreComponent:ScoreComponent=_entityManager.getComponent("GameEntity","myScoreComponent");
			*/
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
	}
}