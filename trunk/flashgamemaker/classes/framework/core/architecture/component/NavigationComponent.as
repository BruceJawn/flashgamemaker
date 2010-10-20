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
*   Under this licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;

	/**
	* Navigation Component Class
	*
	*
	*/
	public class NavigationComponent extends GraphicComponent {

		private var _entityManager:IEntityManager=null;
		private var _startBt:SimpleButton=null;
		private var _scriptName:String=null;
		private var _navigation:GraphicComponent=null;
		
		public function NavigationComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_navigation=_entityManager.addComponent(_componentOwner.getName(),"GraphicComponent","myGraphicNavigation");
			_navigation.loadGraphic("texture/framework/interface/navigationScreen.swf","NavigationScreen");
			_navigation.addEventListener(Event.COMPLETE,onNavigationLoadingSuccessful);
		}
		//------ On Navigation Loading Successful ------------------------------------
		private function onNavigationLoadingSuccessful( evt:Event ):void {
			_navigation.removeEventListener(Event.COMPLETE,onNavigationLoadingSuccessful);
			var navigationScreen:MovieClip = getGraphic("NavigationScreen") as MovieClip;
			_startBt = navigationScreen.startBt;
			_startBt.addEventListener(MouseEvent.CLICK, onStart);
		}
		//------- Set Script -------------------------------
		public function setScript(scriptName:String):void {
			_scriptName = scriptName;
		}
		//------- Lauch Script -------------------------------
		public function launchScript():void {
			if(_scriptName!=null){
				var classRef:Class = getClass(_scriptName);
				new classRef(_scriptName);
				removeComponent("myGraphicNavigation");
				removeComponent(_componentName);
			}
		}
		//------- On Start -------------------------------
		private function onStart(evt:MouseEvent):void {
			launchScript();
		}
		//------ Gets class name from instance ------------------------------------
		private function getClass(scriptName:String):Class{
			var classRef:Class=getDefinitionByName("script."+scriptName) as Class;
			return (classRef);
		}
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String,componentName:String):void {
			_startBt.removeEventListener(MouseEvent.CLICK, onStart);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}