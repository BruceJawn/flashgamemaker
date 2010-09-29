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
	/**
	* gGraphic Loader Class
	* 
	*/
	public class GraphicLoader extends EventDispatcher {
		
		private var _graphic:* = null;
		private var _name:String;
		private var _type:String;
		private var _loader:Loader = null;

		public function GraphicLoader() {
			initVar();
		}
		//------ Init Var ------------------------------------
		public function initVar():void {
			
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic(path:String,name:String):void {
			_name = name;
			_type = path.substr(path.length-3,3);
			_loader = new Loader ();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadingSuccessfull);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressMade);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.load( new URLRequest(path));
		}
		//------ On Loading Successfull ------------------------------------
		private function onLoadingSuccessfull( evt:Event ):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadingSuccessfull);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressMade);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_graphic = evt.target.content;
			dispatchEvent( evt);
		}
		//------ On Progress Made ------------------------------------
		private function onProgressMade( evt:ProgressEvent ):void {
			dispatchEvent(evt);
		}
		//------ Io Error ------------------------------------
		private function onIoError( evt:IOErrorEvent ):void {
			throw new Error("Error: Loading Fail \n" + evt);
		}
		//------ Get Name ------------------------------------
		public  function getName():String {
			return _name;
		}
		//------ Get Type ------------------------------------
		public  function getType():String {
			return _type;
		}
		//------ Get Graphic ------------------------------------
		public  function getGraphic():* {
			return _graphic;
		}
		//------ Is Loading ------------------------------------
		public  function isLoading():Boolean {
			if(_loader!=null && _loader.hasEventListener(Event.COMPLETE)){
				return true;
			}
			return false;
		}
		//------ Destroy Swf ------------------------------------
		public function destroy():void {
			_graphic = null;
		}
	}
}