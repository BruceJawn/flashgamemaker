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
	import flash.filters.GlowFilter;

	/**
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class MouseMoveComponent extends Component {

		private var _mode:String="2Dir";
		//MouseInput properties
		public var _mouse_object:Object=null;

		public function MouseMoveComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("mouseInput",_componentName);
			registerProperty("mouseMove",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName&&_mouse_object) {
				update("mouseMove");
			} else if (componentName!=_componentName && _mouse_object) {
				checkIfSelected(component);
				if (_mode=="2Dir" && component._selected &&_mouse_object.type=="mouseDown") {
					twoDirMove(component);
				} else if (_mode=="4Dir" && component._selected &&_mouse_object.type=="mouseDown") {
					fourDirMove(component);
				} else if (_mode=="4DirIso" && component._selected &&_mouse_object.type=="mouseDown") {
					fourDirIsoMove(component);
				}
			}
		}
		//------ Check If Selected ------------------------------------
		private function checkIfSelected(component:*):void {
			var glow:GlowFilter = new GlowFilter();
			if (_mouse_object.type=="mouseMove"&&! component._selected&&component._graphic.filters.length==0&&component._graphic.hitTestPoint(_mouse_object.stageX,_mouse_object.stageY)) {
				glow.color=0x770000;
				glow.alpha=1;
				glow.blurX=10;
				glow.blurY=10;
				component._graphic.filters=[glow];
			} else if (_mouse_object.type=="mouseMove" && !component._selected && component._graphic.filters.length>0 && !component._graphic.hitTestPoint(_mouse_object.stageX,_mouse_object.stageY)) {
				component._graphic.filters=[];
			} else if (_mouse_object.type=="mouseDown" && component._selected && component._graphic.hitTestPoint(_mouse_object.stageX,_mouse_object.stageY)) {
				component._graphic.filters=[];
				component._selected=false;
			}else if (_mouse_object.type=="mouseDown" && component._graphic.hitTestPoint(_mouse_object.stageX,_mouse_object.stageY)) {
				glow.color=0x990000;
				glow.alpha=1;
				glow.blurX=10;
				glow.blurY=10;
				component._selected=true;
				component._graphic.filters=[glow];
			} 
		}
		//------ 2 Direction Move ------------------------------------
		private function twoDirMove(component:*):void {
			if (component._spatial_dir&&component._spatial_properties) {
				component._spatial_destination=new IsoPoint(_mouse_object.stageX,_mouse_object.stageY);
				component._spatial_properties.isMoving=true;
				if (component._spatial_destination.x>component._spatial_position.x+component.width/2) {
					component._spatial_dir.x=1;
				} else {
					component._spatial_dir.x=-1;
				}
			}
		}
		//------ 4 Direction Move ------------------------------------
		private function fourDirMove(component:*):void {
			if (component._spatial_dir&&component._spatial_properties) {
				component._spatial_destination=new IsoPoint(_mouse_object.stageX,_mouse_object.stageY);
				component._spatial_properties.isMoving=true;
				if (component._spatial_destination.x>component._spatial_position.x+component.width/2) {
					component._spatial_dir.x=1;
				} else {
					component._spatial_dir.x=-1;
				}
				if (component._spatial_destination.y>component._spatial_position.y) {
					component._spatial_dir.y=1;
				} else {
					component._spatial_dir.y=-1;
				}
			}
		}
		//------ 4 Direction IsoMove ------------------------------------
		private function fourDirIsoMove(component:*):void {

		}
		//------ Update Properties  ------------------------------------
		private function updateProp(_mouse_object:Object,component:*):void {

		}
		//------ Is Moving  ------------------------------------
		private function isMoving(_mouse_object:Object,component:*):void {
			/*if (component._spatial_dir.x!=0||component._spatial_dir.y!=0||component._spatial_dir.z!=0||component._spatial_jump.x!=0||component._spatial_jump.y!=0||component._spatial_jump.z!=0||component._spatial_properties.isFalling||component._spatial_properties.isJumping) {
			component._spatial_properties.isMoving=true;
			if (keyboard_gamePad.shift) {
			component._spatial_properties.isRunning=true;
			} else {
			component._spatial_properties.isRunning=false;
			}
			} else {
			component._spatial_properties.isMoving=false;
			component._spatial_properties.isRunning=false;
			}*/
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