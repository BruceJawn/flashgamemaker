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
	import flash.display.DisplayObject;
	import flash.events.*;
	/**
	* Interface Class
	* @ purpose: Implements the core game engine interface.
	*/
	public class GraphicManager extends LoaderDispatcher implements IGraphicManager {

		private static var _instance:IGraphicManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _xmlLoader:XmlLoader=null;
		private var _graphicLoader:GraphicLoader=null;
		private var _graphicsToLoad:Array=null;
		private var _graphicsLoaded:Array = new Array();
		private var _graphicsOnScene:Dictionary=null;
		private var _componentsOnScene:Dictionary=null;
		private var _layers:Array=null;

		public function GraphicManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use XmlManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IGraphicManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new GraphicManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicsOnScene = new Dictionary();
			_graphicsToLoad = new Array();
			_componentsOnScene = new Dictionary();
			_layers= new Array();
			_xmlLoader=new XmlLoader();
			_graphicLoader=new GraphicLoader();
		}
		//------ Load Graphics From Path ------------------------------------
		public function loadGraphicsFromPath(path:String, xmlName:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlLoader.loadXml(path,xmlName);
		}
		//------ Load Graphics From Xml ------------------------------------
		public function loadGraphicsFromXml(xml:XML, xmlName:String):void {
			parseXml(xml);
			var graphicPath:String=_graphicsToLoad[0].path;
			var graphicName:String=_graphicsToLoad[0].name;
			loadGraphic(graphicPath, graphicName);
		}
		//------ Load Xml ------------------------------------
		private function loadXml(path:String, name:String):void {
			_xmlLoader=new XmlLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			_xmlLoader.loadXml(path,name);
		}
		//------ Xml Loading Successful ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void {
			_xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
			var xml:XML=_xmlLoader.getXml();
			parseXml(xml);
			var graphicPath:String=_graphicsToLoad[0].path;
			var graphicName:String=_graphicsToLoad[0].name;
			loadGraphic(graphicPath, graphicName);
		}
		//------ Parse Xml ------------------------------------
		private function parseXml(xml:XML):void {
			var xmlList:XMLList=xml.children();
			for each (var xmlChild:XML in xmlList) {
				var graphicName:String=xmlChild.name();
				var graphicPath:String=xmlChild.path;
				_graphicsToLoad.push({name:graphicName,path:graphicPath});
			}
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic(path:String, graphicName:String):void {
			if (_graphicsToLoad.length>0&&_graphicLoader.isLoading()||_graphicsToLoad.length==0) {
				_graphicsToLoad.push({name:graphicName,path:path});
			}
			if (!(_graphicsToLoad.length>0 && _graphicLoader.isLoading())) {
				_graphicLoader=new GraphicLoader();
				_graphicLoader.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
				_graphicLoader.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
				_graphicLoader.loadGraphic(path,graphicName);
			}
		}
		//------ On Graphic Loading Successful ------------------------------------
		private function onGraphicLoadingSuccessful( evt:Event ):void {
			registerGraphicLoaded();
			_graphicsToLoad.shift();
			if (_graphicsToLoad.length>0) {
				var graphicPath:String=_graphicsToLoad[0].path;
				var graphicName:String=_graphicsToLoad[0].name;
				_graphicLoader.loadGraphic(graphicPath, graphicName);
			} else {
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
			var graphicName:String=_graphicLoader.getName();
			var graphic:* =_graphicLoader.getGraphic();
			_graphicsLoaded.push({name:graphicName,graphic:graphic});
		}
		//------ Get Graphic  ------------------------------------
		public function getGraphic(graphicName:String):* {
			for each (var obj:Object in _graphicsLoaded) {
				if (graphicName==obj.name) {
					return obj.graphic;
				}
			}
			return null;
		}
		//------ Get Graphics  ------------------------------------
		public function getGraphics():Array {
			return _graphicsLoaded;
		}
		//------ Get Num Graphics To Load  ------------------------------------
		public function getNumGraphicsToLoad():Number {
			if (_graphicsToLoad==null) {
				return 0;
			}
			return _graphicsToLoad.length;
		}
		//------ Display Graphic ------------------------------------
		public function displayGraphic(graphicName:String, graphic:*, layerId:int):DisplayObject {
			registerGraphicOnScene(graphicName,graphic);
			if (layerId>=_layers.length) {
				layerId=createNewLayer();
			}
			var layer:Sprite=_layers[layerId];
			return layer.addChild(graphic);
		}
		//------ Set Layer ------------------------------------
		public function setLayer(graphicName:String,layerId:int):void {
			/*if (layerId>=_layers.length) {
				layerId=createNewLayer();
			}
			var graphic:*=_graphicsOnScene[graphicName];
			var layer:Sprite=_layers[graphic._render_layerId];
			layer.removeChild(graphic);
			layer=_layers[layerId];
			layer.addChild(graphic);*/
		}
		//------ Contains Graphic ------------------------------------
		public function containsGraphic(graphicName:String):Boolean {
			if (_graphicsOnScene[graphicName]!=null) {
				return true;
			}
			return false;
		}
		//------ Remove Graphic ------------------------------------
		public function removeGraphic(graphicName:String):void {
			var graphic:*=_graphicsOnScene[graphicName];
			for each (var layer:Sprite in _layers) {
				if (layer.contains(graphic)) {
					layer.removeChild(graphic);
					unregisterGraphicOnScene(graphicName);
					return;
				}
			}
		}
		//------ Create New Layer ------------------------------------
		public function createNewLayer():int {
			var layer:Sprite = new Sprite();
			FlashGameMaker.STAGE.addChild(layer);
			_layers.push(layer);
			return _layers.length-1;
		}
		//------ Remove Layer ------------------------------------
		public function removeLayer(layerId:int):void {
			if (layerId>=_layers.length) {
				throw new Error("There is no layer with the id "+layerId+" !!");
			}
			var layer:Sprite=_layers[layerId];
			FlashGameMaker.STAGE.removeChild(layer);
			_layers.splice(layerId,1);
		}
		//------ Register Graphic On Scene ------------------------------------
		private function registerGraphicOnScene(graphicName:String, graphic:*):void {
			_graphicsOnScene[graphicName]=graphic;
		}
		//------ Unregister Graphic On Scene ------------------------------------
		private function unregisterGraphicOnScene(graphicName:String):void {
			delete _graphicsOnScene[graphicName];
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}