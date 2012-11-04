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
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.add.GamePadComponent;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.*;
	
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.loader.SimpleLoader;
	import utils.math.SimpleMath;
	import utils.mouse.MousePad;
	import utils.popforge.WavURLPlayer;
	import utils.richardlord.*;
	import utils.ui.LayoutUtil;

	/**
	 * Game
	 */
	public class Demo extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent = null;
		private var _graphicManager:IGraphicManager = null;
		private var _battleField:ScrollingBitmapComponent = null;
		private var _forests:GraphicComponent = null;
		private var _forestm2:ScrollingBitmapComponent = null;
		private var _forestm3:GraphicComponent = null
		private var _list:Array = null;
		private var _statusBar:GraphicComponent = null;
		private var _deadPlayer:int =0;
		private var _nbPlayer:int =6;
		private var _soundManager:ISoundManager=null;
		private var _mainMusic:String;
		
		public function Demo(){
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			_list=new Array();
			_soundManager = SoundManager.getInstance();
			_mainMusic = LittleFighterEvo.ROOT+"assets/main.mp3";
		}
		//------ Start Music ------------------------------------
		private function _startMusic():void {
			_soundManager.play(_mainMusic,0.1,true);
		}
		//------ Stop Music ------------------------------------
		private function _stopMusic():void {
			_soundManager.stop(_mainMusic);
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("LittleFighterEvo","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var component:Component =_entityManager.addComponentFromName("LittleFighterEvo","Component","myDemoComponent") as Component;
			component.registerPropertyReference("enterFrame", { onEnterFrame:_onEnterFrame } );
			_list.push(component);
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("LittleFighterEvo","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var keyBoardInput:KeyboardInputComponent=_entityManager.addComponentFromName("LittleFighterEvo","KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			keyBoardInput.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("LittleFighterEvo","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			bitmapRenderComponent.scrollEnabled = false;
			Framework.SetChildIndex(bitmapRenderComponent,Framework.numChildren-1);
			var spatialMoveComponent:SpatialMoveComponent=_entityManager.addComponentFromName("LittleFighterEvo","SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var collisionDetectionComponent:CollisionDetectionComponent=_entityManager.addComponentFromName("LittleFighterEvo","CollisionDetectionComponent","myCollisionDetectionComponent") as CollisionDetectionComponent;
			createBattleField();
			createPlayers();
			createWeapons();
			//createStatusBar();
			_list.push(EntityFactory.CreateSystemInfo("SystemInfo",20,462));
		}
		//------ Init Menu Bar ------------------------------------
		private function _initMenuBar():void {
			_menuComponent.graphic.exitBt.addEventListener(MouseEvent.CLICK,_onExitBtClick,false,0,true);
			_menuComponent.graphic.pauseBt.addEventListener(MouseEvent.CLICK,_onPauseBtClick,false,0,true);
			_menuComponent.graphic.f1Bt.addEventListener(MouseEvent.CLICK,_onF1BtClick,false,0,true);
			_menuComponent.graphic.f2Bt.addEventListener(MouseEvent.CLICK,_onF2BtClick,false,0,true);
			_menuComponent.graphic.f3Bt.addEventListener(MouseEvent.CLICK,_onF3BtClick,false,0,true);
			_menuComponent.graphic.f4Bt.addEventListener(MouseEvent.CLICK,_onF4BtClick,false,0,true);
			_menuComponent.graphic.f5Bt.addEventListener(MouseEvent.CLICK,_onF5BtClick,false,0,true);
			_menuComponent.graphic.f6Bt.addEventListener(MouseEvent.CLICK,_onF6BtClick,false,0,true);
			_menuComponent.graphic.f7Bt.addEventListener(MouseEvent.CLICK,_onF7BtClick,false,0,true);
			_menuComponent.graphic.f8Bt.addEventListener(MouseEvent.CLICK,_onF8BtClick,false,0,true);
			_menuComponent.graphic.f9Bt.addEventListener(MouseEvent.CLICK,_onF9BtClick,false,0,true);
		}
		//------- Create Battle Field -------------------------------
		private function createBattleField():void {
			_forests = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myForests",{render:"render"}) as GraphicComponent;
			_forests.graphic = _graphicManager.getGraphic("forests.png") as Bitmap;
			_forests.moveTo(0,20);
			_list.push(_forests);
			
			_forestm2=_entityManager.addComponentFromName("LittleFighterEvo","ScrollingBitmapComponent","myForestsm2",{canvas:{"width":800,"height":600}}) as ScrollingBitmapComponent;
			var bitmaps:Vector.<Bitmap> = new Vector.<Bitmap>()
			bitmaps.push(_graphicManager.getGraphic("forestm1.png") as Bitmap);
			bitmaps.push(_graphicManager.getGraphic("forestm2.png") as Bitmap);
			var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"HORIZONTAL")
			_forestm2.graphic = bitmap;
			_forestm2.moveTo(0,38);
			_list.push(_forestm2);
			
			_forestm3 = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myForestm3",{render:"render"}) as GraphicComponent;
			bitmaps = new Vector.<Bitmap>()
			bitmaps.push(_graphicManager.getGraphic("forestm3.png") as Bitmap);
			bitmaps.push(_graphicManager.getGraphic("forestm4.png") as Bitmap);
			bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"HORIZONTAL",1000)
			_forestm3.graphic =bitmap;
			_forestm3.moveTo(0,70);
			_list.push(_forestm3);
			
			_battleField=_entityManager.addComponentFromName("LittleFighterEvo","ScrollingBitmapComponent","myBattleField",{canvas:{"width":800,"height":600, "repeatX":true, "repeatY":false}}) as ScrollingBitmapComponent;
			_battleField.graphic = _graphicManager.getGraphic("../assets/btf1.png")as Bitmap;
			_battleField.loop=true;
			_battleField.moveTo(0,80);
			_list.push(_battleField);
		}
		//------- Create Players-------------------------------
		private function createPlayers():void {
			var player:LFE_ObjectComponent;
			for (var i:int =0; i<_nbPlayer;i++){
				player = LFE_Object.CreateObject(1,null,new KeyPad);
				player.setAI(true);
				player.moveTo(Math.random()*600,300+Math.random()*100);
				//player.status.unlimitedLife = true;
				//player.status.unlimitedMp = true;
				_list.push(player);
				player.addMiniBar();
				_list.push(player.miniBar);
				player.addEventListener(Event.COMPLETE,onPlayerDead,false,0,true);
			}
		}
		//------- Create Weapons -------------------------------
		private function createWeapons():void {
			//LFE_Object.CreateObject(151,null,null,new IsoPoint(150,330));
			//setTimeout(LFE_Object.CreateObject,1000,100,null,null,new IsoPoint(300,100,30));
			//setTimeout(LFE_Object.CreateObject,2000,101,null,null,new IsoPoint(100,100,30));
			//setTimeout(LFE_Object.CreateObject,3000,121,null,null,new IsoPoint(500,100,30));
		}
		//------- Create Status Bar -------------------------------
		private function createStatusBar():void {
			_statusBar = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myStatusBar") as GraphicComponent;
			_statusBar.graphic = new StatusBarUI as MovieClip;
			var bitmap:Bitmap = GraphicManager.getInstance().getGraphic(Data.OBJECT[1].small);
			_statusBar.graphic.status1.faceClip.addChild(bitmap);
			_statusBar.graphic.status2.faceClip.addChild(bitmap);
			_statusBar.graphic.status3.faceClip.addChild(bitmap);
			_statusBar.graphic.status4.faceClip.addChild(bitmap);
			_statusBar.graphic.status5.faceClip.addChild(bitmap);
			_statusBar.graphic.status6.faceClip.addChild(bitmap);
			_statusBar.graphic.status7.faceClip.addChild(bitmap);
			_statusBar.graphic.status8.faceClip.addChild(bitmap);
		}
		//------- On Key Up -------------------------------
		private function onKeyUp($evt:KeyboardEvent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			var keyReleased:String = KeyCode.GetKey($evt.keyCode); 
			if(KeyCode.GetKey($evt.keyCode)=="PAUSE"){
				MyGame.Pause();
			}else if(KeyCode.GetKey($evt.keyCode)=="Esc"){
				if(MyGame.isPause)	MyGame.Pause();
				_reset();
				_menuComponent.gotoAndStop(1);
				_startMusic();
				_finiteStateMachine.changeStateByName("UInterface",null);
			}else if(KeyCode.GetKey($evt.keyCode)=="F5"){
				for each(var player:Component in _list){
					if(!(player is LFE_ObjectComponent) || player is LFE_ObjectComponent && !LFE_ObjectComponent(player).kind==Data.OBJECT_KIND_CHARACTER)	continue;
					player.status.resetLife();
				}
			}else if(KeyCode.GetKey($evt.keyCode)=="F6"){
				for each(player in _list){
					if(!(player is LFE_ObjectComponent) || player is LFE_ObjectComponent && !LFE_ObjectComponent(player).kind==Data.OBJECT_KIND_CHARACTER)	continue;
					player.status.resetMp();
				}
			}else if(KeyCode.GetKey($evt.keyCode)=="F7"){
				for each(player in _list){
					if(!(player is LFE_ObjectComponent) || player is LFE_ObjectComponent && !LFE_ObjectComponent(player).kind==Data.OBJECT_KIND_CHARACTER)	continue;
					player.status.reset()
					player.moveTo(Math.random()*600,300+Math.random()*100,0);
					player.finisteStateMachine.changeStateByName("Stand");
				}
			}
		}
		//------ On Exit bt Click ------------------------------------
		private function _onExitBtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.ESC));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onPauseBtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.PAUSE));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF1BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F1));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF2BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F2));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF3BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F3));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF4BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F4));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF5BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F5));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF6BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F6));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF7BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F7));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF8BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F8));
		}
		//------ On Pause bt Click ------------------------------------
		private function _onF9BtClick($evt:MouseEvent):void{
			onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,KeyCode.F9));
		}
		//------ Update ------------------------------------
		public function onPlayerDead($evt:Event):void {
			_deadPlayer++;
			if(_deadPlayer==_nbPlayer-1)
				setTimeout(_replay,500);
		}
		//------ Reset ------------------------------------
		private  function _replay():void {
			for each(var player:Component in _list){
				if(!(player is LFE_ObjectComponent))	continue;
				LFE_ObjectComponent(player).moveTo(Math.random()*600,300+Math.random()*100);
				LFE_ObjectComponent(player).status.reset();
				_deadPlayer=0;
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
			Framework.Focus();
			_deadPlayer = 0;
		}
		//------ On Enter Frame ------------------------------------
		private  function _onEnterFrame():void {
			var left:int = 0;
			var right:int = 0;
			var center:int = 0;
			for each(var player:Component in _list){
				if(!(player is LFE_ObjectComponent) || player is LFE_ObjectComponent && !LFE_ObjectComponent(player).kind==Data.OBJECT_KIND_CHARACTER)	continue;
				if(LFE_ObjectComponent(player).status.gotLife){
					if (player.x < 200 && player)			left++;
					else if (player.x > 600)	right++;
					else 						center++;
				}
			}
			if (left > right && left > center) {
				scroll(-4);
			}else if (right > left && right > center) {
				scroll(4);
			}
			left = 0;
			right = 0;
			center = 0;
		}
		//------ Scroll ------------------------------------
		public function scroll($x:Number):void {
			_battleField.speed.x=$x;
			_battleField.scrollH();
			_battleField.speed.x=0;
			for each(var player:Component in _list){
				if(!(player is LFE_ObjectComponent))	continue;
				player.moveTo(player.x-$x,player.y);
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				_initVar();
			}		
			_initComponent();
			_initMenuBar();
		}
	}
}