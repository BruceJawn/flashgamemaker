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
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import framework.core.architecture.entity.IEntity;
	
	/**
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class EnterFrameComponent extends Component {
		
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		
		public function EnterFrameComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function initVar($prop:Object):void {
			_timeline = new Dictionary(true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("enterFrame");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "enterFrame") {
				if(!_timeline[$component]){
					addToTimeline($component, $param);
					if(!_isRunning){
						_isRunning = true;
						addEventListener(Event.ENTER_FRAME, onTick,false,0,true);
					}
				}
			}
		}
		//------ Add To Timeline  ------------------------------------
		private function addToTimeline($component:Component, $param:Object):void {
			if(!($param && $param.callback)) {
				throw new Error("To be registered to EnterFrameComponent you need a callback parameter");
			}
			_timeline[$component] = $param.callback;
		}
		//------ On Tick ------------------------------------
		private function onTick($evt:Event):void {
			for each (var callback:Function in _timeline){
				callback();
			}
		}
	}
}