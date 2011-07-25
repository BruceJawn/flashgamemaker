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
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	
	/**
	* PlayerComponent Class
	*/
	public class PlayerComponent extends GraphicComponent {

		protected var _keyPad:KeyPad=null;		//KeyboardInput property
		protected var _mousePad:MousePad=null;	//MouseInput property
		protected var _bitmapSet:BitmapSet = null	//BitmapAnim property
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
			_keyPad = new KeyPad;
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
			registerPropertyReference("keyboardMove");
			registerPropertyReference("mouseInput",{isListeningMouse:true, onMouseFire:onMouseFire});
			registerPropertyReference("mouseMove");
			registerPropertyReference("bitmapAnimComponent");
//			registerPropertyReference("aiInput");
//			registerPropertyReference("serverInput");
//			registerPropertyReference("animation");
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_bitmapSet = new BitmapSet($graphic as Bitmap);
			_bitmapSet.graph.createSimpleGraph();
			_graphic = new Bitmap;
			FlashGameMaker.AddChild(_graphic,this);
			actualize("bitmapAnim");
		}
		//------ On Key Fire ------------------------------------
		protected function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
			actualize("keyboardMove");
			updateGraph();
			actualize("bitmapAnim");
		}
		//------ On Mouse Fire ------------------------------------
		protected function onMouseFire($mousePad:MousePad):void {
			_mousePad = $mousePad;
			actualize("mouseMove");
		}
		//------ Update Graph------------------------------------
		protected function updateGraph():void {
			var graph:BitmapGraph = _bitmapSet.graph;
			if(_keyPad.right.isDown){
				graph.anim("RIGHT");
			}else if(_keyPad.left.isDown){
				graph.anim("LEFT");
			}else if(_keyPad.up.isDown){
				graph.anim("UP");
			}else if(_keyPad.down.isDown){
				graph.anim("DOWN");
			}/*else{
				graph.anim("STAND");
			}*/
		}
		//------ Get KeyPad ------------------------------------
		public function get keyPad():Object {
			return _keyPad;
		}
		//------ Get MousePad ------------------------------------
		public function get mousePad():MousePad {
			return _mousePad;
		}
		//------ Get BitmapSet ------------------------------------
		public function get bitmapSet():BitmapSet {
			return _bitmapSet;
		}
		//------ Getter ------------------------------------
		public function get speed():Point {
			return _speed;
		}
		public function get horizontalMove():Boolean {
			return _horizontalMove;
		}
		public function get verticalMove():Boolean {
			return _verticalMove;
		}
		public function get diagonalMove():Boolean {
			return _diagonalMove;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}