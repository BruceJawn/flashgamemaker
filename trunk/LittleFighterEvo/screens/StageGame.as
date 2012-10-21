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
	public class StageGame extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _player1:LFE_ObjectComponent=null;
		private var _player2:LFE_ObjectComponent=null;
		private var _graphicManager:IGraphicManager = null;
		private var _battleField:ScrollingBitmapComponent = null;
		private var _forests:GraphicComponent = null;
		private var _forestm2:ScrollingBitmapComponent = null;
		private var _forestm3:GraphicComponent = null
		private var _pause:PauseComponent = null;
		private var _list:Array = null;
		private var _statusBar:GraphicComponent = null;
		private var _summary:GraphicComponent = null;
		private var _lang:Object = null;
		private var _startTime:Number =0;
		
		public function StageGame(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_list=new Array();
			_startTime = Time.GetTime();
		}
		//------ Init MultiLang ------------------------------------
		private function _initMultiLang():void {
			var dataString:String = RessourceManager.getInstance().getFile(Data.OTHERS.multilang);
			//var dataJSON:Object = JSON.parse(dataString);//Flash 11
			var dataJSON:Object = JSON.decode(dataString);//Flash 10
			MultiLang.data = dataJSON;
			_lang= MultiLang.data[Data.LOCAL_LANG];
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
			createPlayers();
			//createStatusBar();
			createWeapons();
			
			EntityFactory.CreateSystemInfo("SystemInfo",200,462);
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
		//------- Create Players -------------------------------
		private function createPlayers():void {
			var keyPad1:KeyPad = new KeyPad(true);
			keyPad1.useZQSD();
			keyPad1.mapFireButtons(KeyCode.I,KeyCode.O,KeyCode.P,221);
			_player1 = LFE_Object.CreateObject(1,null,keyPad1);
			_player1.registerPropertyReference("keyboardInput");
			_player1.moveTo(0,300);
			_player1.addMiniBar();
			_player1.addEventListener(Event.COMPLETE,onPlayerDead,false,0,true);
			//_player1.setTimeMultiplicator(10);
			_list.push(_player1);
			_list.push(_player1.miniBar);
			_list.push(_player1.playerName);
			var gamePad1:GamePadComponent = EntityFactory.CreateGamePad("GamePad1", 20,395,keyPad1);
			gamePad1.moveFireKeys(400,15);
			gamePad1.hideDirectionKeys();
			gamePad1.button4.visible=false;
			var keyPad2:KeyPad = new KeyPad(true);
			keyPad2.useArrows();
			keyPad2.mapFireButtons(KeyCode.M,KeyCode.PERCENT,KeyCode.STAR,KeyCode.ENTER);
			_player2 = LFE_Object.CreateObject(1,null,keyPad2);
			_player2.registerPropertyReference("keyboardInput");
			_player2.addEventListener(Event.COMPLETE,onPlayerDead,false,0,true);
			//_player2.setAI(true);
			_player2.moveTo(360,340);
			_player2.addMiniBar();
			_list.push(_player2);
			_list.push(_player2.playerName);
			_list.push(_player2.miniBar);
			var gamePad2:GamePadComponent = EntityFactory.CreateGamePad("GamePad2", 400,520,keyPad2);
			
			/*var player:LFE_ObjectComponent;
			for (var i:int =0; i<10;i++){
			player = LFE_Object.CreateObject(1,null,new KeyPad);
			player.setAI(true);
			player.moveTo(Math.random()*600,300+Math.random()*100);
			_list.push(player);
			}*/
		}
		//------- Create Status Bar -------------------------------
		private function createStatusBar():void {
			_statusBar = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myStatusBar") as GraphicComponent;
			_statusBar.graphic = new StatusBarUI as MovieClip;
			var bitmap:Bitmap = GraphicManager.getInstance().getGraphic(Data.OBJECT[1].small);
			_statusBar.graphic.status1.faceClip.addChild(bitmap);
			_statusBar.graphic.status5.visible=false;
			_statusBar.graphic.status6.visible=false;
			_statusBar.graphic.status7.visible=false;
			_statusBar.graphic.status8.visible=false;
		}
		//------- Create Weapons -------------------------------
		private function createWeapons():void {
			//LFE_Object.CreateObject(151,null,null,new IsoPoint(150,330));
			//setTimeout(LFE_Object.CreateObject,1000,100,null,null,new IsoPoint(300,100,30));
			//setTimeout(LFE_Object.CreateObject,2000,101,null,null,new IsoPoint(100,100,30));
			//setTimeout(LFE_Object.CreateObject,3000,121,null,null,new IsoPoint(500,100,30));
		}
		//------- On Key Up -------------------------------
		private function onKeyUp($evt:KeyboardEvent):void {
			var keyReleased:String = KeyCode.GetKey($evt.keyCode); 
			if(KeyCode.GetKey($evt.keyCode)=="F1"){
				MyGame.Pause();
			}else if(KeyCode.GetKey($evt.keyCode)=="F5"){
				if(_player1)	_player1.status.resetLife();
				if(_player2)	_player2.status.resetLife();
			}else if(KeyCode.GetKey($evt.keyCode)=="F6"){
				if(_player1)	_player1.status.resetMp();
				if(_player2)	_player2.status.resetMp();
			}else if(KeyCode.GetKey($evt.keyCode)=="F7"){
				if(_player1)	_player1.status.reset();
				if(_player2)	_player2.status.reset();
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
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				_initMultiLang();
				initComponent();
			}			
		}
		//------ Update ------------------------------------
		public function onPlayerDead($evt:Event):void {
			setTimeout(_showSummary,1000);
		}
		//------ Show Summary ------------------------------------
		private function _showSummary():void {
			if(!_summary){
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
	}
}