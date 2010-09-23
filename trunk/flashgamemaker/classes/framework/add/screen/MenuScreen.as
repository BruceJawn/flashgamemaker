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
	import flash.net.*;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	/**
	* Interface Class
	* @ purpose: Interface Screen description.
	*/
	public class MenuScreen extends InterfaceScreen {

		private var _flashgamemakerBt:SimpleButton=null;
		private var _startBt:SimpleButton=null;
		private var _helpBt:SimpleButton=null;
		private var _configBt:SimpleButton=null;
		private var _aboutBt:SimpleButton=null;
		private var _downloadBt:SimpleButton=null;
		private var _statutText:TextField=null;
		private var _errorText:TextField=null;

		public function MenuScreen(name:String,clip:MovieClip) {
			super(name,clip);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_flashgamemakerBt= _clip.flashgamemakerBt;
			_startBt=_clip.startBt;
			_startBt.focusRect=false;
			_startBt.tabIndex=1;
			_configBt=_clip.configBt;
			_configBt.focusRect=false;
			_configBt.tabIndex=2;
			_helpBt=_clip.helpBt;
			_helpBt.focusRect=false;
			_helpBt.tabIndex=3;
			_aboutBt=_clip.aboutBt;
			_downloadBt=_clip.downloadBt;
			_statutText=_clip.statutText;
			_errorText=_clip.errorText;
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_flashgamemakerBt.addEventListener(MouseEvent.CLICK,onFGMClick);
			_startBt.addEventListener(MouseEvent.CLICK,onStartClick);
			_helpBt.addEventListener(MouseEvent.CLICK,onHelpClick);
			_configBt.addEventListener(MouseEvent.CLICK,onConfigClick);
			_aboutBt.addEventListener(MouseEvent.CLICK,onAboutClick);
			_downloadBt.addEventListener(MouseEvent.CLICK,onDownloadClick);
		}
		//------ On Start Click ------------------------------------
		private function onStartClick(event:MouseEvent):void {
			_screenDestination="AdScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On Config Click ------------------------------------
		private function onConfigClick(event:MouseEvent):void {
			_screenDestination="ConfigScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On Help Click ------------------------------------
		private function onHelpClick(event:MouseEvent):void {
			_screenDestination="HelpScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On About Click ------------------------------------
		private function onAboutClick(event:MouseEvent):void {
			_screenDestination="AboutScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On FlashGameMaker Click ------------------------------------
		private function onFGMClick(event:MouseEvent):void {
			var url:String="http://flashgamemakeras3.blogspot.com/";
			var request:URLRequest=new URLRequest(url);
			try {
				navigateToURL(request,'_blank');// second argument is target
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		//------ On Click Download ------------------------------------
		private function onDownloadClick(event:MouseEvent):void {
			var url:String="https://sourceforge.net/projects/isoengineas3/";
			var request:URLRequest=new URLRequest(url);
			try {
				navigateToURL(request,'_blank');// second argument is target
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		//------ Update Error Text ------------------------------------
		private function updateErrorText(_text:String):void {
			_errorText.text=_text;
		}
		//------ Update Ststut Text ------------------------------------
		private function updateStatutText(_text:String):void {
			_statutText.text=_text;
		}
	}
}