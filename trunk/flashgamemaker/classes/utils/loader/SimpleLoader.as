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

package utils.loader {
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	
	/**
	* Simple Loader Class
	* @ purpose: Manage the loading of XML, BMP, SWF or Sound
	*/
	public class SimpleLoader extends LoaderDispatcher{
		
		protected var _ressourceManager:IRessourceManager = null;
		protected var _loadingProgress:LoadingProgress =null;
		
		public function SimpleLoader(){
			_ressourceManager = RessourceManager.getInstance();
		}
		//------ Init Loading Progress ------------------------------------
		protected function initLoadingProgress():void {
			_loadingProgress = new LoadingProgress();
			_ressourceManager.displayGraphic("LoadingProgress", _loadingProgress);
		}
		//------ Remove Loading Progress ------------------------------------
		protected function removeLoadingProgress():void {
			_ressourceManager.removeGraphic("LoadingProgress");
		}
		//------ Load Xml ------------------------------------
		protected function loadXml(path:String, xmlName:String):void{
			initXmlListener();
			_ressourceManager.loadXml(path, xmlName);
		}
		//------ Load Xmls From Path ------------------------------------
		protected function loadXmlsFromPath(path:String, xmlName:String):void{
			initXmlListener();
			_ressourceManager.loadXmlsFromPath(path, xmlName);
		}
		//------ Load Xmls From Xml ------------------------------------
		protected function loadXmlsFromXml(xml:XML, xmlName:String):void{
			initXmlListener();
			_ressourceManager.loadXmlsFromXml(xml, xmlName);
		}
		//------ Init Listener ------------------------------------
		protected function initXmlListener():void {
			var xmlDispatcher:EventDispatcher = _ressourceManager.getDispatcher();
			xmlDispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
		}
		//------ Remove Listener ------------------------------------
		protected function removeXmlListener():void {
			var xmlDispatcher:EventDispatcher = _ressourceManager.getDispatcher();
			xmlDispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
		}
		//------ Xml Loading Successful ------------------------------------
		protected function onXmlLoadingSuccessful(evt:Event):void {
			removeXmlListener();
		}
		//------ Load Graphics From Path ------------------------------------
		protected function loadGraphicsFromPath(path:String, name:String):void{
			initGraphicListener();
			_ressourceManager.loadGraphicsFromPath(path,name);
		}
		//------ Load Graphics From Xml ------------------------------------
		protected function loadGraphicsFromXml(xml:XML, name:String):void{
			initGraphicListener();
			_ressourceManager.loadGraphicsFromXml(xml,name);
		}
		//------ Load Graphics ------------------------------------
		protected function loadGraphic(path:String, name:String):void{
			initGraphicListener();
			_ressourceManager.loadGraphic(path, name);
		}
		//------ Init Listener ------------------------------------
		protected function initGraphicListener():void {
			var graphicDispatcher:EventDispatcher = _ressourceManager.getDispatcher();
			graphicDispatcher.addEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			graphicDispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
		}
		//------ Remove Listener ------------------------------------
		protected function removeGraphicListener():void {
			var graphicDispatcher:EventDispatcher = _ressourceManager.getDispatcher();
			graphicDispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			graphicDispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected function onGraphicLoadingSuccessful(evt:Event):void {
			removeGraphicListener();
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected function onGraphicLoadingProgress(evt:ProgressEvent):void {
			var bytesLoaded:Number = evt.bytesLoaded;
			var bytesTotal:Number = evt.bytesTotal;
			var graphicsToLoad:Number = _ressourceManager.getNumGraphicsToLoad();
			if(_loadingProgress!=null){
			   _loadingProgress.setValue( Math.floor( 100 * bytesLoaded / bytesTotal));
			    _loadingProgress.updateText(graphicsToLoad.toString());
			}
		}
	}
}