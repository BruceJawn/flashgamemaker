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
	import framework.core.system.MouseManager;
	import framework.core.system.IMouseManager;

	import flash.events.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	* Cursor Component
	* 
	*/
	public class CursorComponent extends GraphicComponent {
		
		private var _mouseManager:IMouseManager=null;
		private var _cursor:MovieClip = null;
		//MouseInput properties
		public var _mouse_object:Object = null;
		
		public function CursorComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_mouseManager=MouseManager.getInstance();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("mouseInput");
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_mouseManager.hideCursor();
			_cursor=addChild($graphic) as MovieClip;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
			if(_mouse_object.type=="mouseMove"){
				moveCursor();
			}else if(_mouse_object.type=="click"){
				clickCursor();
			}
		}
		//------ Move Cursor  ------------------------------------
		private function moveCursor():void {
			if(_cursor!=null){
				_cursor.x= _mouse_object.stageX;
				_cursor.y= _mouse_object.stageY;
			}
		}
		//------ Click Cursor  ------------------------------------
		private function clickCursor():void {
			
		}
		//------ Reset  ------------------------------------
		public function reset(ownerName:String, componentName:String):void {
			_mouseManager.showCursor();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}