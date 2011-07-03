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

package framework.add.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class RPGTextComponent extends GraphicComponent {

		private var _index:int=0;
		private var _xml:XML=null;
		private var _textBlockIndex:Number=0;
		private var _ressourceManager:IRessourceManager=null;

		public function RPGTextComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_ressourceManager=RessourceManager.getInstance();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("progressBar");
		}
		//------Set Sequence -------------------------------------
		public function setSequence(sequence:String):void {
			_xml=new XML(sequence);
		}
		//------Set Sequence -------------------------------------
		public function setSequenceFromPath(path:String,textName:String):void {
//			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
//			dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			//_ressourceManager.loadXml(path,textName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject):void {
			
		}
		//------ UpdateText ------------------------------------
		private function updateText():void {
//			var xml:XMLList=_xml.children();
//			graphic.clip.contentTxt.text="";
//			graphic.clip.titleTxt.text=xml[_index].@title;
//			addEventListener(Event.ENTER_FRAME,typeWritter);// start updating the text  
//			//graphic.clip.charIcon.text=_xml.children()[0];
		}
		//------ Type Writter ------------------------------------
		private function typeWritter(e:Event):void {
//			var xml:XMLList=_xml.children();
//			var content:String=xml[_index];
//			if (graphic.clip.contentTxt.text.length<content.length) {
//				graphic.clip.contentTxt.text=content.substr(0,graphic.clip.contentTxt.length+1);
//			} else {
//				removeEventListener(Event.ENTER_FRAME,typeWritter);
//			}
		}
		//------ On Next Click ------------------------------------
		private function onNextClick(evt:MouseEvent):void {
//			var xml:XMLList=_xml.children();
//			var content:String=xml[_index];
//			if (graphic.clip.contentTxt.text.length<content.length) {
//				graphic.clip.contentTxt.text=xml[_index];
//			} else {
//				_index++;
//				if (xml.length()==_index) {
//					graphic.clip.nextBt.removeEventListener(MouseEvent.CLICK,onNextClick);
//					dispatchEvent(new Event("_RPGTextCOMPLETE"));
//					entity.removeComponentFromName(_componentName);
//					return;
//				}
//				updateText();
//			}
		}
		//------ On Prev Click ------------------------------------
		private function onPrevClick(evt:MouseEvent):void {
//			if (_index>0) {
//				_index--;
//				var xml:XMLList=_xml.children();
//				graphic.clip.contentTxt.text=xml[_index];
//				graphic.clip.titleTxt.text=xml[_index].@title;
//			}
		}
		//------ On Xml Loading Successfull ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void {
			trace(evt.target);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("* RPGTextComponent");
		}
	}
}