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
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class BitmapAnimationComponent extends Component {
		
		private var _animation:Dictionary = null;
		//Timer properties
		public var _timer_delay:Number = 120;
		public var _timer_count:Number = 0;
	
		public function BitmapAnimationComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_animation = new Dictionary();
			_animation["STATIC"] = 0;
			_animation["WALK"] = 1;
			_animation["ATTACK"] = 2;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			setPropertyReference("timer",_componentName);
			registerProperty("bitmapAnimation", _componentName);
		}
		//------ Set Move ------------------------------------
		public function setMove(animation:Dictionary):void {
			_animation = animation
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if(_timer_count>=_timer_delay){
				if(componentName!=_componentName && component._keyboard_key!=null){
					var keyboard_key:Object = component._keyboard_key;
					var spatial_dir:IsoPoint = component._spatial_dir;
					var spatial_isMoving:Boolean = component._spatial_isMoving;
					var graphic_numFrame:int = component._graphic_numFrame;
					var graphic_frame:int = component._graphic_frame;
					var graphic_oldFrame:int = component._graphic_oldFrame;
					var frame:int=getFrame(spatial_dir, graphic_numFrame,graphic_frame,keyboard_key);
					frame = setAnimation(frame,graphic_numFrame,graphic_numFrame,spatial_isMoving,keyboard_key);
					frame = setFrame(frame,graphic_oldFrame,graphic_numFrame);
					component._graphic_oldFrame=component._graphic_frame;
					component._graphic_frame=frame;
					component.actualizeComponent(componentName,componentOwner,component);
				}
			}
		}
		//-- Get Frame ---------------------------------------------------
		public function getFrame(spatial_dir:IsoPoint, graphic_numFrame:int,graphic_frame:int,keyboard_key:Object ):int{
			var keyTouch:String=keyboard_key.keyTouch;
			var totalFrame:int = graphic_numFrame*graphic_numFrame;
			if(keyTouch=="RIGHT" && !(graphic_frame%totalFrame>=1 && graphic_frame%totalFrame<=graphic_numFrame)){//Right
				graphic_frame=1;
			}else if(keyTouch=="LEFT" && !(graphic_frame%totalFrame>=graphic_numFrame*2+1 && graphic_frame%totalFrame<=graphic_numFrame*3)){//Left
				graphic_frame=graphic_numFrame*2+1;
			}else if(keyTouch=="DOWN" && !(graphic_frame%totalFrame>=graphic_numFrame+1 &&  graphic_frame%totalFrame<=graphic_numFrame*2)){//Down
				graphic_frame=graphic_numFrame+1;
			}else if(keyTouch=="UP" && !(graphic_frame%totalFrame>=graphic_numFrame*3+1 &&  graphic_frame%totalFrame<=graphic_numFrame*4)){//Up
				graphic_frame=graphic_numFrame*3+1;
			}
			return graphic_frame;
		}
		//----- Set Frame -----------------------------------
		private function setFrame(graphic_frame:int,graphic_oldFrame:int,graphic_numFrame:int):int {
			graphic_frame++;
			if(graphic_oldFrame!=0 && (graphic_oldFrame+1)%4==0 && graphic_frame==graphic_oldFrame+2){
				graphic_frame-=4;
			}
			return graphic_frame;
		}
		//----- Set Animation -----------------------------------
		private function setAnimation(graphic_frame:int,graphic_oldFrame:int,graphic_numFrame:int,spatial_isMoving:Boolean,keyboard_key:Object):int {
			var doubleClick:String=keyboard_key.doubleClick;
			var longClick:String=keyboard_key.longClick;
			var keyTouch:String=keyboard_key.keyTouch;
			if (spatial_isMoving && doubleClick  && _animation["RUN"]!= null && graphic_frame<_animation["RUN"]*graphic_numFrame*graphic_numFrame) {
					graphic_frame+=_animation["RUN"]*graphic_numFrame*graphic_numFrame;
			}else if (spatial_isMoving &&_animation["WALK"]!= null && graphic_frame<_animation["WALK"]*graphic_numFrame*graphic_numFrame) {
					graphic_frame+=_animation["WALK"]*graphic_numFrame*graphic_numFrame;
			}else if (!spatial_isMoving && _animation["ATTACK"]!= null && keyTouch=="ATTACK" && graphic_frame<_animation["ATTACK"]*graphic_numFrame*graphic_numFrame) {
				    graphic_frame+=graphic_numFrame*graphic_numFrame;
			}else if (!spatial_isMoving &&_animation["STATIC"]!= null && graphic_frame>graphic_numFrame*graphic_numFrame) {
				    graphic_frame-=graphic_numFrame*graphic_numFrame;
			}
			return graphic_frame;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}