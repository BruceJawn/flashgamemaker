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
	import flash.net.*;

	/**
	* Interface Class
	* @ purpose: Interface Screen description.
	*/
	public class InterfaceScreen extends Screen {

		protected var _angelstreetBt:SimpleButton=null;
		protected var _muteBt:SimpleButton=null;
		protected var _screenDestination:String;
		protected var _eff:Object=null;
		protected var _effStatut:Boolean=true;
		protected var _isAnimated:Boolean = false;

		public function InterfaceScreen(name:String,clip:MovieClip) {
			super(name,clip);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_angelstreetBt=_clip.angelstreetBt;
			_muteBt=_clip.angelstreetBt;
			_eff=_clip.eff;
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_angelstreetBt.addEventListener(MouseEvent.CLICK,onClickAngelStreet);
			_muteBt.addEventListener(MouseEvent.CLICK,onClickMute);
		}
		//------ Remove Listener ------------------------------------
		protected function removeListener():void {
			_angelstreetBt.removeEventListener(MouseEvent.CLICK,onClickAngelStreet);
			_muteBt.removeEventListener(MouseEvent.CLICK,onClickMute);
		}
		//------ Is Animated ------------------------------------
		public function isAnimated():void {
			if(_isAnimated){
				startAnim();
			}
		}
		//------ Start Anim ------------------------------------
		protected function startAnim():void {
			
		}
		//------ On Click Mute ------------------------------------
		protected function onClickMute(event:MouseEvent):void {
			dispatchEvent(new InterfaceEvent(InterfaceEvent.MUTE));
		}
		//------ On Click AngelStreet ------------------------------------
		protected function onClickAngelStreet(event:MouseEvent):void {
			var url:String="http://angelstreetv2.blogspot.com/";
			var request:URLRequest=new URLRequest(url);
			try {
				navigateToURL(request,'_blank');// second argument is target
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		//------ Get Clip ------------------------------------
		public function checkEffStatut():void {
			if (_eff!=null && _effStatut) {
				_effStatut=false;
			} else if (_eff!=null){
				_eff.show();
			}
		}
		//------ Get  Destination------------------------------------
		public function getDestination():String {
			return _screenDestination;
		}
	}
}