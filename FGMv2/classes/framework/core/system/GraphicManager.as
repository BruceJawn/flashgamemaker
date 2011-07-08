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

package framework.core.system{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import utils.loader.GraphicLoader;
	
	/**
	* Interface Class
	* @ purpose: Implements the core game engine interface.
	*/
	public class GraphicManager extends EventDispatcher implements IGraphicManager {

		private static var _instance:IGraphicManager=null;
		private static var _allowInstanciation:Boolean=false;
	
		private var _graphicLoader:GraphicLoader=null;
		private var _pool:Array=null;
		private var _graphics:Dictionary = new Dictionary();
		private var _loader:Object;// Keep a reference to the object loaded
		
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
			_graphics = new Dictionary();
			_pool = new Array();
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic($path:String, $callBack:Object):void {
			var loadedClass:Class = _graphics[$path];
			if ( loadedClass && $callBack.hasOwnProperty("onComplete")) {
				$callBack.onComplete(new loadedClass());
			}
			else if (_graphicLoader && _graphicLoader.isLoading) {
				_pool.push({path:$path, callBack:$callBack});
			}else{
				_loader = {path:$path, callBack:$callBack};
				_graphicLoader=new GraphicLoader();
				_graphicLoader.addEventListener(Event.INIT, onGraphicLoadingInit,false,0, true);
				_graphicLoader.addEventListener(Event.COMPLETE, onGraphicLoadingComplete,false,0, true);
				_graphicLoader.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress,false,0, true);
				_graphicLoader.loadGraphic($path);
			}
		}
		//------ On Graphic Loading Complete ------------------------------------
		private function onGraphicLoadingComplete( evt:Event ):void {
			var callBack:Object = _loader.callBack;
			var source:DisplayObject = evt.target.loader.content;
			var loadedClass:Class = Object(source).constructor;
			var clone:DisplayObject = new loadedClass() as DisplayObject;
			if(callBack.hasOwnProperty("onComplete")){
				callBack.onComplete(source);//Should be clone but not working
			}
			_graphics[_loader.path]= loadedClass;
			if(_pool.length>0){
				var loader:Object = _pool.pop();
				loadGraphic(loader.path, loader.callBack);
			}
		}
		//------ On Graphic Loading Init ------------------------------------
		private function onGraphicLoadingInit( evt:Event ):void {
			var callBack:Object = _loader.callBack;
			if(callBack.hasOwnProperty("onInit")){
				callBack.onInit();
			}
		}
		//------ On Graphic Loading Progress ------------------------------------
		private function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			var callBack:Object = _loader.callBack;
			if(callBack.hasOwnProperty("onProgress")){
				callBack.onProgress(evt);
			}
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}