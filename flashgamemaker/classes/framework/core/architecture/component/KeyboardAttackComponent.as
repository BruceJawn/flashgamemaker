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

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.system.KeyboardManager;
	import framework.core.system.IKeyboardManager;
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.text.TextField;

	/**
	* Keyboard Attack Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardAttackComponent extends Component {

		private var _players:Array=null;
		//KeyboardInput properties
		public var _keyboard_key:Object=null;

		public function KeyboardAttackComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_players = new Array();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardAttack",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName&&_keyboard_key!=null) {
				checkAttack();
			} else if (componentName!=_componentName) {
				addPlayer(component);
			}
		}
		//------- Check Attack -------------------------------
		private function checkAttack():void {
			if (_keyboard_key.keyStatut=="DOWN"&&_keyboard_key.keyTouch=="ATTACK") {
				var componentWithProperty:Array=getComponentsWithPropertyName("health");
				for each (var playerAttacking:PlayerComponent in _players) {
					for each (var obj:Object in componentWithProperty) {
						var componentName:String=obj.componentName;
						var ownerName:String=obj.ownerName;
						var playerHit:PlayerComponent=getComponent(ownerName,componentName);
						if(isHit(playerAttacking,playerHit)){
							playerHit._health_hit=playerAttacking._attack;
							refresh("health");
						}
					}
				}
			}
		}
		//------- Is Hi -------------------------------
		private function isHit(playerAttacking:PlayerComponent, playerHit:PlayerComponent):Boolean {
			if (playerAttacking.hitTestObject(playerHit)) {
				return true;
			}
			return false;
		}
		//------- Add Player -------------------------------
		public function addPlayer(playerComponent:PlayerComponent):void {
			for each (var player:PlayerComponent in _players) {
				if (player==playerComponent) {
					return;
				}
			}
			_players.push(playerComponent);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}