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
	import flash.geom.Rectangle;

	/**
	* Keyboard Attack Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardFireComponent extends GraphicComponent {

		private var _players:Array=null;
		private var _bullets:Array=null;
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;

		public function KeyboardFireComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_players=new Array  ;
			_bullets=new Array  ;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardFire",_componentName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,onGraphicLoadingProgress);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName&&_keyboard_gamePad!=null) {
				fire();
			} else if (componentName!=_componentName) {
				addPlayer(component);
			}
		}
		//------- Check Attack -------------------------------
		private function fire():void {
			if (_keyboard_gamePad.fire1.isDown) {
				for each (var playerAttacking:PlayerComponent in _players) {
					createBullet(playerAttacking);
				}
			}
		}
		//------ CreateBullet ------------------------------------
		private function createBullet(playerAttacking:PlayerComponent):void {
			var bullet:ProjectileComponent = addComponent("GameEntity","ProjectileComponent","myProjectileComponent"+_bullets.length);
			var facingDirection:String = playerAttacking.getFacingDirection();
			if(facingDirection=="RIGHT"){
				var beginX:Number= playerAttacking.x+playerAttacking.width/2;
				var beginY:Number=playerAttacking.y+playerAttacking.height/2;
				bullet.loadProjectile("texture/framework/game/fx/bullet.png","Bullet",1,new Rectangle(0,0,20,20),beginX,beginY,beginX+250,beginY,5);
			}else if(facingDirection=="LEFT"){
				beginX= playerAttacking.x-10;
				beginY=playerAttacking.y-playerAttacking.height/2;
				bullet.loadProjectile("texture/framework/game/fx/bullet.png","Bullet",1,new Rectangle(0,0,10,6),beginX,beginY,beginX-250,beginY,5);
			}else if(facingDirection=="DOWN"){
			
			}else if(facingDirection=="UP"){
			
			}
			_bullets.push(bullet);
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