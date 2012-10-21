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
package screens{
	import com.adobe.serialization.json.JSON;
	
	import data.Data;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.ISoundManager;
	import framework.system.MouseManager;
	import framework.system.RessourceManager;
	import framework.system.SoundManager;
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.movieclip.Frame;
	import utils.popforge.WavURLPlayer;
	import utils.richardlord.*;
	import utils.ui.LayoutUtil;

	/**
	 * User Interface
	 */
	public class UInterface extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent=null;
		private var _soundManager:ISoundManager=null;
		private var _mainMusic:String;
		private var _keyInput:KeyboardInputComponent;
		private var _lang:Object = null;
		
		public function UInterface(){
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager=EntityManager.getInstance();
			_soundManager = SoundManager.getInstance();
			_mainMusic = LittleFighterEvo.ROOT+"assets/main.mp3"
		}
		//------ Start Music ------------------------------------
		private function _startMusic():void {
			//_soundManager.play(_mainMusic,0.01,true);
		}
		//------ Stop Music ------------------------------------
		private function _stopMusic():void {
			_soundManager.stop(_mainMusic);
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName("LittleFighterEvo","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			_keyInput=_entityManager.addComponentFromName("LittleFighterEvo","KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			_menuComponent = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myMenu") as GraphicComponent;
			_menuComponent.graphic = new MenuUI as MovieClip;
		}
		//------ Init Listener ------------------------------------
		private function _initListener():void {
			SimpleButton(_menuComponent.graphic.gameStartBt).addEventListener(MouseEvent.CLICK, _onStartBtClick,false,0,true);
			SimpleButton(_menuComponent.graphic.controlSettingsBt).addEventListener(MouseEvent.CLICK, _onControlSettingsBtClick,false,0,true);
			SimpleButton(_menuComponent.graphic.demoBt).addEventListener(MouseEvent.CLICK, _onDemoBtClick,false,0,true);
			SimpleButton(_menuComponent.graphic.frBt).addEventListener(MouseEvent.CLICK, _onFrBtClick,false,0,true);
			SimpleButton(_menuComponent.graphic.engBt).addEventListener(MouseEvent.CLICK, _onEngBtClick,false,0,true);
		}
		//------ On Start Bt Click ------------------------------------
		private function _onStartBtClick($evt:MouseEvent):void {
			Framework.Focus();
			_menuComponent.gotoAndStop(2);
			//_finiteStateMachine.changeStateByName("StageGame");
			_finiteStateMachine.changeStateByName("GameMenu");
		}
		//------ On Control Settings Bt Click ------------------------------------
		private function _onControlSettingsBtClick($evt:MouseEvent):void {
			Framework.Focus();
			_menuComponent.gotoAndStop(3);
			_finiteStateMachine.changeStateByName("ControlSettings");
		}
		//------ On Control Settings Bt Click ------------------------------------
		private function _onDemoBtClick($evt:MouseEvent):void {
			Framework.Focus();
			_menuComponent.gotoAndStop(5);
			_finiteStateMachine.changeStateByName("Demo");
		}
		//------ On Control Settings Bt Click ------------------------------------
		private function _onFrBtClick($evt:MouseEvent):void {
			Framework.Focus();
			Data.LOCAL_LANG="fr";
			_upateLang();
		}
		//------ On Control Settings Bt Click ------------------------------------
		private function _onEngBtClick($evt:MouseEvent):void {
			Framework.Focus();
			Data.LOCAL_LANG="eng";
			_upateLang();
		}
		//------ On Key Fire ------------------------------------
		private function _onKeyFire($evt:KeyboardEvent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			if($evt.keyCode == KeyCode.ENTER || $evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A ){
				var index:int= _menuComponent.graphic.focusClip.currentFrame;
				if(index==1)			_onStartBtClick(null);
				else if(index==2)		_onControlSettingsBtClick(null);
				else if(index==3)		_onDemoBtClick(null);
			}else if($evt.keyCode == KeyCode.DOWN || $evt.keyCode == KeyConfig.Player1.DOWN || $evt.keyCode == KeyConfig.Player2.DOWN ){
				_menuComponent.graphic.focusClip.nextFrame();
			}else if($evt.keyCode == KeyCode.UP || $evt.keyCode == KeyConfig.Player1.UP || $evt.keyCode == KeyConfig.Player2.UP ){
				_menuComponent.graphic.focusClip.prevFrame();
			}
		}
		//------ Init Component ------------------------------------
		private function _initKeyConfig():void {
			var dataString:String = RessourceManager.getInstance().getFile(Data.OTHERS.keyConfig);
			//var dataJSON:Object = JSON.parse(dataString);//Flash 11
			var dataJSON:Object = JSON.decode(dataString);//Flash 10
			KeyConfig.Player1 = dataJSON.player1;
			KeyConfig.Player2 = dataJSON.player2;
		}
		//------ Init MultiLang ------------------------------------
		private function _initMultiLang():void {
			var dataString:String = RessourceManager.getInstance().getFile(Data.OTHERS.multilang);
			//var dataJSON:Object = JSON.parse(dataString);//Flash 11
			var dataJSON:Object = JSON.decode(dataString);//Flash 10
			MultiLang.data = dataJSON;
			_lang= MultiLang.data[Data.LOCAL_LANG].Uinterface;
		}
		//------ Init Key Listener ------------------------------------
		private function _initKeyListener():void {
			_keyInput.addEventListener(KeyboardEvent.KEY_DOWN,_onKeyFire,false,0,true);
			_keyInput.startListening();
		}
		//------ Remove Key Listener ------------------------------------
		private function _removeKeyListener():void {
			_keyInput.removeEventListener(KeyboardEvent.KEY_DOWN,_onKeyFire);
		}
		//------ Update Lang ------------------------------------
		private function _upateLang():void {
			_lang= MultiLang.data[Data.LOCAL_LANG].Uinterface;
			TextField(_menuComponent.graphic.licenseTF).htmlText = _lang.licenseTF;
			TextField(_menuComponent.graphic.clickTF).htmlText = _lang.clickTF;
			_upateButtonTF(_menuComponent.graphic.gameStartBt,_lang.gameStartBt);
			_upateButtonTF(_menuComponent.graphic.controlSettingsBt,_lang.controlSettingsBt);
			_upateButtonTF(_menuComponent.graphic.demoBt,_lang.demoBt);
		}
		//------ Update Lang ------------------------------------
		private function _upateButtonTF($button:SimpleButton, $text:String):void {
			TextField($button.upState).text=$text;
			TextField($button.overState).text=$text;
			TextField($button.downState).text=$text;
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				_initVar();
				_initComponent();
				_initKeyConfig();
				_initMultiLang();
				_startMusic();
			}
			_initListener();
			_initKeyListener();
			_upateLang();
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
			_stopMusic();
			_removeKeyListener();
		}
	}
}