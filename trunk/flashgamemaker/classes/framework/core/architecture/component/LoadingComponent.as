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
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;

	import flash.display.*;
	import flash.events.*;

	/**
	* LoadingComponent Class
	* @ purpose: 
	*/
	public class LoadingComponent extends GraphicComponent {

		private var _ressourceManager:IRessourceManager=null;
		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=null;
		private var _xmlPath:String=null;
		private var _xmlName:String=null;
		private var _xml:XML=null;
		private var _count:int=0;

		public function LoadingComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			if (_graphicName!=null&&_graphic==null) {
				_graphic=_graphicManager.getGraphic(_graphicName) as MovieClip;
				setGraphic(_graphicName,_graphic);
				center();
				createLoading();
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		//------ Create Chrono ------------------------------------
		private function createLoading():void {
			if (_graphic!=null) {
				var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
				dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
				_ressourceManager.loadXml(_xmlPath,_xmlName);
			}
		}
		//------ On Xml Loading Successfull ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void {
			_xml=_ressourceManager.getXml(_xmlName);
			if (_xml!=null) {
				var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
				dispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
				loadGraphicsFromXml(_xml, _xmlName);
			}
		}
		//------ Preload Graphic ------------------------------------
		public function preloadGraphic(path:String,name:String):void {
			_xmlPath=path;
			_xmlName=name;
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected override function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			if (_graphic!=null) {
				var _progressBar:Number=Math.floor(100*evt.bytesLoaded/evt.bytesTotal);
				var _countBar:Number=_count/_xml.children().length();
				_graphic.clip.bar.x=- _graphic.clip.bar.width/_progressBar/100;
				_graphic.text.text="Loading " +_progressBar+" %";
				_graphic.clip2.bar.x=- _graphic.clip.bar.width/_countBar/100+5;
				_graphic.text2.text="Modules " +Number(_count+1)+"/"+_xml.children().length();
				if (_progressBar==100) {
					_count++;
				}
			}
		}
	}
}