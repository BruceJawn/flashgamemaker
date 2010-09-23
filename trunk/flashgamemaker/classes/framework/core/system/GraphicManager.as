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
	import flash.display.Sprite;
	import flash.events.*;
	/**
	* Interface Class
	* @ purpose: Implements the core game engine interface.
	*/
	public class GraphicManager extends LoaderDispatcher implements IGraphicManager {

		private static var _instance:IGraphicManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _xmlLoader:XmlLoader = null;
		private var _graphicLoader:GraphicLoader=null;
		private var _graphicsToLoad:Array = null;
		private var _graphicsLoaded:Array = new Array();
		private var _graphicsOnScene:Dictionary = null;
		
		public function GraphicManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use XmlManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IGraphicManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new GraphicManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicsOnScene= new Dictionary();
			_graphicsToLoad = new Array();
		}
		//------ Load Graphics From Path ------------------------------------
		public function loadGraphicsFromPath(path:String, xmlName:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlLoader.loadXml(path,xmlName);
		}
		//------ Load Graphics From Xml ------------------------------------
		public function loadGraphicsFromXml(xml:XML, xmlName:String):void {
			_graphicsToLoad  = parseXml(xml);
			var graphicPath:String = _graphicsToLoad[0].path;
			var graphicName:String = _graphicsToLoad[0].name;
			loadGraphic(graphicPath, graphicName);
		}
		//------ Load Xml ------------------------------------
		public function loadXml(path:String, name:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlLoader.loadXml(path,name);
		}
		//------ Xml Loading Successful ------------------------------------
		public function onXmlLoadingSuccessful(evt:Event):void {
			_xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			var xml:XML =_xmlLoader.getXml();
			_graphicsToLoad  = parseXml(xml);
			var graphicPath:String = _graphicsToLoad[0].path;
			var graphicName:String = _graphicsToLoad[0].name;
			loadGraphic(graphicPath, graphicName);
		}
		//------ Parse Xml ------------------------------------
		private function parseXml(xml:XML):Array {
			var graphicsToLoad:Array = new Array();
			var xmlList:XMLList = xml.children();
			for each (var xmlChild:XML in xmlList) {
				var graphicName:String = xmlChild.name();
				var graphicPath:String = xmlChild.path;
				graphicsToLoad.push({name:graphicName,path:graphicPath});
			}			
			return graphicsToLoad;
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic(path:String, name:String):void {
			_graphicLoader=new GraphicLoader();
			initGraphicListener();
			_graphicLoader.loadGraphic(path,name);
		}
		//------ Init Listener ------------------------------------
		private function initGraphicListener():void {
			_graphicLoader.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			_graphicLoader.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
		}
		//------ On Graphic Loading Successful ------------------------------------
		private function onGraphicLoadingSuccessful( evt:Event ):void {
			registerGraphicLoaded();
			_graphicsToLoad.shift();
			if(_graphicsToLoad.length>0){
				var graphicPath:String = _graphicsToLoad[0].path;
				var graphicName:String = _graphicsToLoad[0].name;
				_graphicLoader.loadGraphic(graphicPath, graphicName);
			}else{
				_graphicLoader.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
				_graphicLoader.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
				dispatchEvent(evt);
			}
		}
		//------ On Graphic Loading Progress ------------------------------------
		private function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			dispatchEvent(evt);
		}
		//------ Register Graphic Loaded ------------------------------------
		private function registerGraphicLoaded():void {
			var graphicName:String = _graphicLoader.getName();
			var graphic:* = _graphicLoader.getGraphic();
			_graphicsLoaded.push({name:graphicName,graphic:graphic});
		}
		//------ Get Graphic  ------------------------------------
		public function getGraphic(graphicName:String):* {
			for each( var obj:Object in _graphicsLoaded){
				if(graphicName == obj.name){
					return obj.graphic;
					}
			}
			return null;
		}
		//------ Get Graphics  ------------------------------------
		public function getGraphics():Array {
			return _graphicsLoaded ;
		}
		//------ Get Num Graphics To Load  ------------------------------------
		public function getNumGraphicsToLoad():Number {
			if(_graphicsLoaded==null){
				return 0;
			}
			return _graphicsLoaded.length;
		}
		//------ Display Graphic ------------------------------------
		public function displayGraphic(name:String, graphic:*):void {
			registerGraphicOnScene(name,graphic);
			FlashGameMaker.STAGE.addChild(graphic);
		}
		//------ Remove Graphic ------------------------------------
		public function removeGraphic(name:String):void {
			var graphic:Sprite = _graphicsOnScene[name];
			FlashGameMaker.STAGE.removeChild(graphic);
			unregisterGraphicOnScene(name);
		}
		//------ Register Graphic On Scene ------------------------------------
		private function registerGraphicOnScene(name:String, graphic:*):void {
			_graphicsOnScene[name] = graphic;
		}
		//------ Unregister Graphic On Scene ------------------------------------
		private function unregisterGraphicOnScene(name:String):void {
			delete _graphicsOnScene[name];
		}
	}
}