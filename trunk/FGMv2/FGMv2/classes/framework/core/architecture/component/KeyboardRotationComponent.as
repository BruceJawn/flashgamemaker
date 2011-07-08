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
		public var _keyboard_gamePad:Object=null;

		public function KeyboardRotationComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {
			_keyboardManager=KeyboardManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("keyboardInput");
			registerProperty("keyboardRotation");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
			if (componentName==_componentName) {
				//update("keyboardRotation");
			} else {
				updateRotation(_keyboard_gamePad,component);
			}
		}
		//------ Update Dir  ------------------------------------
		private function updateRotation(_keyboard_gamePad:Object,component:*):void {
			if (_keyboard_gamePad!=null) {
				if (_keyboard_gamePad.right.isDown) {
					component._spatial_rotation=- _degree;
					component._spatial_properties.isMoving=true;
				} else if (_keyboard_gamePad.left.isDown) {
					component._spatial_rotation=_degree;
					component._spatial_properties.isMoving=true;
				} else if (_keyboard_gamePad.up.isDown) {

				} else if (_keyboard_gamePad.down.isDown) {

				} else {
					component._spatial_rotation=0;
					component._spatial_properties.isMoving=false;
				}
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}