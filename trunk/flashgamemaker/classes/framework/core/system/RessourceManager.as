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

package framework.core.system {
	import utils.loader.*;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.events.*;
	/**
	* Ressource Manager
	* @ purpose: Manage all the ressources of the game; Xml, SWF, BMP, Sound
	*/
	public class RessourceManager extends LoaderDispatcher implements IRessourceManager{
		
		private static var _instance:IRessourceManager=null;
		private static var _allowInstanciation:Boolean = false;
		private var _xmlManager:IXmlManager = null;
		private var _graphicManager:IGraphicManager = null;
		
		public function RessourceManager(){
			if(!_allowInstanciation){
				 throw new Error("Error: Instantiation failed: Use RessourceManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IRessourceManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance = new RessourceManager();
				return _instance;
			}
			return _instance;
		}
		//------ Get Instance ------------------------------------
		private function initVar():void{
			_xmlManager = XmlManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Load Xml From Path ------------------------------------
		public function loadXmlsFromPath(path:String, name:String):void{
			initXmlListener();
			_xmlManager.loadXmlsFromPath(path, name);			
		}
		//------ Load Xml From Xml ------------------------------------
		public function loadXmlsFromXml(xml:XML, name:String):void{
			initXmlListener();
			_xmlManager.loadXmlsFromXml(xml, name);			
		}
		//------ Load Xml ------------------------------------
		public function loadXml(path:String, name:String):void{
			initXmlListener();
			_xmlManager.loadXml(path, name);			
		}
		//------ Init Listener ------------------------------------
		private function initXmlListener():void {
			var xmlDispatcher:EventDispatcher = _xmlManager.getDispatcher();
			xmlDispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
		}
		//------ Remove Listener ------------------------------------
		private function removeXmlListener():void {
			var xmlDispatcher:EventDispatcher = _xmlManager.getDispatcher();
			xmlDispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
		}
		//------ On Xml Loading Successfull ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void{
			removeXmlListener();
			dispatchEvent(evt);
		}
		//------Get Xml ------------------------------------
		public function getXml(xmlName:String):XML {
			var xml:XML =  _xmlManager.getXml(xmlName)
			return xml;
		}
		//------ Load Graphics From Path ------------------------------------
		public function loadGraphicsFromPath(path:String, name:String):void{
			initGraphicListener();
			_graphicManager.loadGraphicsFromPath(path,name);
		}
		//------ Load Graphics From Xlk ------------------------------------
		public function loadGraphicsFromXml(xml:XML, name:String):void{
			initGraphicListener();
			_graphicManager.loadGraphicsFromXml(xml,name);
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic(path:String, name:String):void{
			initGraphicListener();
			_graphicManager.loadGraphic(path, name);
		}
		//------ Init Graphic Listener ------------------------------------
		public function initGraphicListener():void {
			var graphicDispatcher:EventDispatcher = _graphicManager.getDispatcher();
			graphicDispatcher.addEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			graphicDispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
		}
		//------ Remove Graphic Listener ------------------------------------
		public function removeGraphicListener():void {
			var graphicDispatcher:EventDispatcher = _graphicManager.getDispatcher();
			graphicDispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			graphicDispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			
		}
		//------ On Graphic Loading Successful ------------------------------------
		public function onGraphicLoadingSuccessful(evt:Event):void {
			
			removeGraphicListener();
			dispatchEvent(evt);
		}
		//------ On Graphics Loading Progress ------------------------------------
		private function onGraphicLoadingProgress(evt:ProgressEvent):void {
			dispatchEvent(evt);		
		}
		//------Get Graphics ------------------------------------
		public function getGraphics():Array {
			return _graphicManager.getGraphics();
		}
		//------Get Graphic ------------------------------------
		public function getGraphic(graphicName:String):Sprite {
			return _graphicManager.getGraphic(graphicName);
		}
		//------Get Num Graphics To Load ------------------------------------
		public function getNumGraphicsToLoad():Number {
			return _graphicManager.getNumGraphicsToLoad();
		}
		//
		//------Display Graphic ------------------------------------
		public function displayGraphic(graphicName:String, graphic:Sprite, layerId:int):void {
			_graphicManager.displayGraphic(graphicName, graphic, layerId);
		}
		//------Remove Graphic ------------------------------------
		public function removeGraphic(graphicName:String):void {
			_graphicManager.removeGraphic(graphicName);
		}
	}
}