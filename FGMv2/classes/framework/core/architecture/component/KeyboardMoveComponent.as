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
	
	import utils.keyboard.KeyPad;
	
	/**
	* KeyboardMoveComponent Class
	*/
	public class KeyboardMoveComponent extends Component {

		//KeyboardInput properties
		protected var _keyPad:KeyPad=null;
		protected var _speed:Point=new Point(2,2);
		protected var _horizontalMove:Boolean = true;
		protected var _verticalMove:Boolean = true;
		protected var _diagonalMove:Boolean = true;
		
		public function KeyboardMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			_keyPad = new KeyPad();
			if($prop && $prop.speed)		_speed 			= $prop.speed;
			if($prop && $prop.horizontal)	_horizontalMove = $prop.horizontal;
			if($prop && $prop.vertical)		_verticalMove 	= $prop.vertical;
			if($prop && $prop.diagonal)		_diagonalMove 	= $prop.diagonal;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardMove");
			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
		}
		//------ On Key Fire ------------------------------------
		protected function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardMove") {
				updateComponent($component);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component):void {
			if($component.hasOwnProperty("iso") && $component.iso){
				isoMoveComponent($component);
			}else{
				moveComponent($component);
			}
		}
		//------ Move Component------------------------------------
		protected function moveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("keyPad") && $component.keyPad){
				var keyPad:KeyPad=$component.keyPad;
			}else{
				keyPad=_keyPad;
			}
			if($component.hasOwnProperty("diagonalMove")&& $component.hasOwnProperty("horizontalMove")&& $component.hasOwnProperty("verticalMove")){
				var horizontalMove:Boolean = $component.horizontalMove;
				var verticalMove:Boolean = $component.verticalMove;
				var diagonalMove:Boolean = $component.diagonalMove;
			}else{
				horizontalMove = _diagonalMove;
				verticalMove = _verticalMove;
				diagonalMove = _diagonalMove;
			}
			//Move
			if(keyPad.upRight.isDown && diagonalMove){
				moveUpRight($component);
			}else if(keyPad.upLeft.isDown && diagonalMove){
				moveUpLeft($component);
			}else if(keyPad.downRight.isDown && diagonalMove){
				moveDownRight($component);
			}else if(keyPad.downLeft.isDown && diagonalMove){
				moveDownLeft($component);
			}else{
				if(keyPad.right.isDown && horizontalMove){
					moveRight($component);
				}else if(keyPad.left.isDown && horizontalMove){
					moveLeft($component);
				}else if(keyPad.up.isDown && verticalMove){
					moveUp($component);
				}else if(keyPad.down.isDown && verticalMove){
					moveDown($component);
				}
			}
		}
		//------ Iso Move Component------------------------------------
		protected function isoMoveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("keyPad") && $component.keyPad){
				var keyPad:KeyPad=$component.keyPad;
			}else{
				keyPad=_keyPad;
			}
			if($component.hasOwnProperty("diagonalMove")&& $component.hasOwnProperty("horizontalMove")&& $component.hasOwnProperty("verticalMove")){
				var horizontalMove:Boolean = $component.horizontalMove;
				var verticalMove:Boolean = $component.verticalMove;
				var diagonalMove:Boolean = $component.diagonalMove;
			}else{
				horizontalMove = _diagonalMove;
				verticalMove = _verticalMove;
				diagonalMove = _diagonalMove;
			}
			if(keyPad.upRight.isDown && diagonalMove){
				moveRight($component);
			}else if(keyPad.upLeft.isDown && diagonalMove){
				moveUp($component);
			}else if(keyPad.downRight.isDown && diagonalMove){
				moveDown($component);
			}else if(keyPad.downLeft.isDown && diagonalMove){
				moveLeft($component);
			}else{
				if(keyPad.right.isDown && horizontalMove){
					moveDownRight($component);
				}else if(keyPad.left.isDown && horizontalMove){
					moveUpLeft($component);
				}else if(keyPad.up.isDown && verticalMove){
					moveUpRight($component);
				}else if(keyPad.down.isDown && verticalMove){
					moveDownLeft($component);
				}
			}
		}
		//------ Move UpRight ------------------------------------
		public function moveUpRight($component:Component):void {
			move(1,-1, $component);
		}
		//------ Move UpLeft ------------------------------------
		public function moveUpLeft($component:Component):void {
			move(-1,-1, $component);
		}
		//------ Move DownRight ------------------------------------
		public function moveDownRight($component:Component):void {
			move(1,1, $component);
		}
		//------ Move DownLeft ------------------------------------
		public function moveDownLeft($component:Component):void {
			move(-1,1, $component);
		}
		//------ Move Right ------------------------------------
		public function moveRight($component:Component):void {
			move(1,0, $component);
		}
		//------ Move Left ------------------------------------
		public function moveLeft($component:Component):void {
			move(-1,0, $component);
		}
		//------ Move Up ------------------------------------
		public function moveUp($component:Component):void {
			move(0,-1, $component);
		}
		//------ Move Down ------------------------------------
		public function moveDown($component:Component):void {
			move(0,1, $component);
		}
		//------ Move ------------------------------------
		protected function move($x:Number, $y:Number, $component:Component):void {
			if($component.hasOwnProperty("speed")){
				$component.x+= $x * $component.speed.x;
				$component.y+= $y * $component.speed.y;
			}else{
				$component.x+= $x * _speed.x;
				$component.y+= $y * _speed.y;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}