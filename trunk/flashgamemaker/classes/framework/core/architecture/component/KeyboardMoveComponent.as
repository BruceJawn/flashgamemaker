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
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardMoveComponent extends Component {

		private var _mode:String="4Dir";
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;

		public function KeyboardMoveComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardMove",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			component._keyboard_gamePad=_keyboard_gamePad;
			if (componentName==_componentName) {
				update("keyboardMove");
			} else if (_keyboard_gamePad!=null) {
				updateDir(_keyboard_gamePad,component);
				updateProp(_keyboard_gamePad,component);
			}
		}
		//------ Update Dir  ------------------------------------
		private function updateDir(keyboard_gamePad:Object,component:*):void {
			if (_mode=="2Dir") {
				twoDirMove(keyboard_gamePad,component);
			} else if (_mode=="4Dir") {
				fourDirMove(keyboard_gamePad,component);
			} else if (_mode=="4DirIso") {
				fourDirIsoMove(keyboard_gamePad,component);
			}
		}
		//------ 2 Direction Move ------------------------------------
		private function twoDirMove(keyboard_gamePad:Object,component:*):void {
			if (keyboard_gamePad.right.isDown) {
				component._spatial_dir.x=1;
			} else if (keyboard_gamePad.left.isDown) {
				component._spatial_dir.x=-1;
			}
			if (! keyboard_gamePad.right.isDown&&! keyboard_gamePad.left.isDown) {
				component._spatial_dir.x=0;
			}
		}
		//------ 4 Direction Move ------------------------------------
		private function fourDirMove(keyboard_gamePad:Object,component:*):void {
			if (keyboard_gamePad.downRight.isDown) {
				component._spatial_dir.x=1;
				component._spatial_dir.y=1;
			} else if (keyboard_gamePad.downLeft.isDown) {
				component._spatial_dir.x=-1;
				component._spatial_dir.y=1;
			} else if (keyboard_gamePad.upLeft.isDown) {
				component._spatial_dir.x=-1;
				component._spatial_dir.y=-1;
			} else if (keyboard_gamePad.upRight.isDown ) {
				component._spatial_dir.x=1;
				component._spatial_dir.y=-1;
			} else if (keyboard_gamePad.right.isDown) {
				component._spatial_dir.x=1;
			} else if (keyboard_gamePad.left.isDown) {
				component._spatial_dir.x=-1;
			} else if (keyboard_gamePad.up.isDown) {
				component._spatial_dir.y=-1;
			} else if (keyboard_gamePad.down.isDown ) {
				component._spatial_dir.y=1;
			} else {
				component._spatial_dir.x=0;
				component._spatial_dir.y=0;
			}
		}
		//------ 4 Direction IsoMove ------------------------------------
		private function fourDirIsoMove(keyboard_gamePad:Object,component:*):void {
			if (keyboard_gamePad.right.isDown) {
				component._spatial_dir.x=1;
				component._spatial_dir.y=1;
			} else if (keyboard_gamePad.left.isDown) {
				component._spatial_dir.x=-1;
				component._spatial_dir.y=-1;
			} else if (keyboard_gamePad.up.isDown) {
				component._spatial_dir.x=1;
				component._spatial_dir.y=-1;
			} else if (keyboard_gamePad.down.isDown) {
				component._spatial_dir.x=-1;
				component._spatial_dir.y=1;
			} else {
				component._spatial_dir.x=0;
				component._spatial_dir.y=0;
			}
		}
		//------ Update Properties  ------------------------------------
		private function updateProp(keyboard_gamePad:Object,component:*):void {
			if (keyboard_gamePad.fire1.isDown) {
				component._spatial_properties.isAttacking=true;
			} 
			if (keyboard_gamePad.fire2.isDown&&! component._spatial_properties.isJumping&&! component._spatial_properties.isFalling&&component._spatial_jump.z==0) {
				component._spatial_jump.z=component._spatial_jumpStart.z;
				component._spatial_properties.isJumping=true;
				component._spatial_properties.isFalling=false;
			}
			isMoving(keyboard_gamePad,component);
		}
		//------ Is Moving  ------------------------------------
		private function isMoving(keyboard_gamePad:Object,component:*):void {
			if (component._spatial_dir.x!=0||component._spatial_dir.y!=0||component._spatial_dir.z!=0||component._spatial_jump.x!=0||component._spatial_jump.y!=0||component._spatial_jump.z!=0||component._spatial_properties.isFalling||component._spatial_properties.isJumping) {
				component._spatial_properties.isMoving=true;
				if (keyboard_gamePad.shift) {
					component._spatial_properties.isRunning=true;
				} else {
					component._spatial_properties.isRunning=false;
				}
			} else {
				component._spatial_properties.isMoving=false;
				component._spatial_properties.isRunning=false;
			}
		}
		//------ Set Mode  ------------------------------------
		private function setMode(mode:String):void {
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