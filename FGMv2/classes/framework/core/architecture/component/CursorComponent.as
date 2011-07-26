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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Mouse;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.mouse.MousePad;
	
	/**
	* Cursor Component
	* 
	*/
	public class CursorComponent extends GraphicComponent {
		
		private var _cursor:DisplayObject = null;
		
		public function CursorComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("mouseInput", {isListeningMouse:true,onMouseFire:onMouseFire});
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		//------ Hide Cursor ------------------------------------
		public function hideCursor():void {
			Mouse.hide();
		}
		//------ Show Cursor ------------------------------------
		public function showCursor():void {
			Mouse.show();
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject):void {
			super.onGraphicLoadingComplete($graphic);
			_cursor = $graphic;
			hideCursor();
		}
		//------ On Mouse Move ------------------------------------
		public function onMouseFire($mousePad:MousePad):void {
			if($mousePad.mouseEvent){
				if($mousePad.mouseEvent.type == MouseEvent.MOUSE_MOVE){
					onMouseMove($mousePad);
				}else if($mousePad.mouseEvent.type == MouseEvent.MOUSE_DOWN){
					onMouseDown($mousePad);
				}else if($mousePad.mouseEvent.type == MouseEvent.MOUSE_UP){
					onMouseUp($mousePad);
				}
			}
		}
		//------ On Mouse Move ------------------------------------
		public function onMouseMove($mousePad:MousePad):void {
			if(_cursor!=null && !isOutOfBox($mousePad)){
				_cursor.x= $mousePad.mouseEvent.stageX;
				_cursor.y= $mousePad.mouseEvent.stageY;
			}
		}
		//------ On Mouse Move ------------------------------------
		public function isOutOfBox($mousePad:MousePad):Boolean {
			if($mousePad.mouseEvent.stageX+_cursor.width>FlashGameMaker.width || $mousePad.mouseEvent.stageY+_cursor.height>FlashGameMaker.height){
				return true;
			}
			return false;
		}
		//------ On Mouse Down ------------------------------------
		public function onMouseDown($mousePad:MousePad):void {
			if(_cursor is MovieClip && MovieClip(_cursor).currentFrameLabel != "mouseDown"){
				MovieClip(_cursor).gotoAndStop("mouseDown");
			}
		}
		//------ On Mouse Up ------------------------------------
		public function onMouseUp($mousePad:MousePad):void {
			if(_cursor is MovieClip && MovieClip(_cursor).currentFrameLabel != "mouseUp"){
				MovieClip(_cursor).gotoAndStop("mouseUp");
			}
		}
		//------ Reset  ------------------------------------
		public function reset(ownerName:String, componentName:String):void {
			showCursor();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}