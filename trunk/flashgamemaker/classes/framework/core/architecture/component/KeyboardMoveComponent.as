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
	public class KeyboardMoveComponent extends Component {

		private var _keyboardManager:IKeyboardManager=null;
		private var _xmlConfig:TextField=null;
		//KeyboardInput properties
		public var _keyboard_key:Object=null;

		public function KeyboardMoveComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {
			_keyboardManager=KeyboardManager.getInstance();
			_xmlConfig=new TextField  ;
			_xmlConfig.autoSize="left";
			var xmlConfig:XMLList=_keyboardManager.getXmlConfig();
			if (xmlConfig!=null) {
				_xmlConfig.text=xmlConfig.toString();
				//addChild(_xmlConfig);
			}
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardMove",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			component._keyboard_key=_keyboard_key;
			if (componentName==_componentName) {
				update("keyboardMove");
			} else {
				updateDir(_keyboard_key,component);
			}
		}
		//------ Update Dir  ------------------------------------
		private function updateDir(keyboard_key:Object,component:*):void {
			if (keyboard_key!=null) {
				var keyTouch:String=keyboard_key.keyTouch;
				var prevTouch:String=keyboard_key.prevTouch;
				var keyStatut:String=keyboard_key.keyStatut;
				var doubleClick:Boolean=keyboard_key.doubleClick;
				var spatialDirection:String=component._spatial_properties.direction;
				var spatialStrict:Boolean=component._spatial_properties.strict;
				if (keyStatut=="DOWN") {
					if (keyTouch=="RIGHT" && (spatialDirection=="Diagonal" || spatialDirection=="Horizontal"|| !spatialStrict)) {
						component._spatial_dir.x=1;
					} else if (keyTouch=="LEFT" && (spatialDirection=="Diagonal" || spatialDirection=="Horizontal"|| !spatialStrict)) {
						component._spatial_dir.x=-1;
					} else if (keyTouch=="UP" && (spatialDirection=="Diagonal" || spatialDirection=="Vertical"|| !spatialStrict)) {
						component._spatial_dir.y=-1;
					} else if (keyTouch=="DOWN" && (spatialDirection=="Diagonal" || spatialDirection=="Vertical"|| !spatialStrict)) {
						component._spatial_dir.y=1;
					} else if (keyTouch=="JUMP" && !component._spatial_properties.isJumping && !component._spatial_properties.isFalling) {
						component._spatial_jump.z=component._spatial_jumpStart.z;
						component._spatial_properties.isJumping=true;
						component._spatial_properties.isFalling=false;
					}
				} else if (keyStatut=="UP") {
					if (keyTouch=="RIGHT"||keyTouch=="LEFT"||prevTouch=="RIGHT"||prevTouch=="LEFT") {
						component._spatial_dir.x=0;
					}
					if (keyTouch=="UP"||keyTouch=="DOWN"||prevTouch=="UP"||prevTouch=="DOWN") {
						component._spatial_dir.y=0;
					}
				}
				isMoving(component,keyboard_key);
			}
		}
		//------ Is Moving  ------------------------------------
		private function isMoving(component:*,keyboard_key:Object):void {
			var keyTouch:String=keyboard_key.keyTouch;
			var prevTouch:String=keyboard_key.prevTouch;
			var keyStatut:String=keyboard_key.keyStatut;
			var doubleClick:Boolean=keyboard_key.doubleClick;
			var shiftKey:Boolean=keyboard_key.shiftKey;

			if (component._spatial_dir.x!=0||component._spatial_dir.y!=0||component._spatial_dir.z!=0||component._spatial_jump.x!=0||component._spatial_jump.y!=0||component._spatial_jump.z!=0) {
				component._spatial_properties.isMoving=true;
				if (doubleClick||shiftKey) {
					component._spatial_properties.isRunning=true;
				}
			} else {
				component._spatial_properties.isMoving=false;
				component._spatial_properties.isRunning=false;
				component._spatial_properties.isAttacking=false;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}