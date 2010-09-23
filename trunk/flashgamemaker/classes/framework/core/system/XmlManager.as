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
*Under this licence you are free to copy, adapt and distrubute the work. 
*You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import utils.loader.*;
	import flash.utils.Dictionary;
	import flash.events.*;
	/**
	* Interface Class
	* @ purpose: Implements the core game engine interface.
	*/
	public class XmlManager extends LoaderDispatcher implements IXmlManager {

		private static var _instance:IXmlManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _xmlLoader:XmlLoader=null;
		private var _xmlsToLoad:Array = null;
		private var _xmls:Dictionary = null;
		
		public function XmlManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use XmlManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IXmlManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new XmlManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			 _xmls= new Dictionary();
			_xmlsToLoad = new Array();
		}
		//------ Load Xmls From Path ------------------------------------
		public function loadXmlsFromPath(path:String, xmlName:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlsLoadingSuccessful);
			_xmlLoader.loadXml(path,xmlName);
		}
		//------ Load Xmls From Xml ------------------------------------
		public function loadXmlsFromXml(xml:XML, xmlName:String):void {
			_xmlsToLoad  = parseXml(xml);
			var xmlPath:String = _xmlsToLoad[0].path;
			var xmlName:String = _xmlsToLoad[0].name;
			loadXml(xmlPath, xmlName);
		}
		//------ Xml Loading Successful ------------------------------------
		private function onXmlsLoadingSuccessful(evt:Event ):void {
			_xmlLoader.removeEventListener(Event.COMPLETE, onXmlsLoadingSuccessful);
			var xml:XML = _xmlLoader.getXml();
			_xmlsToLoad  = parseXml(xml);
			var xmlPath:String = _xmlsToLoad[0].path;
			var xmlName:String = _xmlsToLoad[0].name;
			loadXml(xmlPath, xmlName);
		}
		//------ Load Xml ------------------------------------
		public function loadXml(path:String, name:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlLoader.loadXml(path,name);
		}
		//------ Xml Loading Successful ------------------------------------
		private function onXmlLoadingSuccessful( evt:Event ):void {
			registerXml();
			_xmlsToLoad.shift();
			if(_xmlsToLoad.length>0){
				var xmlPath:String = _xmlsToLoad[0].path;
				var xmlName:String = _xmlsToLoad[0].name;
				_xmlLoader.loadXml(xmlPath, xmlName);
			}else{
				_xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
				dispatchEvent(evt);
			}
		}
		//------ Xml Loading Progress ------------------------------------
		private function onXmlLoadingProgress( evt:ProgressEvent ):void {
			dispatchEvent(evt);
		}
		//------ Parse Xml ------------------------------------
		private function parseXml(xml:XML):Array {
			var xmlsToLoad:Array = new Array();
			var xmlList:XMLList = xml.children();
			for each (var xmlChild:XML in xmlList) {
				var xmlName:String = xmlChild.name();
				var xmlPath:String = xmlChild.path;
				xmlsToLoad.push({name:xmlName,path:xmlPath});
			}			
			return xmlsToLoad;
		}
		//------ Register Xml ------------------------------------
		private function registerXml():void {
			var xmlName:String = _xmlLoader.getName();
			var xml:XML = _xmlLoader.getXml();
			_xmls[xmlName]=xml;
		}
		//------ Get Xml  ------------------------------------
		public function getXml(xmlName:String):XML {
			return _xmls[xmlName] as XML;
		}
		//------ Print Xml ------------------------------------
		public function printXml(xmlName:String):void {
			var xml:XML=getXml(xmlName);
			trace( xml.toString());
		}
	}
}