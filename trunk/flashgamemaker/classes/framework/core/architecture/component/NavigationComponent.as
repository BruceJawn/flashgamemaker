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
	import flash.text.TextField;

	/**
	* Navigation Component Class
	*
	*
	*/
	public class NavigationComponent extends GraphicComponent {

		private var _entityManager:IEntityManager=null;
		private var _startBt:SimpleButton=null;
		private var _scriptName:String=null;
		private var _label:TextField=null;

		public function NavigationComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			_graphic=getGraphic(_graphicName) as MovieClip;
			if (_graphic!=null) {
				_startBt=_graphic.startBt;
				if (_startBt!=null) {
					_startBt.addEventListener(MouseEvent.CLICK, onStart);
				}
				_label=_graphic.label;
				if (_label!=null) {
					var name:Array=_scriptName.split(".");
					_label.text=name[name.length-1];
				}
				setGraphic(_graphicName,_graphic);
				dispatchEvent(evt);
			}
		}
		//------- Set Script -------------------------------
		public function setScript(scriptName:String):void {
			_scriptName=scriptName;
		}
		//------- Lauch Script -------------------------------
		public function launchScript():void {
			if (_scriptName!=null) {
				var classRef:Class=getClass(_scriptName);
				new classRef(_scriptName);
				FlashGameMaker.STAGE.focus=FlashGameMaker.STAGE;
				removeComponent(_componentName);
			}
		}
		//------- On Start -------------------------------
		private function onStart(evt:MouseEvent):void {
			launchScript();
		}
		//------ Gets class name from instance ------------------------------------
		private function getClass(scriptName:String):Class {
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