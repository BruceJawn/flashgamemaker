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
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;

	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.display.*;
	import flash.utils.Dictionary;
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;

	/**
	* LoadingProgress Class
	* @ purpose: 
	*/
	public class LoadingBarComponent extends Component {

		private var _graphicManager:IGraphicManager=null;
		private var _listeners:Dictionary=null;

		public function LoadingBarComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicManager=GraphicManager.getInstance();
			_listeners = new Dictionary();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("loadingBar",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_listeners[component]==null) {
				component.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
				var progressBar:ProgressBar=createProgressBar(100,16,0,0);
				_listeners[component]=progressBar;
				component.addChild(progressBar);
			}
		}
		//------ On Graphic Loading Progress ------------------------------------
		private function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			var bytesLoaded:Number=evt.bytesLoaded;
			var bytesTotal:Number=evt.bytesTotal;
			var component:* =evt.target;
			var progressBar:ProgressBar=_listeners[component];
			progressBar.maximum = bytesTotal;
			progressBar.setProgress(bytesLoaded,bytesTotal);
			if(bytesLoaded==bytesTotal){
				component.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
				component.removeChild(progressBar);
			}
		}
		//------ createProgressBar ------------------------------------
		private function createProgressBar(width:Number,height:Number,x:Number,y:Number):ProgressBar {
			var progressBar:ProgressBar = new ProgressBar();
			progressBar.mode=ProgressBarMode.MANUAL;
			progressBar.setSize(width, height);
			progressBar.move(x, y);
			return progressBar;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}