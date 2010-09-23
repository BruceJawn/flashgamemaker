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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.add.screen{
	import framework.core.system.InterfaceEvent;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	/**
	* Interface Class
	* @ purpose: Interface Screen description.
	*/
	public class AboutScreen extends InterfaceScreen {

		private var _returnBt:SimpleButton=null;

		public function AboutScreen(name:String,clip:MovieClip) {
			super(name,clip);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_returnBt=_clip.returnBt;
			_returnBt.focusRect=false;
			_returnBt.tabIndex=1;
		}
		//------ Init Listener ------------------------------------
		private function initListener( ):void {
			_returnBt.addEventListener(MouseEvent.CLICK,onReturnClick);
			_clip.addEventListener(KeyboardEvent.KEY_UP, onKeyPress);
		}
		//------ On Return Click ------------------------------------
		private function onReturnClick(event:MouseEvent):void {
			_screenDestination="MenuScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On Press Enter ------------------------------------
		private function onKeyPress(keyBoardEvent:KeyboardEvent):void {
			var keyCode:uint=keyBoardEvent.keyCode;
			if (keyCode==Keyboard.ESCAPE) {
				_screenDestination="MenuScreen";
				dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
			}
		}
	}
}