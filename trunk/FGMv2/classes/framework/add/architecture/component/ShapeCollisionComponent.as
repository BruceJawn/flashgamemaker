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
*    Thanks to Skinner Shaped Based Hit Detection  
*    Grant Skinner 2005
*    http://www.gskinner.com/blog/archives/2005/10/source_code_sha.html
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

package framework.add.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	import utils.skinner.CollisionDetection;

	import flash.geom.Rectangle;
	import flash.display.*;
	/**
	* Shape Collision Component
	*/
	public class ShapeCollisionComponent extends GraphicComponent {

		private var _clip1:* =null;
		private var _clip2:* =null;
		private var _drawin:MovieClip=null;
		private var _collisionRect:Rectangle;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function ShapeCollisionComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_drawin = new MovieClip();
			addChild(_drawin);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("shapeCollision", _componentName);
			setPropertyReference("timer",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay||! _timer_on) {
				checkCollision();
				collisionResponse();
			}
		}
		//------ Check Collision  ------------------------------------
		private function checkCollision():void {
			if (_clip1!=null&&_clip2!=null) {
				_drawin.graphics.clear();
				_collisionRect=CollisionDetection.CheckCollision(_clip1,_clip2);
				if (_collisionRect) {
					_drawin.graphics.beginFill(0x00FF00,20);
					_drawin.graphics.lineStyle(0,0x00FF00,40);
					_drawin.graphics.moveTo(_collisionRect.x,_collisionRect.y);
					_drawin.graphics.lineTo(_collisionRect.x+_collisionRect.width,_collisionRect.y);
					_drawin.graphics.lineTo(_collisionRect.x+_collisionRect.width,_collisionRect.y+_collisionRect.height);
					_drawin.graphics.lineTo(_collisionRect.x,_collisionRect.y+_collisionRect.height);
					_drawin.graphics.lineTo(_collisionRect.x,_collisionRect.y);
				}
			}
		}
		//------ Collision Response  ------------------------------------
		private function collisionResponse():void {
			if (_collisionRect) {
				if (_collisionRect.width<_collisionRect.height) {
					if (_clip1._spatial_position.x<_collisionRect.x) {
						trace("Left",_collisionRect.width);
						_clip1._spatial_position.x-=_collisionRect.width+1;
					} else if (_clip1._spatial_position.x>_collisionRect.x) {
						trace("Right",_collisionRect.width);
						_clip1._spatial_position.x+=_collisionRect.width+1;
					}
				} else {
					if (_clip1._spatial_properties.isFalling && _clip1._spatial_position.y<_collisionRect.y) {
						//trace("down", _clip1._spatial_position.y,_collisionRect.y,_clip1.height,_collisionRect.height);
						_clip1._spatial_position.y=_collisionRect.y-_collisionRect.height-_clip1.height;
						_clip1._spatial_properties.isColliding=true;
						_clip1._spatial_properties.isFalling=false;
					} else if (_clip1._spatial_properties.isJumping && _clip1._spatial_position.y>_collisionRect.y) {
						trace("up",_collisionRect.height);
						_clip1._spatial_position.y+=_collisionRect.height+1;
					}
				}
			}
			else if (_clip1){
				_clip1._spatial_properties.isColliding=false;
				if(_clip1._spatial_jump.z!=0 && !_clip1._spatial_properties.isFalling){
					_clip1._spatial_properties.isMoving=true;
					_clip1._spatial_properties.isFalling=true;
				}
			}
		}
		//------ Set Clip  ------------------------------------
		public function setClip(clip1:Sprite, clip2:Sprite):void {
			_clip1=clip1;
			_clip2=clip2;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}