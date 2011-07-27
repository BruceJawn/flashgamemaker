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
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class SystemInfoComponent extends SimpleGraphicComponent {
		private var _currentTime:Number = 0;
		private var _Memory:TextField=null;
		private var _FPS:TextField=null;
		private var _clip:TextField=null;
	
		public function SystemInfoComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_Memory = new TextField();
			_Memory.selectable = false;
			_FPS = new TextField();
			_FPS.selectable = false;
			_clip = new TextField();
			_clip.selectable = false;
			_Memory.x=50;
			_clip.x=_Memory.x+85;
			FlashGameMaker.AddChild(_Memory);
			FlashGameMaker.AddChild(_FPS);
			FlashGameMaker.AddChild(_clip);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("enterFrame", {onEnterFrame:onTick});
		}
		//------ On Enter Frame ------------------------------------
		private function onTick():void {
			updateMemory();
			updateFPS();
			updateTime();
			updateNumChildren();
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
		//------Update Number Children -------------------------------------
		public function updateNumChildren():void {
			_clip.text = "Clip :"+FlashGameMaker.numChildren;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("FPS:"+_FPS,"Mem:"+_Memory+ " MB");
		}

	}
}