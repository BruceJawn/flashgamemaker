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
	
	import customClasses.*;
	
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import framework.Framework;
	import framework.component.Component;
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
	import utils.time.Time;
	import utils.ui.LayoutUtil;

	/**
	 * Game
	 */
	public class VsGame extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _player1:LFE_ObjectComponent=null;
		private var _player2:LFE_ObjectComponent=null;
		private var _players:Array;
		private var _graphicManager:IGraphicManager = null;
		private var _battleField:ScrollingBitmapComponent = null;
		private var _forests:GraphicComponent = null;
		private var _forestm2:ScrollingBitmapComponent = null;
		private var _forestm3:GraphicComponent = null
		private var _pause:PauseComponent = null;
		private var _menuComponent:GraphicComponent = null;
		private var _statusBar:GraphicComponent = null;
		private var _list:Array = null;
		private var _lang:Object = null;
		private var _nbPlayer:int =0;
		private var _deadPlayer:int =0;
		private var _useMiniBar:Boolean = true;
		private var _summary:GraphicComponent = null;
		private var _startTime:Number =0;
		public function VsGame(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			_list=new Array();
			_lang= MultiLang.data[Data.LOCAL_LANG];
			_players = new Array();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("LittleFighterEvo","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("LittleFighterEvo","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("LittleFighterEvo","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			bitmapRenderComponent.scrollEnabled = false;
			Framework.SetChildIndex(bitmapRenderComponent,Framework.numChildren-1);
			var spatialMoveComponent:SpatialMoveComponent=_entityManager.addComponentFromName("LittleFighterEvo","SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var keyBoardInput:KeyboardInputComponent=_entityManager.addComponentFromName("LittleFighterEvo","KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			keyBoardInput.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponentFromName("LittleFighterEvo","KeyboardMoveComponent","myKeyboardMoveComponent") as KeyboardMoveComponent;
			var collisionDetectionComponent:CollisionDetectionComponent=_entityManager.addComponentFromName("LittleFighterEvo","CollisionDetectionComponent","myCollisionDetectionComponent") as CollisionDetectionComponent;
			createBattleField();
			createWeapons();
			createPlayers();
			createStatusBar();
			_list.push(EntityFactory.CreateSystemInfo("SystemInfo",100,582));
			_startTime = Time.GetTime();
		}
		//------- Create Battle Field -------------------------------
		private function createBattleField():void {
			_forests = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myForests",{render:"render"}) as GraphicComponent;
			_forests.graphic = _graphicManager.getGraphic("forests.png") as Bitmap;
			_list.push(_forests);
			
			_forestm2=_entityManager.addComponentFromName("LittleFighterEvo","ScrollingBitmapComponent","myForestsm2",{canvas:{"width":800,"height":600}}) as ScrollingBitmapComponent;
			var bitmaps:Vector.<Bitmap> = new Vector.<Bitmap>()
			bitmaps.push(_graphicManager.getGraphic("forestm1.png") as Bitmap);
			bitmaps.push(_graphicManager.getGraphic("forestm2.png") as Bitmap);
			var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"HORIZONTAL")
			_forestm2.graphic = bitmap;
			_forestm2.moveTo(0,18);
			_list.push(_forestm2);
			
			_forestm3 = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myForestm3",{render:"render"}) as GraphicComponent;
			bitmaps = new Vector.<Bitmap>()
			bitmaps.push(_graphicManager.getGraphic("forestm3.png") as Bitmap);
			bitmaps.push(_graphicManager.getGraphic("forestm4.png") as Bitmap);
			bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"HORIZONTAL",1000)
			_forestm3.graphic =bitmap;
			_forestm3.moveTo(0,50);
			_list.push(_forestm3);
			
			_battleField=_entityManager.addComponentFromName("LittleFighterEvo","ScrollingBitmapComponent","myBattleField",{canvas:{"width":800,"height":600, "repeatX":true, "repeatY":false}}) as ScrollingBitmapComponent;
			_battleField.graphic = _graphicManager.getGraphic("../assets/btf1.png")as Bitmap;
			_battleField.moveTo(0,80);
			_list.push(_battleField);
		}
		//------- Create Weapons -------------------------------
		private function createWeapons():void {
			var weapon:LFE_ObjectComponent = LFE_Object.CreateObject(151,null,null,new IsoPoint(150,330));
			_list.push(weapon);
			//setTimeout(LFE_Object.CreateObject,1000,100,null,null,new IsoPoint(300,100,30));
			//setTimeout(LFE_Object.CreateObject,2000,101,null,null,new IsoPoint(100,100,30));
			setTimeout(LFE_Object.CreateObject,3000,121,null,null,new IsoPoint(500,100,30));
		}
		//------- Create Players -------------------------------
		private function createPlayers():void {
			_nbPlayer = 0;
			for each(var data:Object in Data.GAME_PARAM.players){
				_nbPlayer++;
				var oid:int = data[0];
				var player:String = data[1];
				var team:String = data[2];
				if(player!=_lang.CharacterSelection.computer){
					var keyPad:KeyPad = new KeyPad(true);
					var keyConfig:Object = KeyConfig["Player"+player];
					keyPad.mapDirection(keyConfig.UP,keyConfig.DOWN,keyConfig.LEFT,keyConfig.RIGHT);
					keyPad.mapFireButtons(keyConfig.A,keyConfig.J,keyConfig.D,0);
					var playerComponent:LFE_ObjectComponent = LFE_Object.CreateObject(oid,null,keyPad);
					playerComponent.registerPropertyReference("keyboardInput");
					var gamePad:GamePadComponent = EntityFactory.CreateGamePad("GamePad"+player, 20+(int(player)-1)*450,395,keyPad);
					gamePad.hideDirectionKeys();
					gamePad.button4.visible=false
					gamePad.moveFireKeys(-100,10);
					_list.push(gamePad);
					playerComponent.addPlayerName(_nbPlayer.toString());
					if(player=="1")	_player1 = playerComponent;
					else 			_player2 = playerComponent;
				}else{
					playerComponent = LFE_Object.CreateObject(oid,null,new KeyPad);
					playerComponent.setAI(true);
					playerComponent.addPlayerName(_lang.CharacterSelection.computer);
				}
				playerComponent.addEventListener(Event.COMPLETE,onPlayerDead,false,0,true);
				if(_useMiniBar)playerComponent.addMiniBar();
				playerComponent.moveTo(Math.random()*600,300+Math.random()*100);
				_list.push(playerComponent);
				_list.push(playerComponent.playerName);
				_list.push(playerComponent.miniBar);
				_players.push(playerComponent);
			}
		}
		//------- Create Status Bar -------------------------------
		private function createStatusBar():void {
			if(_useMiniBar)	return;
			_statusBar = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myStatusBar") as GraphicComponent;
			_statusBar.graphic = new StatusBarUI as MovieClip;
			_list.push(_statusBar);
			for(var i:int=0;i<=8;i++){
				if(_nbPlayer<5 && i>=5){
					_statusBar.graphic["status"+i].visible = false;
				}
				if(i>_nbPlayer){
					_statusBar.graphic["status"+i].lifeBar.visible = false;
					_statusBar.graphic["status"+i].mpBar.visible = false;	
				}
			}
			i=1;
			for each(var data:Object in Data.GAME_PARAM.players){
				var oid:int = data[0];
				var bitmap:Bitmap = GraphicManager.getInstance().getGraphic(Data.OBJECT[oid].small);
				_statusBar.graphic["status"+i].faceClip.addChild(BitmapTo.Clone(bitmap));
				i++;
			}
		}
		//------- On Key Up -------------------------------
		private function onKeyUp($evt:KeyboardEvent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			var keyReleased:String = KeyCode.GetKey($evt.keyCode); 
			if(KeyCode.GetKey($evt.keyCode)=="F1"){
				MyGame.Pause();
			}else if($evt.keyCode == KeyCode.ESC){
				_reset();
				_menuComponent.gotoAndStop(2);
				_finiteStateMachine.changeStateByName("GameMenu");
			}else if(KeyCode.GetKey($evt.keyCode)=="F5"){
				if(_player1)	_player1.status.resetLife();
				if(_player2)	_player2.status.resetLife();
			}else if(KeyCode.GetKey($evt.keyCode)=="F6"){
				if(_player1)	_player1.status.resetMp();
				if(_player2)	_player2.status.resetMp();
			}else if(KeyCode.GetKey($evt.keyCode)=="F7"){
				if(_player1)	_player1.status.reset();
				if(_player2)	_player2.status.reset();
			}else if(_summary && ($evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A)){
				MyGame.Pause(true);
				_startTime = Time.GetTime();
				_summary.destroy();
				_summary = null;
				_deadPlayer = 0;
				for each(var player:LFE_ObjectComponent in _players){
					player.status.reset();
					player.moveTo(Math.random()*600,300+Math.random()*100);
				}
			}else if(_summary && ($evt.keyCode == KeyConfig.Player1.J || $evt.keyCode == KeyConfig.Player2.J)){
				MyGame.Pause(true);
				_reset();
				_menuComponent.gotoAndStop(4);
				_finiteStateMachine.changeStateByName("CharacterSelection");
			}
		}
		//------ Reset ------------------------------------
		private  function _reset():void {
			for each (var component:Component in _list){
				component.destroy();
			}
			var components:Vector.<Component> = _entityManager.getComponentsFromFamily(LFE_ObjectComponent);
			for each (component in components){
				component.destroy();
			}
			_list=new Array();
			_deadPlayer=0;
			if(_summary){
				_summary.destroy();
				_summary = null;
			}	
		}
		//------ Update ------------------------------------
		public function onPlayerDead($evt:Event):void {
			_deadPlayer++;
			if(_deadPlayer==_nbPlayer-1)
				setTimeout(_showSummary,1000);
		}
		//------ Show Summary ------------------------------------
		private function _showSummary():void {
			if(!_summary){
				MyGame.Pause(true);
				_summary=_entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","mySummaryClip") as GraphicComponent;
				_summary.graphic = new SummaryClipUI;
				_summary.graphic.top.summaryTF.text = _lang.Summary.summaryTF;
				_summary.graphic.top.playerTF.text = _lang.Summary.playerTF;
				_summary.graphic.top.killTF.text = _lang.Summary.killTF;
				_summary.graphic.top.attackTF.text = _lang.Summary.attackTF;
				_summary.graphic.top.hpLostTF.text = _lang.Summary.hpLostTF;
				_summary.graphic.top.mpUsageTF.text = _lang.Summary.mpUsageTF;
				_summary.graphic.top.pickingTF.text = _lang.Summary.pickingTF;
				_summary.graphic.top.statusTF.text = _lang.Summary.statusTF;
				_summary.graphic.bottom.pressTF.text = _lang.Summary.pressTF;
				var time:Number = Time.GetTime()-_startTime;
				_summary.graphic.bottom.timeValueTF.text = Time.extractMinutes(time)+":"+Time.extractSecondes(time);
				var bitmap:Bitmap = GraphicManager.getInstance().getGraphic(Data.OBJECT[1].small);
				for(var i:int=1;i<=8;i++){
					if(i<=2){
						var clip:DisplayObject = _summary.graphic["middle"+i].addChild(BitmapTo.Clone(bitmap));
						clip.x+=10;
						_summary.graphic["middle"+i].killTF.text=this["_player"+i].status.kill;
						_summary.graphic["middle"+i].attackTF.text=this["_player"+i].status.attack;
						_summary.graphic["middle"+i].hpLostTF.text=this["_player"+i].status.mpMax-this["_player"+i].status.mp;
						//_summary.graphic["middle"+i].mpUsageTF.text=this["_player"+i].status.mpUsage;
						_summary.graphic["middle"+i].pickingTF.text=0;
						if(this["_player"+i].status.life<=0){
							_summary.graphic["middle"+i].statusTF.text="Lose";
						}else{
							_summary.graphic["middle"+i].statusTF.text="Win";
						}
					}
					else{
						_summary.graphic["middle"+i].visible = false;
					}
				}
				_summary.graphic.bottom.y=_summary.graphic.top.y+_summary.graphic.top.height+2*(_summary.graphic.middle1.height-2);
				LayoutUtil.Align(_summary,LayoutUtil.ALIGN_CENTER_CENTER);
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
			}			
			initComponent();
		}
	}
}