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
	import framework.core.system.KeyboardManager;
	import framework.core.system.IKeyboardManager;
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.text.TextField;

	/**
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardMoveComponent extends GraphicComponent {

		private var _keyboardManager:IKeyboardManager=null;
		//KeyboardInput properties
		public var _keyboard_key:Object=null;
		private var _xmlConfig:TextField=null;

		public function KeyboardMoveComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {
			_keyboardManager=KeyboardManager.getInstance();
			_xmlConfig = new TextField();
			_xmlConfig.autoSize="left";
			var xmlConfig:XMLList=_keyboardManager.getXmlConfig();
			if (xmlConfig!=null) {
				_xmlConfig.text=xmlConfig.toString();
				//addChild(_xmlConfig);
				_spatial_position.x=250;
				_spatial_position.y=200;
			}
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardMove", _componentName);
			setPropertyReference("render",_componentName);
			setPropertyReference("spatial",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			var keyboardMove_iso:Boolean = component._keyboardMove_iso;
			var spatial_dir:IsoPoint=getKey(_keyboard_key,keyboardMove_iso);
			component._spatial_dir.x=spatial_dir.x;
			component._spatial_dir.y=spatial_dir.y;
			component._spatial_dir.z=spatial_dir.z;
			component._spatial_isMoving=isMoving(spatial_dir);
			component._keyboard_key=_keyboard_key;
		}
		//------ Get Key  ------------------------------------
		protected function getKey(keyboard_key:Object,keyboardMove_iso:Boolean):IsoPoint {
			var spatial_dir:IsoPoint=new IsoPoint(0,0);
			if (keyboard_key!=null) {
				var keyTouch:String=keyboard_key.keyTouch;
				var keyStatut:String=keyboard_key.keyStatut;
				if(keyboardMove_iso){
					if (keyTouch=="RIGHT"&&keyStatut=="DOWN") {
					spatial_dir.x=1;
					spatial_dir.y=1;
					} else if (keyTouch == "RIGHT" && keyStatut == "UP") {
						spatial_dir.x=0;
						spatial_dir.y=0;
					} else if (keyTouch == "LEFT" && keyStatut == "DOWN") {
						spatial_dir.x=-1;
						spatial_dir.y=-1;
					} else if (keyTouch == "LEFT" && keyStatut == "UP") {
						spatial_dir.x=0;
						spatial_dir.y=0;
					} else if (keyTouch == "UP" && keyStatut == "DOWN") {
						spatial_dir.x=1;
						spatial_dir.y=-1;
					} else if (keyTouch == "UP" && keyStatut == "UP") {
						spatial_dir.x=0;
						spatial_dir.y=0;
					} else if (keyTouch == "DOWN" && keyStatut == "DOWN") {
						spatial_dir.x=-1;
						spatial_dir.y=1;
					} else if (keyTouch == "DOWN" && keyStatut == "UP") {
						spatial_dir.x=0;
						spatial_dir.y=0;
					}
				}else{
					if (keyTouch=="RIGHT"&&keyStatut=="DOWN") {
						spatial_dir.x=1;
					} else if (keyTouch == "RIGHT" && keyStatut == "UP") {
						spatial_dir.x=0;
					} else if (keyTouch == "LEFT" && keyStatut == "DOWN") {
						spatial_dir.x=-1;
					} else if (keyTouch == "LEFT" && keyStatut == "UP") {
						spatial_dir.x=0;
					} else if (keyTouch == "UP" && keyStatut == "DOWN") {
						spatial_dir.y=-1;
					} else if (keyTouch == "UP" && keyStatut == "UP") {
						spatial_dir.y=0;
					} else if (keyTouch == "DOWN" && keyStatut == "DOWN") {
						spatial_dir.y=1;
					} else if (keyTouch == "DOWN" && keyStatut == "UP") {
						spatial_dir.y=0;
					}
				}
				
			}
			return spatial_dir;
		}
		//------ Is Moving  ------------------------------------
		private function isMoving(spatial_dir:IsoPoint):Boolean {
			if (spatial_dir.x!=0||spatial_dir.y!=0||spatial_dir.z!=0) {
				return true;
			}
			return false;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}