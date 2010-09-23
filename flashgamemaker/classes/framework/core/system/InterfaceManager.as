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
	import framework.add.screen.*;
	import utils.loader.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	
	/**
	* Interface Manager Class
	* @ purpose: Store and manage all the interfaces.
	*/
	public class InterfaceManager extends SimpleLoader implements IInterfaceManager{
		
		private static var _instance:IInterfaceManager=null;
		private static var _allowInstanciation:Boolean = false;
		private var _interfaceScreens:Dictionary = new Dictionary();
		private var _currentScreen:String = "NAN";
		
		public function InterfaceManager(){
			if(!_allowInstanciation){
				 throw new Error("Error: Instantiation failed: Use InterfaceManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IInterfaceManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance = new InterfaceManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			
		}
		//------ Preload ------------------------------------
		public function preloadInterface(path:String):void {
			initLoadingProgress();
			loadGraphicsFromPath(path, "Interface");
		}
		//------ Load ------------------------------------
		public function loadInterface(path:String, name:String):void {
			initLoadingProgress();
			loadGraphic(path, name);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			removeGraphicListener();
			removeLoadingProgress();
			initClassRef();
			registerScreen();
			dispatchEvent(new InterfaceEvent(InterfaceEvent.COMPLETE));
		}
		//------ Init Class Ref  ------------------------------------
		public  function initClassRef():void{
			//In order to import your interface screen classes in the compiled SWF and use them at runtime
			//please insert your interface screen classes here as follow 
			var menuScreen:MenuScreen;
			var configScreen:ConfigScreen;
			var helpScreen:HelpScreen;
			var aboutScreen:AboutScreen;
			var adScreen:AdScreen;
			var gameScreen:GameScreen;
		}
		//------ Register Screen ------------------------------------
		private  function registerScreen():void{
			var graphics:Array = _ressourceManager.getGraphics();
			for each (var obj:Object in graphics){
				var screenName:String = obj.name;
				var screenClip:MovieClip = obj.graphic as MovieClip;
				var screenClass:Class = getScreenClassByName(screenName);
				var interfaceScreen:InterfaceScreen=new screenClass(screenName, screenClip);
				_interfaceScreens[screenName] = interfaceScreen;
			}
        }
		//------ Get Screen Class By Name ------------------------------------
		private  function getScreenClassByName(screenName:String):Class {
			var classRef:Class=getDefinitionByName("framework.add.screen."+screenName) as Class;
			return (classRef);
		}
		//------ Display Interface Screen ------------------------------------
		public function goToScreen(screenName:String):void {
			var interfaceScreen:InterfaceScreen = _interfaceScreens[screenName];
			if(interfaceScreen==null){
				throw new Error ("The Screen:" + screenName + " is not registered !!" );
			}
			if(_currentScreen!="NAN"){
				interfaceScreen.removeEventListener(InterfaceEvent.NAVIGATION_CHANGE, onNavigationChange);
				_ressourceManager.removeGraphic(_currentScreen);
			}
			interfaceScreen.addEventListener(InterfaceEvent.NAVIGATION_CHANGE, onNavigationChange);
			interfaceScreen.checkEffStatut();
			interfaceScreen.isAnimated();
			_ressourceManager.displayGraphic(screenName, interfaceScreen);
			_currentScreen = screenName;
		}
		//------ On Navigation Change ------------------------------------
		public function onNavigationChange(evt:InterfaceEvent):void{
			var interfaceScreen:InterfaceScreen = _interfaceScreens[_currentScreen];
			var destination:String = interfaceScreen.getDestination();
			goToScreen(destination);
			dispatchEvent(evt);
		}
		//------ Get Current Screen ------------------------------------
		public  function getCurrentScreen():String {
			return _currentScreen;
		}
	}
}