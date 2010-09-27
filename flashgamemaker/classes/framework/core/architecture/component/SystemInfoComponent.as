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
	import utils.time.Time;
	
	import flash.text.TextField;
	import flash.events.Event;
	import flash.system.System;
	import flash.geom.Point;
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class SystemInfoComponent extends Component {
		private var _currentTime:Number = 0;
		private var _Memory:TextField=null;
		private var _FPS:TextField=null;
		//Render properties
		public var _render_layerId:int=0;
		public var _render_alpha:Number;
		//Spatial properties
		public var _spatial_position:Point = null;

		public function SystemInfoComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_spatial_position = new Point(0,0);
			_render_alpha = 1;
			
			_Memory = new TextField();
			_FPS = new TextField();
			_Memory.x+=80;
			addChild(_Memory);
			addChild(_FPS);
			
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			setPropertyReference("render",_componentName);
			setPropertyReference("spatial",_componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		//------ On Enter Frame ------------------------------------
		private function onEnterFrame(event:Event):void {
			updateMemory();
			updateFPS();
			updateTime();
		}
		//------Update Memory -------------------------------------
		public function updateMemory():void {
			_Memory.text = "Mem :"+(Math.round((System.totalMemory/1048576)*10)/10).toString()+" MB";
		}
		//------Update FPS -------------------------------------
		public function updateFPS():void {
			var fps:Number = 1/((Time.GetTime()-_currentTime)/1000);
			_FPS.text="FPS: "+Math.round(fps).toString();
		}
		//------Update Time -------------------------------------
		public function updateTime():void {
			_currentTime = Time.GetTime();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("FPS:"+_FPS,"Mem:"+_Memory+ " MB");
		}

	}
}