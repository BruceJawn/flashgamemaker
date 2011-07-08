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
	
	/**
	* SpatialComponent Class
	*/
	public class SpatialComponent extends Component {

		//KeyboardInput properties
		protected var _gamePad:Object=null;
		protected var _speed:Point=new Point(2,2);
		protected var _horizontalMove:Boolean = true;
		protected var _verticalMove:Boolean = true;
		protected var _diagonalMove:Boolean = true;
		
		public function SpatialComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
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
			registerProperty("spatial");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "spatial") {
				super.actualizePropertyComponent($propertyName,$component, $param);
				if(!$component.hasOwnProperty("gamePad")){
					throw new Error("A gamePad property is required to be registered by SpatialComponent!!");
				}
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component):void {
			var gamePad:Object=$component.gamePad;
			if(gamePad){
				if($component.iso){
					isoMoveComponent($component);
				}else{
					moveComponent($component);
				}
			}
		}
		//------ Move Component------------------------------------
		protected function moveComponent($component:Component):void {
		var gamePad:Object=$component.gamePad;
			if($component.diagonalMove){
				var horizontalMove:Boolean = $component.horizontalMove;
				var verticalMove:Boolean = $component.verticalMove;
				var diagonalMove:Boolean = $component.diagonalMove;
			}else{
				horizontalMove = _diagonalMove;
				verticalMove = _verticalMove;
				diagonalMove = _diagonalMove;
			}
			if(gamePad.upRight.isDown && diagonalMove){
				moveUpRight();
			}else if(gamePad.upLeft.isDown && diagonalMove){
				moveUpLeft();
			}else if(_gamePad.downRight.isDown && diagonalMove){
				moveDownRight();
			}else if(_gamePad.downLeft.isDown && diagonalMove){
				moveDownLeft();
			}else{
				if(_gamePad.right.isDown && horizontalMove){
					moveRight();
				}else if(_gamePad.left.isDown && horizontalMove){
					moveLeft();
				}else if(_gamePad.up.isDown && verticalMove){
					moveUp();
				}else if(_gamePad.down.isDown && verticalMove){
					moveDown();
				}
			}
		}
		//------ Iso Move Component------------------------------------
		protected function isoMoveComponent($component:Component):void {
			var gamePad:Object=$component.gamePad;
			if($component.diagonalMove){
				var horizontalMove:Boolean = $component.horizontalMove;
				var verticalMove:Boolean = $component.verticalMove;
				var diagonalMove:Boolean = $component.diagonalMove;
			}else{
				horizontalMove = _diagonalMove;
				verticalMove = _verticalMove;
				diagonalMove = _diagonalMove;
			}
			if(gamePad.upRight.isDown && diagonalMove){
				moveRight();
			}else if(gamePad.upLeft.isDown && diagonalMove){
				moveUp();
			}else if(gamePad.downRight.isDown && diagonalMove){
				moveDown();
			}else if(gamePad.downLeft.isDown && diagonalMove){
				moveLeft();
			}else{
				if(gamePad.right.isDown && horizontalMove){
					moveDownRight();
				}else if(gamePad.left.isDown && horizontalMove){
					moveUpLeft();
				}else if(gamePad.up.isDown && verticalMove){
					moveUpRight();
				}else if(gamePad.down.isDown && verticalMove){
					moveDownLeft();
				}
			}
		}
		//------ On Mouse Up ------------------------------------
		protected function onMouseDown($mouseObject:Object):void {
			var components:Vector.<Object> = getComponents();
			for each (var object:Object in components){
				var component:Component = object.component as Component;
				TweenLite.to(component,1,{x:$mouseObject.stageX, y:$mouseObject.stageY});
				
			}
		}
		//------ On Mouse Up ------------------------------------
		protected function onMouseUp($mouseObject:Object):void {
			//trace("test");
		}
		//------ Move UpRight ------------------------------------
		public function moveUpRight():void {
			move(1,-1);
		}
		//------ Move UpLeft ------------------------------------
		public function moveUpLeft():void {
			move(-1,-1);
		}
		//------ Move DownRight ------------------------------------
		public function moveDownRight():void {
			move(1,1);
		}
		//------ Move DownLeft ------------------------------------
		public function moveDownLeft():void {
			move(-1,1);
		}
		//------ Move Right ------------------------------------
		public function moveRight():void {
			move(1,0);
		}
		//------ Move Left ------------------------------------
		public function moveLeft():void {
			move(-1,0);
		}
		//------ Move Up ------------------------------------
		public function moveUp():void {
			move(0,-1);
		}
		//------ Move Down ------------------------------------
		public function moveDown():void {
			move(0,1);
		}
		//------ Move ------------------------------------
		protected function move($x:Number, $y:Number):void {
			var components:Vector.<Object> = getComponents();
			for each (var object:Object in components){
				var component:Component = object.component as Component;
				if(component.hasOwnProperty("speed")){
					component.x+= $x * component.speed.x;
					component.y+= $y * component.speed.y;
				}else{
					component.x+= $x * _speed.x;
					component.y+= $y * _speed.y;
				}
			}
		}
		//------ Get components ------------------------------------
		private function getComponents():Vector.<Object> {
			return _properties["keyboard2DMove"];
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}