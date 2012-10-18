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
	import data.Data;
	
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import framework.component.core.GraphicComponent;
	import framework.component.core.KeyboardInputComponent;
	import framework.entity.EntityManager;
	import framework.entity.IEntityManager;
	
	import utils.keyboard.KeyCode;
	import utils.mouse.MousePad;
	import utils.richardlord.*;

	/**
	 * Game Menu
	 */
	public class GameMenu extends State implements IState{
		
		private var _entityManager:IEntityManager	= null;
		private var _menuComponent:GraphicComponent = null;
		private var _keyInput:KeyboardInputComponent;
		
		public function GameMenu(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			SimpleButton(_menuComponent.graphic.stageModeBt).mouseEnabled=false;
			SimpleButton(_menuComponent.graphic.survivalModeBt).mouseEnabled=false;
			SimpleButton(_menuComponent.graphic.onevsonechampionshipBt).mouseEnabled=false;
			SimpleButton(_menuComponent.graphic.twovstwochampionshipBt).mouseEnabled=false;
			//_menuComponent.setButton(_menuComponent.graphic.stageModeBt, {onMouseClick:onStageModeBtClick},"stageModeBt");
			//_menuComponent.setButton(_menuComponent.graphic.survivalModeBt, {onMouseClick:onSurvivalModeBtClick},"survivalModeBt");
		}
		//------ Init Listener ------------------------------------
		private function _initListener():void {
			SimpleButton(_menuComponent.graphic.vsModeBt).addEventListener(MouseEvent.CLICK, _onVsModeBtClick,false,0,true);
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			_keyInput=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop(1);
				_finiteStateMachine.changeStateByName("UInterface");
			}else if($evt.keyCode == KeyCode.ENTER || $evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A ){
				var index:int= _menuComponent.graphic.focusClip.currentFrame;
				if(index==1)			_onVsModeBtClick(null);
			}else if($evt.keyCode == KeyCode.DOWN || $evt.keyCode == KeyConfig.Player1.DOWN || $evt.keyCode == KeyConfig.Player2.DOWN ){
				_menuComponent.graphic.focusClip.nextFrame();
			}else if($evt.keyCode == KeyCode.UP || $evt.keyCode == KeyConfig.Player1.UP || $evt.keyCode == KeyConfig.Player2.UP ){
				_menuComponent.graphic.focusClip.prevFrame();
			}
		}
		//------ On VS Mode Bt Click ------------------------------------
		private function _onVsModeBtClick($evt:MouseEvent):void {
			_menuComponent.gotoAndStop(4);
			_finiteStateMachine.changeStateByName("CharacterSelection",null,"VsGame");
		}
		//------ On Stage Mode Bt Click ------------------------------------
		private function _onStageModeBtClick($evt:MouseEvent):void {
			_menuComponent.gotoAndStop(5);
			_finiteStateMachine.changeStateByName("CharacterSelection",null,"StageGame");
		}
		//------ On Survival Mode Bt Click ------------------------------------
		private function _onSurvivalModeBtClick($evt:MouseEvent):void {
			_menuComponent.gotoAndStop(5);
			_finiteStateMachine.changeStateByName("CharacterSelection",null,"SurvivalGame");
		}
		//------ Init Key Listener ------------------------------------
		private function _initKeyListener():void {
			_keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
		}
		//------ Remove Key Listener ------------------------------------
		private function _removeKeyListener():void {
			_keyInput.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyFire);
		}
		//------ Update Lang ------------------------------------
		private function _upateLang():void {
			_upateButtonTF(_menuComponent.graphic.vsModeBt,MultiLang.data[Data.LOCAL_LANG].GameMenu.vsModeBt);
		}
		//------ Update Lang ------------------------------------
		private function _upateButtonTF($button:SimpleButton, $text:String):void {
			TextField($button.upState).text=$text;
			TextField($button.overState).text=$text;
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
			}
			_initListener();
			_initKeyListener();
			_upateLang();
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
			_removeKeyListener();
		}
	}
}