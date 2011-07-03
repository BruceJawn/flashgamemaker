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

package framework.core.architecture.component {
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import framework.core.architecture.entity.*;

	/**
	* SimpleGraphicComponent is the basic class for a graphical component
	*/
	public class SimpleGraphicComponent extends Component{
		//Render properties
		protected var _layer:int	= 0;
		protected var _align:String	= null;		
		//Background properties
		private var _color:uint = 0xFFFFFF;
		private var _alpha:Number = 1; // Value between 0 and 1
		private var _type:String = null; //GradientType.LINEAR or GradientType.RADIAL
		private var _colors:Array = null;
		private var _alphas:Array = null;
		private var _ratios:Array = null;
		private var _matrix:Matrix = null;
		private var _rectangle:Rectangle = null; //Background position and size
		
		public function SimpleGraphicComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false , $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			//data: graphic, layer, alpha, align, mask, x, y, scaleX, scaleY
			if ($prop != null) {
				if($prop.layer)			_layer 	= $prop.layer;
				if($prop.align)			_align 	= $prop.align;
				setBgColor($prop);
			}
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("render");
		}
		//------ Move to  ------------------------------------
		public function moveTo($x:Number, $y:Number):void {
			x = $x;
			y = $y;
		}
		//------ Scale to  ------------------------------------
		public function scaleTo($scaleX:Number, $scaleY:Number):void {
			scaleX = $scaleX;
			scaleY = $scaleY;
		}
		//------ SetMask  ------------------------------------
		public function setRectMask(x:int,y:int,width:int,height:int):void {
			var rectMask:Sprite = new Sprite();
			rectMask.graphics.beginFill(0x0000FF);
			rectMask.graphics.drawRect(x,y,width,height);
			rectMask.graphics.endFill();
			mask = rectMask;
		}
		//------- Set Color -------------------------------
		public  function setBgColor($prop:Object):void {
				_color = $prop.color;
				_alpha = $prop.alpha;
				_type = $prop.type;
				_colors = $prop.colors;
				_alphas = $prop.alphas;
				_ratios = $prop.ratios;
				_matrix = $prop.matrix;
				_matrix = $prop.matrix;
				_matrix = $prop.matrix;
				_matrix = $prop.matrix;
				_rectangle = $prop.rectangle;
				if (_color && _alpha){
					graphics.beginFill(_color, _alpha);
				}else if (_type && _colors && _alphas && _ratios) {
					graphics.beginGradientFill(_type, _colors, _alphas, _ratios, _matrix);
				}
			if(_rectangle){
					//if a Rectangle is provided for x, y, width and height of background
					graphics.drawRect(_rectangle.x, _rectangle.y, _rectangle.width, _rectangle.height);
			}
			else if(width == 0 || height == 0){
				//if the Sprite is empty then the bg is of same size as the Stage
				graphics.drawRect(0, 0, FlashGameMaker.width, FlashGameMaker.height);
			}else{
				graphics.drawRect(0, 0, width, height);
			}
			graphics.endFill();	
		}
		//------ Get layer  ------------------------------------
		public function get layer():int {
			return _layer;
		}
		//------ Set layer  ------------------------------------
		public function set layer($layer:int):void {
			_layer=$layer;
		}
		//------ Get align  ------------------------------------
		public function get align():String {
			return _align;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("* SimpleGraphicComponent", componentName, entityName);
		}
	}
}