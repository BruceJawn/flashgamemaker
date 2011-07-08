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
	
	import utils.iso.IsoPoint;
	
	/**
	* PlayerComponent Class
	*/
	public class PlayerComponent extends GraphicalComponent {

		//KeyboardInput properties
		protected var _gamePad:Object=null;
		//MouseInput properties
		protected var _mouseObject:Object=null;
		//AiInput properties
		//ServerInput properties
		//Player properties
		protected var _speed:IsoPoint=new IsoPoint(2,2);
		protected var _horizontalMove:Boolean = true;
		protected var _verticalMove:Boolean = true;
		protected var _diagonalMove:Boolean = true;
		
		public function PlayerComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			if($prop && $prop.speed)		_speed 			= $prop.speed;
			if($prop && $prop.horizontal)	_horizontalMove = $prop.horizontal;
			if($prop && $prop.vertical)		_verticalMove 	= $prop.vertical;
			if($prop && $prop.diagonal)		_diagonalMove 	= $prop.diagonal;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("player");
			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
//			registerPropertyReference("mouseInput",{isListeningMouse:true, onMouseDown:onMouseEvent, onMouseUp:onMouseEvent });
//			registerPropertyReference("aiInput");
//			registerPropertyReference("serverInput");
			registerPropertyReference("spatial");
//			registerPropertyReference("animation");
		}
		//------ On Key Fire ------------------------------------
		protected function onKeyFire($gamePad:Object):void {
			_gamePad = $gamePad;
		}
		//------ On Key Fire ------------------------------------
		protected function onMouseEvent($mouseObject:Object):void {
			_mouseObject = $mouseObject;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}