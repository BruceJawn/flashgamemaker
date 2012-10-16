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
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.component.core.GraphicComponent;
	import framework.component.core.KeyboardInputComponent;
	import framework.entity.*;
	
	import utils.keyboard.KeyCode;
	import utils.mouse.MousePad;
	import utils.richardlord.*;

	/**
	 * Control Settings
	 */
	public class ControlSettings extends State implements IState{
		
		private var _entityManager:IEntityManager	= null;
		private var _menuComponent:GraphicComponent = null;
		private var _list:Array = null;
		private var _keyInput:KeyboardInputComponent;
		
		public function ControlSettings(){
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager=EntityManager.getInstance();
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			_menuComponent.setButton(_menuComponent.graphic.configOkBt, {onMouseClick:onOkBtClick},"configOkBt");
			_menuComponent.setButton(_menuComponent.graphic.configCancelBt, {onMouseClick:onCancelBtClick},"configCancelBt");
			_list = new Array();
			_list.push(_menuComponent.graphic.firstPlayerUpTF);
			_list.push(_menuComponent.graphic.firstPlayerDownTF);
			_list.push(_menuComponent.graphic.firstPlayerLeftTF);
			_list.push(_menuComponent.graphic.firstPlayerRightTF);
			_list.push(_menuComponent.graphic.firstPlayerAttackTF);
			_list.push(_menuComponent.graphic.firstPlayerJumpTF);
			_list.push(_menuComponent.graphic.firstPlayerDefenseTF);
			_list.push(_menuComponent.graphic.secondPlayerUpTF);
			_list.push(_menuComponent.graphic.secondPlayerDownTF);
			_list.push(_menuComponent.graphic.secondPlayerLeftTF);
			_list.push(_menuComponent.graphic.secondPlayerRightTF);
			_list.push(_menuComponent.graphic.secondPlayerAttackTF);
			_list.push(_menuComponent.graphic.secondPlayerJumpTF);
			_list.push(_menuComponent.graphic.secondPlayerDefenseTF);
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			_keyInput = _entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			
		}
		//------ Init Restrictions ------------------------------------
		private function _initRestrictions():void {
			var textFormat:TextFormat = new TextFormat("Arial",14,0x000000,true);
			for each(var textField:TextField in _list){
				textField.restrict = "^a-z";
				textField.setTextFormat( textFormat);
			}
		}
		//------ Init Key Listener ------------------------------------
		private function _initKeyListener():void {
			_keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
		}
		//------ Remove Key Listener ------------------------------------
		private function _removeKeyListener():void {
			_keyInput.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyFire);
		}
		//------ Init Keys ------------------------------------
		private function _initKeys():void {
			_menuComponent.graphic.firstPlayerUpTF.text = KeyCode.GetKey(KeyConfig.Player1.UP);
			_menuComponent.graphic.firstPlayerDownTF.text = KeyCode.GetKey(KeyConfig.Player1.DOWN);
			_menuComponent.graphic.firstPlayerLeftTF.text = KeyCode.GetKey(KeyConfig.Player1.LEFT);
			_menuComponent.graphic.firstPlayerRightTF.text = KeyCode.GetKey(KeyConfig.Player1.RIGHT);
			_menuComponent.graphic.firstPlayerAttackTF.text = KeyCode.GetKey(KeyConfig.Player1.A);
			_menuComponent.graphic.firstPlayerJumpTF.text = KeyCode.GetKey(KeyConfig.Player1.J);
			_menuComponent.graphic.firstPlayerDefenseTF.text = KeyCode.GetKey(KeyConfig.Player1.D);
			
			/*_menuComponent.graphic.secondPlayerUpTF.text = KeyCode.GetKey(KeyConfig.Player2.UP);
			_menuComponent.graphic.secondPlayerDownTF.text = KeyCode.GetKey(KeyConfig.Player2.DOWN);
			_menuComponent.graphic.secondPlayerLeftTF.text = KeyCode.GetKey(KeyConfig.Player2.LEFT);
			_menuComponent.graphic.secondPlayerRightTF.text = KeyCode.GetKey(KeyConfig.Player2.RIGHT);
			_menuComponent.graphic.secondPlayerAttackTF.text = KeyCode.GetKey(KeyConfig.Player2.A);
			_menuComponent.graphic.secondPlayerJumpTF.text = KeyCode.GetKey(KeyConfig.Player2.J);
			_menuComponent.graphic.secondPlayerDefenseTF.text = KeyCode.GetKey(KeyConfig.Player2.D);*/
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop(1);
				_finiteStateMachine.goToPreviousState();
			}else if($evt.keyCode == KeyCode.ENTER || $evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A ){
				var index:int= _menuComponent.graphic.focusClip.currentFrame;
				if(index==1)			onOkBtClick(null);
				if(index==2)			onCancelBtClick(null);
			}else if($evt.keyCode == KeyCode.RIGHT || $evt.keyCode == KeyConfig.Player1.RIGHT || $evt.keyCode == KeyConfig.Player2.RIGHT ){
				_menuComponent.graphic.focusClip.nextFrame();
			}else if($evt.keyCode == KeyCode.LEFT || $evt.keyCode == KeyConfig.Player1.LEFT || $evt.keyCode == KeyConfig.Player2.LEFT ){
				_menuComponent.graphic.focusClip.prevFrame();
			}
		}
		//------ On Ok Bt Click ------------------------------------
		private function onOkBtClick($mousePad:MousePad):void {
			_saveKeys();
			_menuComponent.gotoAndStop(1);
			_finiteStateMachine.goToPreviousState();
		}
		//------ Save Keys ------------------------------------
		private function _saveKeys():void {
			KeyConfig.Player1.UP = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerUpTF.text);
			KeyConfig.Player1.DOWN = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerDownTF.text);
			KeyConfig.Player1.LEFT = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerLeftTF.text);
			KeyConfig.Player1.RIGHT = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerRightTF.text);
			KeyConfig.Player1.A = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerAttackTF.text);
			KeyConfig.Player1.J = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerJumpTF.text);
			KeyConfig.Player1.D = KeyCode.GetKeyCode(_menuComponent.graphic.firstPlayerDefenseTF.text);
			
			/*KeyConfig.Player2.UP = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerUpTF.text);
			KeyConfig.Player2.DOWN = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerDownTF.text);
			KeyConfig.Player2.LEFT = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerLeftTF.text);
			KeyConfig.Player2.RIGHT = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerRightTF.text);
			KeyConfig.Player2.A = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerAttackTF.text);
			KeyConfig.Player2.J = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerJumpTF.text);
			KeyConfig.Player2.D = KeyCode.GetKeyCode(_menuComponent.graphic.secondPlayerDefenseTF.text);*/
		}
		//------ On Cancel Bt Click ------------------------------------
		private function onCancelBtClick($mousePad:MousePad):void {
			_menuComponent.gotoAndStop(1);
			_finiteStateMachine.goToPreviousState();
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				_initVar();
				_initComponent();
			}
			_initKeyListener();
			_initKeys();
			_initRestrictions();
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
			_removeKeyListener();
		}
	}
}