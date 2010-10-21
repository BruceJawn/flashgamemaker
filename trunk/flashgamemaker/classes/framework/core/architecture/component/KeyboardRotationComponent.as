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

	/**
	* KeyBoard Rotate Component 
	* @ purpose: 
	* 
	*/
	public class KeyboardRotationComponent extends GraphicComponent {
		
		private var _keyboardManager:IKeyboardManager=null;
		private var _degree:int=1;
		//KeyboardInput properties
		public var _keyboard_key:Object=null;

		public function KeyboardRotationComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {
			_keyboardManager=KeyboardManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardInput",_componentName);
			registerProperty("keyboardRotation",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			updateRotation(_keyboard_key,component);
		}
		//------ Update Dir  ------------------------------------
		private function updateRotation(keyboard_key:Object,component:*):void {
			if (keyboard_key!=null) {
				var keyTouch:String=keyboard_key.keyTouch;
				var prevTouch:String=keyboard_key.prevTouch;
				var keyStatut:String=keyboard_key.keyStatut;
				var doubleClick:Boolean=keyboard_key.doubleClick;
				if (keyStatut=="DOWN") {
					if (keyTouch=="RIGHT") {
						component._spatial_rotation=-_degree;
						component._spatial_properties.isMoving=true;
					} else if (keyTouch=="LEFT") {
						component._spatial_rotation=_degree;
						component._spatial_properties.isMoving=true;
					} else if (keyTouch=="UP") {

					} else if (keyTouch=="DOWN") {

					}
				} else if (keyStatut=="UP") {
					if (keyTouch=="RIGHT"||keyTouch=="LEFT"||prevTouch=="RIGHT"||prevTouch=="LEFT") {
						component._spatial_rotation=0;
						component._spatial_properties.isMoving=false;
					}
					if (keyTouch=="UP"||keyTouch=="DOWN"||prevTouch=="UP"||prevTouch=="DOWN") {

					}
				}
			}
		}

		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}