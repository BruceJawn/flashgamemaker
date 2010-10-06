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

package utils.loader{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.*;
	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.media.*;

	/**
	* Sound Loader Class
	* 
	*/
	public class SoundLoader extends EventDispatcher {

		private var _sound:Sound=null;
		private var _name:String;
		private var _loader:Loader=null;
		private var _loaderContext:LoaderContext=null;

		public function SoundLoader() {
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_loaderContext = new LoaderContext ();
			_loaderContext.checkPolicyFile=true;
		}
		//------ Load Sound ------------------------------------
		public function loadSound(path:String,name:String):void {
			_name=name;
			_loader = new Loader ();
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoadingSuccessfull);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.load( new URLRequest(path),_loaderContext);

		}
		//------ On Loading Successfull ------------------------------------
		private function onLoadingSuccessfull( evt:Event ):void {
			_loader.contentLoaderInfo.removeEventListener(Event.OPEN, onLoadingSuccessfull);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_sound=evt.target.content;
			dispatchEvent( evt);
		}
		//------ Io Error ------------------------------------
		private function onIoError( evt:IOErrorEvent ):void {
			throw new Error("Error: Loading Fail \n"+evt);
		}
		//------ Get Name ------------------------------------
		public function getName():String {
			return _name;
		}
		//------ Get Graphic ------------------------------------
		public function getSound():Sound {
			return _sound;
		}
		//------ Is Loading ------------------------------------
		public function isLoading():Boolean {
			if (_loader!=null&&_loader.hasEventListener(Event.COMPLETE)) {
				return true;
			}
			return false;
		}
		//------ Destroy Swf ------------------------------------
		public function destroy():void {
			_sound=null;
		}
	}
}