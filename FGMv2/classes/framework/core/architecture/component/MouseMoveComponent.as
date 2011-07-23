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
	import com.greensock.TweenLite;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.mouse.MousePad;
	
	/**
	* KeyboardMoveComponent Class
	*/
	public class MouseMoveComponent extends Component {
		public static var CLICK:int = 0;
		public static var PRESS:int = 1;
		//MouseInput properties
		protected var _mousePad:MousePad = null;
		protected var _type:int = PRESS;//PRESS or CLICK
		
		public function MouseMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			_mousePad = new MousePad();
			if($prop && $prop.type)		_type = $prop.type;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseMove");
			registerPropertyReference("mouseInput",{isListeningMouse:true, onMouseFire:onMouseFire});
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "mouseMove") {
				moveComponent($component);
			}
		}
		//------ On Mouse Fire ------------------------------------
		protected function onMouseFire($mousePad:MousePad):void {
			_mousePad = $mousePad;
		}
		//------ Move Component------------------------------------
		protected function moveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("mousePad") && $component.mousePad){
				var mousePad:MousePad=$component.mousePad;
			}else{
				mousePad=_mousePad;
			}
			//Move
			if(mousePad.mouseEvent && mousePad.mouseEvent.buttonDown){
				onMouseDown(mousePad, $component);
			}else if(mousePad.mouseEvent){
				onMouseUp(mousePad, $component);
			}
		}
		//------ On Mouse Up ------------------------------------
		protected function onMouseDown($mousePad:MousePad, $component:Component):void {
			TweenLite.to($component,1,{x:$mousePad.mouseEvent.stageX, y:$mousePad.mouseEvent.stageY});
		}
		//------ On Mouse Up ------------------------------------
		protected function onMouseUp($mousePad:MousePad, $component:Component):void {
			if($component.hasOwnProperty("type")){
				var type:int = $component.type;
			}else{
				type =_type;
			}
			if(type==PRESS){
				TweenLite.killTweensOf($component);
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}