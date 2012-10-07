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
		
		public function ControlSettings(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyInput:KeyboardInputComponent=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			_menuComponent.setButton(_menuComponent.graphic.configOkBt, {onMouseClick:onOkBtClick});
			_menuComponent.setButton(_menuComponent.graphic.configCancelBt, {onMouseClick:onCancelBtClick});
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop("MENU");
				_finiteStateMachine.goToPreviousState();
			}
		}
		//------ On Ok Bt Click ------------------------------------
		private function onOkBtClick($mousePad:MousePad):void {
			_menuComponent.gotoAndStop("MENU");
			_finiteStateMachine.goToPreviousState();
		}
		//------ On Cancel Bt Click ------------------------------------
		private function onCancelBtClick($mousePad:MousePad):void {
			_menuComponent.gotoAndStop("MENU");
			_finiteStateMachine.goToPreviousState();
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
			}
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
		}
	}
}