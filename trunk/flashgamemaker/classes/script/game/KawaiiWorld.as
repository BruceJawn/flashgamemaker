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
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;

	/**
	* Script Class
	*
	*/
	public class KawaiiWorld {

		private var _scriptName:String = null;
		private var _entityManager:IEntityManager=null;
		
		public function KawaiiWorld() {
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
			var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var spatialComponent:SpatialComponent=_entityManager.addComponent("GameEntity","SpatialComponent","mySpatialComponent");
			var renderComponent:RenderComponent=_entityManager.addComponent("GameEntity","RenderComponent","myRenderComponent");
			var systemInfoComponent:SystemInfoComponent = _entityManager.addComponent("GameEntity", "SystemInfoComponent", "mySystInfoComponent");
			systemInfoComponent.moveTo(25,0);
			var loadingComponent:LoadingComponent=_entityManager.addComponent("GameEntity","LoadingComponent","myLoadingComponent");
			loadingComponent.preloadGraphic("xml/framework/game/textureKawaii.xml","TextureKawaii");
			loadingComponent.loadGraphic("texture/framework/game/interface/bladesquad/loadingBar.swf","LoadingBar");
			loadingComponent.addEventListener(Event.COMPLETE, onLoadingSuccessful);
		}
		//------ On Loading Successfull ------------------------------------
		private function onLoadingSuccessful(evt:Event):void {
			_entityManager.removeComponent("GameEntity","myLoadingComponent");
			createBackground();
			createLogin();
		}
		//------- Creat Background -------------------------------
		public function createBackground():void {
			var bg:GraphicComponent =_entityManager. addComponent("GameEntity","GraphicComponent","myBG");
			bg.setGraphicFromName("bg");
		}
		//------- CreatLogin -------------------------------
		public function createLogin():void {
			var loginScreen:GraphicComponent =_entityManager. addComponent("GameEntity","GraphicComponent","myLoginScreen");
			loginScreen.setGraphicFromName("loginScreen");
			loginScreen.center();
			loginScreen._graphic.loginText.addEventListener(MouseEvent.CLICK, onTextClick);
			loginScreen._graphic.passwordText.addEventListener(MouseEvent.CLICK, onTextClick);
			loginScreen._graphic.square.tick.mouseEnabled=false;
			loginScreen._graphic.square.addEventListener(MouseEvent.CLICK, onSquareClick);
			loginScreen._graphic.startBt.addEventListener(MouseEvent.CLICK, onStartClick);
		}
		//------ On Text Click ------------------------------------
		private function onTextClick(evt:MouseEvent):void {
			if(evt.target.text=="Login" || evt.target.text=="*******"){
				evt.target.text="";
			}
		}
		//------ On Square Click ------------------------------------
		private function onSquareClick(evt:MouseEvent):void {
			if(evt.target.tick.alpha==100){
				evt.target.tick.alpha=0;
			}else{
				evt.target.tick.alpha=100;
			}
		}
		//------ On Start Click ------------------------------------
		private function onStartClick(evt:MouseEvent):void {
			var loginScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myLoginScreen");
			loginScreen._graphic.loginText.removeEventListener(MouseEvent.CLICK, onTextClick);
			loginScreen._graphic.passwordText.removeEventListener(MouseEvent.CLICK, onTextClick);
			loginScreen._graphic.square.removeEventListener(MouseEvent.CLICK, onSquareClick);
			loginScreen._graphic.startBt.removeEventListener(MouseEvent.CLICK, onStartClick);
			_entityManager.removeComponent("GameEntity","myLoginScreen");
			var customizeScreen:GraphicComponent =_entityManager.addComponent("GameEntity","GraphicComponent","myCustomizeScreen");
			customizeScreen.setGraphicFromName("customizeScreen");
			customizeScreen.center();
			customizeScreen._graphic.nameText.addEventListener(MouseEvent.CLICK, onTextClick);
			customizeScreen._graphic.nextBt.addEventListener(MouseEvent.CLICK, onNextClick);
			customizeScreen._graphic.maleBt.addEventListener(MouseEvent.CLICK, onMaleClick);
			customizeScreen._graphic.femaleBt.addEventListener(MouseEvent.CLICK, onFemaleClick);
			customizeScreen._graphic.customClip.colorClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			customizeScreen._graphic.customClip.skinButton.addEventListener(MouseEvent.CLICK, onSkinButtonClick);
			customizeScreen._graphic.customClip.nappyButton.addEventListener(MouseEvent.CLICK, onNappyButtonClick);
			customizeScreen._graphic.customClip.glovesButton.addEventListener(MouseEvent.CLICK, onGlovesButtonClick);
			customizeScreen._graphic.customClip.shoesButton.addEventListener(MouseEvent.CLICK, onShoesButtonClick);
			customizeScreen._graphic.customClip.hairButton.addEventListener(MouseEvent.CLICK, onHairButtonClick);
			var swfPlayerComponent:SwfPlayerComponent=_entityManager.addComponent("GameEntity","SwfPlayerComponent","myBebeComponent");
			swfPlayerComponent.addEventListener(Event.COMPLETE, onBebeComplete);
			swfPlayerComponent.setGraphicFromName("bebeClip",2);
			swfPlayerComponent.moveTo(250,300);
			swfPlayerComponent.scale(2,2);
			swfPlayerComponent.filters = [new GlowFilter(0, .75, 2, 2, 2, BitmapFilterQuality.LOW, false, false)];

		}
		//------ On Bebe Complete ------------------------------------
		private function onBebeComplete(evt:Event):void {
			evt.currentTarget.addGraphicFromName("bebeVisage", "Head",2);
			evt.currentTarget.addGraphicFromName("bebeHair", "Head",2);
		}
		//------ On Male Click ------------------------------------
		private function onMaleClick(evt:MouseEvent):void {
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			swfPlayerComponent.clipWithNameGoTo("bebeVisage","Head",1);
		}
		//------ On Female Click ------------------------------------
		private function onFemaleClick(evt:MouseEvent):void {
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			swfPlayerComponent.clipWithNameGoTo("bebeVisage","Head",2);
		}
		//------ On Color Clip Click ------------------------------------
		private function onColorClipClick(evt:MouseEvent):void {
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			if(customizeScreen._graphic.customClip.currentFrame==1){
				var colorClip:MovieClip = customizeScreen._graphic.customClip.colorClip;
				var colorBitmapData:BitmapData =new BitmapData(colorClip.width,colorClip.height);
				colorBitmapData.draw(colorClip);
				var hexColor:String=colorBitmapData.getPixel(colorClip.mouseX,colorClip.mouseY).toString(16);
				swfPlayerComponent.changeClipColor(swfPlayerComponent._source,hexColor,"skin");
				swfPlayerComponent.changeClipColor(swfPlayerComponent._graphic,hexColor,"skin");
			}else{
				colorClip=customizeScreen._graphic.customClip.colorPickerClip;
				colorBitmapData=new BitmapData(colorClip.width,colorClip.height);
				colorBitmapData.draw(colorClip);
				hexColor=colorBitmapData.getPixel(colorClip.mouseX,colorClip.mouseY).toString(16);
				if(customizeScreen._graphic.customClip.currentFrame==2){
					var clipName:String="couche";
				}else if(customizeScreen._graphic.customClip.currentFrame==3){
					clipName="gant";
				}else if(customizeScreen._graphic.customClip.currentFrame==4){
					clipName="pied";
				}else if(customizeScreen._graphic.customClip.currentFrame==5){
					clipName="cheveux";
				}
				swfPlayerComponent.changeClipColor(swfPlayerComponent._source,hexColor,clipName);
				swfPlayerComponent.changeClipColor(swfPlayerComponent._graphic,hexColor,clipName);
			}
		}
		//------ On Skin Button Click ------------------------------------
		private function onSkinButtonClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.customClip.gotoAndStop(1);
			if(!customizeScreen._graphic.customClip.colorClip.hasEventListener(MouseEvent.CLICK)){
			   customizeScreen._graphic.customClip.colorClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			}
		}
		//------ On Skin Button Click ------------------------------------
		private function onNappyButtonClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.customClip.gotoAndStop(2);
			if(!customizeScreen._graphic.customClip.colorPickerClip.hasEventListener(MouseEvent.CLICK)){
			   customizeScreen._graphic.customClip.colorPickerClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			}
		}
		//------ On Skin Button Click ------------------------------------
		private function onGlovesButtonClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.customClip.gotoAndStop(3);
			if(!customizeScreen._graphic.customClip.colorPickerClip.hasEventListener(MouseEvent.CLICK)){
			   customizeScreen._graphic.customClip.colorPickerClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			}
		}
		//------ On Skin Button Click ------------------------------------
		private function onShoesButtonClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.customClip.gotoAndStop(4);
			if(!customizeScreen._graphic.customClip.colorPickerClip.hasEventListener(MouseEvent.CLICK)){
			   customizeScreen._graphic.customClip.colorPickerClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			  }
		}
		//------ On Skin Button Click ------------------------------------
		private function onHairButtonClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.customClip.gotoAndStop(5);
			if(!customizeScreen._graphic.customClip.colorPickerClip.hasEventListener(MouseEvent.CLICK)){
			   customizeScreen._graphic.customClip.colorPickerClip.addEventListener(MouseEvent.CLICK, onColorClipClick);
			  }
			 customizeScreen._graphic.customClip.nextButton.addEventListener(MouseEvent.CLICK, onHairButtonNextClick);
			 customizeScreen._graphic.customClip.prevButton.addEventListener(MouseEvent.CLICK, onHairButtonPrevClick);
			
		}
		//------ On Next Click ------------------------------------
		private function onNextClick(evt:MouseEvent):void {
			var customizeScreen:GraphicComponent =_entityManager.getComponent("GameEntity","myCustomizeScreen");
			customizeScreen._graphic.nameText.removeEventListener(MouseEvent.CLICK, onTextClick);
			customizeScreen._graphic.nextBt.removeEventListener(MouseEvent.CLICK, onNextClick);
			_entityManager.removeComponent("GameEntity","myCustomizeScreen");
			var statutBar:GraphicComponent=_entityManager.addComponent("GameEntity","GraphicComponent","myStatutBarComponent");
			statutBar.setGraphicFromName("statutClip");
			statutBar.moveTo(560,30);
			var messageClip:MessageComponent=_entityManager.addComponent("GameEntity","MessageComponent","myMessageClipComponent");
			messageClip.setGraphicFromName("messageClip");
			messageClip.moveTo(50,460);
			var backgroundComponent:ScrollingBitmapComponent=_entityManager.addComponent("GameEntity","ScrollingBitmapComponent","myBackgroundComponent");
			backgroundComponent.setGraphicFromName("canvas");
			backgroundComponent.moveTo(40,60);
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			//keyboardMoveComponent.setMode("4DirIso");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			animationComponent.setMode("4Dir");
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			swfPlayerComponent.setPropertyReference("keyboardMove",swfPlayerComponent._componentName);
			swfPlayerComponent.moveTo(100,150);
			swfPlayerComponent.scale(1,1);
			var tileMapComponent:TileMapComponent=_entityManager.addComponent("GameEntity","TileMapComponent","myTileMapComponent");
			tileMapComponent.loadMap("xml/framework/game/map.xml", "TileMap");
			tileMapComponent.setPropertyReference("tileMapEditor",tileMapComponent._componentName);
			tileMapComponent.setPropertyReference("tileMapCamera",tileMapComponent._componentName);
			tileMapComponent.setMask(60,80,490,335);
			tileMapComponent.moveTo(0,150);
			var tileMapCameraComponent:TileMapCameraComponent=_entityManager.addComponent("GameEntity","TileMapCameraComponent","myTileMapCameraComponent");
			tileMapCameraComponent.setSpeed(4, 2, 1);
			var tileMapEditorComponent:TileMapEditorComponent=_entityManager.addComponent("GameEntity","TileMapEditorComponent","myTileMapEditorComponent");
			tileMapEditorComponent.moveTool(15,30);
			tileMapEditorComponent.moveOption(100,260);
			tileMapEditorComponent.movePanel(200,60);
			FlashGameMaker.Focus();
		}
		//------ On Next Click ------------------------------------
		private function onHairButtonNextClick(evt:MouseEvent):void {
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			var frame:int=swfPlayerComponent._source.clip1.Head.getChildByName("bebeHair").currentFrame;
			var totalFrame:int=swfPlayerComponent._source.clip1.Head.getChildByName("bebeHair").totalFrames;
			if(frame<totalFrame){
				frame++;
			}
			swfPlayerComponent.clipWithNameGoTo("bebeHair","Head",frame);
		}
		//------ On Prev Click ------------------------------------
		private function onHairButtonPrevClick(evt:MouseEvent):void {
			var swfPlayerComponent:SwfPlayerComponent =_entityManager.getComponent("GameEntity","myBebeComponent");
			var frame:int=swfPlayerComponent._source.clip1.Head.getChildByName("bebeHair").currentFrame;
			if(frame>0){
				frame--;
			}
			swfPlayerComponent.clipWithNameGoTo("bebeHair","Head",frame);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}