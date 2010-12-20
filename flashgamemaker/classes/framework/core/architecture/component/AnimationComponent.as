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
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;

	/**
	* Animation Component 
	* @ purpose: 
	* 
	*/
	public class AnimationComponent extends Component {

		private var _mode:String="2Dir";
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=120;
		public var _timer_count:Number=0;

		public function AnimationComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			setPropertyReference("timer",_componentName);
			registerProperty("animation", _componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName && (_timer_count>=_timer_delay||! _timer_on)) {
				update("animation");
			} else if (componentName!=_componentName && (_timer_count>=_timer_delay||! _timer_on)) {
				updateFrame(componentName,componentOwner,component);
			}
		}
		//-- Update Frame ---------------------------------------------------
		private function updateFrame(componentName:String,componentOwner:String,component:*):void {
			var frame:int=setDirection(component);
			frame=setAnimation(component,frame);
			frame=setFrame(component,frame);
			component._graphic_frame=frame;
			component.actualizeComponent(componentName,componentOwner,component);
		}
		//-- Set Frame ---------------------------------------------------
		public function setDirection(component:*):int {
			var graphic_frame:int=component._graphic_frame;
			var graphic_numFrame:int=component._graphic_numFrame;
			var totalFrame:int=graphic_numFrame*graphic_numFrame;
			var spatial_dir:IsoPoint=component._spatial_dir;

			if (_mode=="2Dir"&&spatial_dir.x==0&&spatial_dir.y!=0) {
				return graphic_frame;
			}
			if ((spatial_dir.x>0 && spatial_dir.y==0 || spatial_dir.x>0 && spatial_dir.y>0) && graphic_frame%totalFrame>graphic_numFrame) {//Right
				graphic_frame=1;
			} else if ((spatial_dir.x<0 && spatial_dir.y==0 || spatial_dir.x<0 && spatial_dir.y<0)&& (graphic_frame%totalFrame<=graphic_numFrame*2||graphic_frame%totalFrame>graphic_numFrame*3 )) {//Left
				graphic_frame=graphic_numFrame*2+1;
			} else if ((spatial_dir.y>0 && spatial_dir.x==0 || spatial_dir.x<0 && spatial_dir.y>0) && (graphic_frame%totalFrame<=graphic_numFrame||graphic_frame%totalFrame>graphic_numFrame*2)) {//Down
				graphic_frame=graphic_numFrame+1;
			} else if ((spatial_dir.y<0 && spatial_dir.x==0 || spatial_dir.x>0 && spatial_dir.y<0)  && graphic_frame%totalFrame<=graphic_numFrame*3) {//Up
				graphic_frame=graphic_numFrame*3+1;
			}
			return graphic_frame;
		}
		//----- Set Animation -----------------------------------
		private function setAnimation(component:*,graphic_frame:int):int {
			var isMoving:Boolean=component._spatial_properties.isMoving;
			var isRunning:Boolean=component._spatial_properties.isRunning;
			var isAttacking:Boolean=component._spatial_properties.isAttacking;
			var isJumping:Boolean=component._spatial_properties.isJumping;
			var isDoubleJumping:Boolean=component._spatial_properties.isDoubleJumping;
			var isFalling:Boolean=component._spatial_properties.isFalling;
			var graphic_numFrame:int=component._graphic_numFrame;
			var animation:Dictionary=component._animation;
			var spatial_dir:IsoPoint=component._spatial_dir;
			var keyboard_gamePad:Object=component._keyboard_gamePad;

			if (isFalling&&animation["JUMP"]!=null&&graphic_frame<animation["JUMP"]*graphic_numFrame*graphic_numFrame) {
				//trace("FALLING");
				graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["JUMP"]*graphic_numFrame*graphic_numFrame;
			} else if (isDoubleJumping && !isFalling&& animation["DOUBLE_JUMP"]!=null&& graphic_frame<animation["DOUBLE_JUMP"]*graphic_numFrame*graphic_numFrame) {
				//trace("DOUBLE_JUMP");
				graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["JUMP"]*graphic_numFrame*graphic_numFrame;
			} else if (isJumping && !isDoubleJumping && !isFalling&& animation["JUMP"]!=null && (graphic_frame<animation["JUMP"]*graphic_numFrame*graphic_numFrame || keyboard_gamePad.down.isDown)) {
				//trace("JUMP");
				if (_mode=="2Dir"&&keyboard_gamePad!=null&&keyboard_gamePad.down.isDown&&animation["JUMP_DOWN"]!=null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["JUMP_DOWN"]*graphic_numFrame*graphic_numFrame;
				} else {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["JUMP"]*graphic_numFrame*graphic_numFrame;
				}
			} else if (isAttacking && animation["ATTACK"]!= null && graphic_frame<animation["ATTACK"]*graphic_numFrame*graphic_numFrame) {
				//trace("ATTACK");
				if (_mode=="2Dir" && keyboard_gamePad!=null && (keyboard_gamePad.downRight.isDown || keyboard_gamePad.downLeft.isDown ) && animation["ATTACK_DOWN"]!= null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["ATTACK_DOWN"]*graphic_numFrame*graphic_numFrame;
				} else {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["ATTACK"]*graphic_numFrame*graphic_numFrame;
				}
			} else if (isAttacking && animation["ATTACK"]!= null && graphic_frame%graphic_numFrame==0) {
				//trace("ATTACK_STOP");
				component._spatial_properties.isAttacking=false;
			} else if (isRunning && !isAttacking && !isJumping && !isDoubleJumping&& !isFalling && animation["RUN"]!=null && (graphic_frame<animation["RUN"]*graphic_numFrame*graphic_numFrame || graphic_frame>Number(animation["RUN"]+1)*graphic_numFrame*graphic_numFrame)) {
				//trace("RUN");
				graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["RUN"]*graphic_numFrame*graphic_numFrame;
			} else if (isMoving && !isRunning && !isAttacking && !isJumping && !isDoubleJumping && !isFalling && animation["WALK"]!= null && (graphic_frame<=animation["WALK"]*graphic_numFrame*graphic_numFrame || graphic_frame>Number(animation["WALK"]+1)*graphic_numFrame*graphic_numFrame )) {
				//trace("WALK");
				if (_mode=="2Dir"&& keyboard_gamePad!=null && (keyboard_gamePad.downRight.isDown || keyboard_gamePad.downLeft.isDown )  && animation["WALK_DOWN"]!= null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["WALK_DOWN"]*graphic_numFrame*graphic_numFrame;
				} else if (_mode=="2Dir"&& keyboard_gamePad!=null && (keyboard_gamePad.upRight.isDown || keyboard_gamePad.upLeft.isDown )  && animation["WALK_UP"]!= null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["WALK_UP"]*graphic_numFrame*graphic_numFrame;
				} else {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["WALK"]*graphic_numFrame*graphic_numFrame;
				}
			} else if (!isMoving && !isAttacking && !isJumping && !isDoubleJumping && !isFalling && animation["STATIC"]!= null && graphic_frame>animation["STATIC"]*graphic_numFrame*graphic_numFrame) {
				//trace("STATIC");
				if (_mode=="2Dir"&&keyboard_gamePad!=null&&keyboard_gamePad.down.isDown&&animation["STATIC_DOWN"]!=null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["STATIC_DOWN"]*graphic_numFrame*graphic_numFrame;
				} else if (_mode=="2Dir"&& keyboard_gamePad!=null && keyboard_gamePad.up.isDown && animation["STATIC_UP"]!= null) {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["STATIC_UP"]*graphic_numFrame*graphic_numFrame;
				} else {
					graphic_frame=graphic_frame%(graphic_numFrame*graphic_numFrame)+animation["STATIC"]*graphic_numFrame*graphic_numFrame;
				}
			}
			return graphic_frame;
		}
		//----- Set Frame -----------------------------------
		private function setFrame(component:*, graphic_frame:int):int {
			var graphic_numFrame:int=component._graphic_numFrame;
			if ((graphic_frame)%graphic_numFrame==0) {
				graphic_frame-=3;
			} else {
				graphic_frame++;
			}
			return graphic_frame;
		}
		//------ Set Mode  ------------------------------------
		public function setMode(mode:String):void {
			if (! (mode=="2Dir" || mode=="4Dir"||mode=="4DirIso") ) {
				throw new Error("Error KeyboardMoveComponent: direction must be 2Dir, 4Dir or 4dirIso");
			}
			_mode=mode;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}