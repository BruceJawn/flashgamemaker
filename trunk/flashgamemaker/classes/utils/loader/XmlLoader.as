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
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.LoaderContext;

	/**
	* Xml Loader Class
	* 
	*/
	public class XmlLoader extends EventDispatcher {
		private var _xml:XML=null;
		private var _name:String;
		private var _loader:URLLoader = null; 
		
		public function XmlLoader() {
		}
		//------ Load Data ------------------------------------
		public function loadXml(path:String,name:String):void {
			_name = name;
			_loader = new URLLoader ();
			_loader.addEventListener(Event.COMPLETE, onLoadingSuccessfull);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.load( new URLRequest(path));
		}
		//------ On Loading Successfull ------------------------------------
		private  function onLoadingSuccessfull( evt:Event ):void {
			_loader.removeEventListener(Event.COMPLETE, onLoadingSuccessfull);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_xml=new XML(evt.target.data);
			dispatchEvent( evt );
		}
		//------ Io Error ------------------------------------
		private  function onIoError( evt:IOErrorEvent ):void {
			throw new Error("Error: Xml Loading Fail \n" + evt);
		}
		//------ Get Name ------------------------------------
		public  function getName():String {
			return _name;
		}
		//------ Get Xml ------------------------------------
		public  function getXml():XML {
			return _xml;
		}
		//------ Is Loading ------------------------------------
		public  function isLoading():Boolean {
			if(_loader!=null && _loader.hasEventListener(Event.COMPLETE)){
				return true;
			}
			return false;
		}
		//------ Get Xml Num Children------------------------------------
		public function getXmlNumChildren():Number {
			var xmlNumChildren:Number = _xml.firstChild.length();
			return xmlNumChildren;
		}
		//------ Destroy ------------------------------------
		public function destroy():void {
			_xml = null;
		}
	}
}