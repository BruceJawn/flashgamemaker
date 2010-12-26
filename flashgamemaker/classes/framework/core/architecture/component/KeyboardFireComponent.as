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
	import utils.skinner.CollisionDetection;
	import utils.iso.IsoPoint;

	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	* Keyboard Attack Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardFireComponent extends GraphicComponent {

		private var _players:Array=null;
		private var _bullets:Array=null;
		private var _bitmap:Bitmap=null;
		private var _bullet_speed:Point=null;
		private var _bullet_timer:Number=60;
		private var _bullet_width:Number=10;
		private var _bullet_height:Number=20;
		private var _bullet_offsetX:Number=0;
		private var _bullet_offsetY:Number=0;
		//Timer properties
		public var _timer_on:Boolean=true;
		public var _timer_delay:Number=400;
		public var _timer_count:Number=0;

		public function KeyboardFireComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_players=new Array  ;
			_bullets=new Array  ;
			_bullet_speed = new Point(20,20);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("progressBar",_componentName);
			setPropertyReference("timer",_componentName);
			registerProperty("keyboardFire",_componentName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			if (_graphicName!=null) {
				_graphic=getGraphic(_graphicName) as Bitmap;
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_bullet_timer && componentName==_componentName){
				updateBullets();
			}
			if (_timer_count>=_timer_delay||! _timer_on) {
				if (componentName==_componentName) {
					update("keyboardFire");
				} else	if (componentName!=_componentName&& component._keyboard_gamePad!=null) {
					fire(component);
				} 
			}
		}
		//------- Check Attack -------------------------------
		private function fire(component:PlayerComponent):void {
			if (component._keyboard_gamePad.fire1.isDown) {
				createBullet(component);
			}
		}
		//------ CreateBullet ------------------------------------
		private function createBullet(component:PlayerComponent):void {
			if(_graphic!=null){
				var bullet:Sprite=new Sprite;
				bullet.graphics.beginBitmapFill(_graphic.bitmapData);
				bullet.graphics.drawRect(0,0,_bullet_width,_bullet_height);
				bullet.graphics.endFill();
				var bulletX:Number=component.x+component.width/2;
				var bulletY:Number=component.y+component.height/2-_bullet_offsetY;
				var facingDirection:String=component.getFacingDirection();
				var bulletRotation:Number=0;
				if (facingDirection=="RIGHT") {
					bulletX+=_bullet_offsetX;
				} else if (facingDirection=="LEFT") {
					bulletX-=_bullet_offsetX;
				}else if (facingDirection=="DOWN") {
					bulletRotation=90;
				} else if (facingDirection=="UP") {
					bulletRotation=-90;
				}
				bullet.x=bulletX;
				bullet.y=bulletY;
				bullet.rotation=0;
				_bullets.push([bullet,facingDirection,component]);
				addChild(bullet);
			}
		}
		//------ Update Bullet ------------------------------------
		private function updateBullets():void {
			for (var i:int=0; i<_bullets.length;i++){
				if(_bullets[i][1]=="RIGHT"){
					_bullets[i][0].x+=_bullet_speed.x;
				}else if(_bullets[i][1]=="LEFT"){
					_bullets[i][0].x-=_bullet_speed.x;
				}else if(_bullets[i][1]=="DOWN"){
					_bullets[i][0].y-=_bullet_speed.y;
				}else if(_bullets[i][1]=="UP"){
					_bullets[i][0].y+=_bullet_speed.y;
				}
				if(Math.abs(_bullets[i][0].x-_bullets[i][2].x)>FlashGameMaker.WIDTH || Math.abs(_bullets[i][0].y-_bullets[i][2].y)>FlashGameMaker.HEIGHT){
					destrucBullet(i);
					return;
				}
				for each(var component:* in _players){
					var collisionRect:Rectangle=CollisionDetection.CheckCollision(component,_bullets[i][0]);
					if (collisionRect) {
						destrucBullet(i);
						return;
					}
				}
			}
		}
		//------ Destruct Bullet ------------------------------------
		private function destrucBullet(index:int):void {
			if(this.contains(_bullets[index][0])){
				removeChild(_bullets[index][0]);
				_bullets.splice(index,1);
			}
		}
		//------ Set Bullet ------------------------------------
		public function setBullets(offsetX:Number,offsetY:Number,width:Number,height:Number,speed:Point,timer:Number):void {
			_bullet_offsetX=offsetX;
			_bullet_offsetY=offsetY;
			_bullet_width=width;
			_bullet_height=height;
			_bullet_speed=speed;
			_bullet_timer=timer;
		}
		//------- Add Player -------------------------------
		public function addPlayer(component:*):void {
			_players.push(component);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}