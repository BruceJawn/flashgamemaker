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
	import framework.core.system.PhysicManager;
	import framework.core.system.IPhysicManager;
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

		//Timer properties
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
			if (_timer_count>=_timer_delay) {
				if (componentName!=_componentName) {
					var frame:int=getFrame(component);
					frame=setAnimation(component,frame);
					frame=setFrame(component,frame);
					component._graphic_oldFrame=component._graphic_frame;
					component._graphic_frame=frame;
					component.actualizeComponent(componentName,componentOwner,component);
				}
			}
		}
		//-- Get Frame ---------------------------------------------------
		public function getFrame(component:*):int {
			var graphic_frame:int=component._graphic_frame;
			var graphic_numFrame:int=component._graphic_numFrame;
			var graphic_oldFrame:int=component._graphic_oldFrame;
			var totalFrame:int=graphic_numFrame*graphic_numFrame;
			
			var spatial_dir:IsoPoint=component._spatial_dir;
			
			if (spatial_dir.x>0) {//Right
				graphic_frame=1;
			} else if (spatial_dir.x<0) {//Left
				graphic_frame=graphic_numFrame*2+1;
			} else if (spatial_dir.y>0) {//Down
				graphic_frame=graphic_numFrame+1;
			} else if (spatial_dir.y<0) {//Up
				graphic_frame=graphic_numFrame*3+1;
			}else if(graphic_frame%totalFrame<=graphic_numFrame){//Right
				graphic_frame=1;
			}else if(graphic_frame%totalFrame<=graphic_numFrame*2){//Down
				graphic_frame=graphic_numFrame+1;
			}else if(graphic_frame%totalFrame<=graphic_numFrame*3){//Left
				graphic_frame=graphic_numFrame*2+1;
			}else if(graphic_frame%totalFrame<=graphic_numFrame*4){//Up
				graphic_frame=graphic_numFrame*3+1;
			}
			return graphic_frame;
		}
		//----- Set Frame -----------------------------------
		private function setFrame(component:*, graphic_frame:int):int {
			var graphic_numFrame:int=component._graphic_numFrame;
			var graphic_oldFrame:int=component._graphic_oldFrame;
			
			graphic_frame++;
			if (graphic_oldFrame!=0 && (graphic_oldFrame+1)%4==0 && graphic_frame==graphic_oldFrame+2) {
				graphic_frame-=4;
			}
			return graphic_frame;
		}
		//----- Set Animation -----------------------------------
		private function setAnimation(component:*, graphic_frame:int):int {
			var isMoving:Boolean=component._spatial_properties.isMoving;
			var isRunning:Boolean=component._spatial_properties.isRunning;
			var isAttacking:Boolean=component._spatial_properties.isAttacking;
			var isJumping:Boolean=component._spatial_properties.isJumping;
			var isDoubleJumping:Boolean=component._spatial_properties.isDoubleJumping;
			var isFalling:Boolean=component._spatial_properties.isFalling;
			var graphic_numFrame:int=component._graphic_numFrame;
			var graphic_oldFrame:int=component._graphic_oldFrame;
			var animation:Dictionary=component._animation;
			if (isFalling && animation["JUMP"]!=null && graphic_frame<animation["JUMP"]*graphic_numFrame*graphic_numFrame) {
				//trace("Fall");
				graphic_frame+=animation["JUMP"]*graphic_numFrame*graphic_numFrame;
			}else if (isDoubleJumping && animation["DOUBLE_JUMP"]!=null&& graphic_frame<animation["DOUBLE_JUMP"]*graphic_numFrame*graphic_numFrame) {
				//trace("DOUBLE_JUMP");
				graphic_frame+=animation["DOUBLE_JUMP"]*graphic_numFrame*graphic_numFrame;
			} else if (isJumping && animation["JUMP"]!=null && graphic_frame<animation["JUMP"]*graphic_numFrame*graphic_numFrame) {
				//trace("JUMP");
				graphic_frame+=animation["JUMP"]*graphic_numFrame*graphic_numFrame;
			}else if (isAttacking && animation["ATTACK"]!= null && graphic_frame<animation["ATTACK"]*graphic_numFrame*graphic_numFrame) {
				//trace("ATTACK");
				graphic_frame+=animation["ATTACK"]*graphic_numFrame*graphic_numFrame;
			}  else if (isRunning && animation["RUN"]!=null&&graphic_frame<animation["RUN"]*graphic_numFrame*graphic_numFrame) {
				//trace("RUN");
				graphic_frame+=animation["RUN"]*graphic_numFrame*graphic_numFrame;
			} else if (isMoving && animation["WALK"]!= null && graphic_frame<animation["WALK"]*graphic_numFrame*graphic_numFrame) {
				//trace("WALK");
				graphic_frame+=animation["WALK"]*graphic_numFrame*graphic_numFrame;
			} else if (!isMoving && animation["STATIC"]!= null && graphic_frame>graphic_numFrame*graphic_numFrame) {
				//trace("STATIC");
				trace(animation["STATIC"]);
				graphic_frame+=animation["STATIC"]*graphic_numFrame*graphic_numFrame;
			}
			return graphic_frame;
		}
		
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}