﻿/*
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
	import framework.core.system.PhysicManager;
	import framework.core.system.IPhysicManager;
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;

	/**
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardInputMoveComponent extends Component {
		
		//KeyboardInput properties
		public var _key:Object=null;

		public function KeyboardInputMoveComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardMoveInput", _componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {

		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			var spatial_force:IsoPoint=parseKey(_key);
			component._spatial_force.x=spatial_force.x;
			component._spatial_force.y=spatial_force.y;
			component._spatial_force.z=spatial_force.z;
		}
		//------ Parse Key  ------------------------------------
		private function parseKey(key:Object):IsoPoint {
			var spatial_force:IsoPoint=new IsoPoint(0,0);
			if (key!=null) {
				var keyTouch:String=key.keyTouch;
				var keyStatut:String=key.keyStatut;
				if (keyTouch=="RIGHT"&&keyStatut=="DOWN") {
					spatial_force.x=1;
				} else if (keyTouch == "RIGHT" && keyStatut == "UP") {
					spatial_force.x=0;
				} else if (keyTouch == "LEFT" && keyStatut == "DOWN") {
					spatial_force.x=-1;
				} else if (keyTouch == "LEFT" && keyStatut == "UP") {
					spatial_force.x=0;
				} else if (keyTouch == "UP" && keyStatut == "DOWN") {
					spatial_force.y=-1;
				} else if (keyTouch == "UP" && keyStatut == "UP") {
					spatial_force.y=0;
				} else if (keyTouch == "DOWN" && keyStatut == "DOWN") {
					spatial_force.y=1;
				} else if (keyTouch == "DOWN" && keyStatut == "UP") {
					spatial_force.y=0;
				}
			}
			return spatial_force;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}