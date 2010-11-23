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
	import utils.iso.IsoPoint;

	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.events.*;

	/**
	* Scrolling Bitmap Component
	* @ purpose: 
	*/
	public class ScrollingBitmapComponent extends GraphicComponent {

		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=null;
		private var _offset:Number=5;
		private var _rectangle:Rectangle=null;
		private var _position:IsoPoint=new IsoPoint(0,0);
		private var _initialPosition:IsoPoint=null;
		private var _loop:Boolean=false;
		private var _direction:IsoPoint=null;
		private var _speed:Point=new Point(1,0);
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function ScrollingBitmapComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_rectangle=new Rectangle(0,0,FlashGameMaker.WIDTH,FlashGameMaker.HEIGHT);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("progressBar",_componentName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			if (getGraphic(_graphicName)!=null) {
				_source=getGraphic(_graphicName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(_rectangle.width,_rectangle.height,true,0);
				myBitmapData.copyPixels(_source.bitmapData, _rectangle, new Point(0, 0),null,null,true);
				_bitmap=new Bitmap(myBitmapData);
				setGraphic(_graphicName,_bitmap);
				dispatchEvent(evt);
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay && _timer_on && _bitmap!=null) {
				scrollBitmap();
			} else if (!_timer_on && _keyboard_gamePad!=null) {
				//scrollBitmapKeyboard();
			}
		}
		//----- Set Loop -----------------------------------
		public function setLoop(loop:Boolean):void {
			_loop=loop;
		}
		//----- Scroll Bitmap  -----------------------------------
		public function scrollBitmap():void {
			if ((_direction!= null && _direction.x>0) || (_loop &&  _speed.x>0)) {//RIGHT
				if (_rectangle.x+_offset+_bitmap.width<=_source.width) {
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_rectangle.x+_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
				} else if (_loop) {
					var dist:Number=_rectangle.x+_offset+_bitmap.width-_source.width;
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_rectangle.x+_offset, 0,_bitmap.width-dist,_bitmap.height), new Point(0, 0),null,null,true);
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(0, 0,dist,_bitmap.height), new Point(_bitmap.width-dist, 0),null,null,true);
				}
				_rectangle.x+=_offset;
				if (_rectangle.x>_source.width) {
					_rectangle.x=_rectangle.x-_source.width;
				}
			} else if ((_direction!= null && _direction.x<0) || (_loop &&  _speed.x<0)) {//LEFT
				if (_rectangle.x-_offset>=0) {
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_rectangle.x-_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
				} else if (_loop) {
					dist=Math.abs(_rectangle.x-_offset);
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_rectangle.x, 0,_bitmap.width-dist,_bitmap.height), new Point(dist, 0),null,null,true);
					_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_source.width-dist, 0,dist,_bitmap.height), new Point(0, 0),null,null,true);
				}
				_rectangle.x-=_offset;
				if (Math.abs(_rectangle.x)>_source.width) {
					_rectangle.x=-(Math.abs(_rectangle.x)-_source.width);
				}
			}
		}
		//----- Set Direction -----------------------------------
		public function setDirection(direction:IsoPoint):void {
			_direction=direction;
		}
		//----- Scroll  -----------------------------------
		public function scroll(x:Number,y:Number):void {
			_rectangle.x=x;
			_rectangle.y=y;
		}
		//----- Scroll Bitmap Keyboard  -----------------------------------
		public function scrollBitmapKeyboard():void {
			if (_keyboard_gamePad.right.isDown) {
				_direction.x=1;
			} else if (_keyboard_gamePad.left.isDown) {
				_direction.x=-1;
			}else if (_keyboard_gamePad.up.isDown) {
				_direction.y=1;
			}else if (_keyboard_gamePad.down.isDown) {
				_direction.y=-1;
			}else{
				_direction.x=0;
				_direction.y=0;
			}
			scrollBitmap();
		}
		//----- Flip BitmapData  -----------------------------------
		public function flipBitmapData(myBitmapData:BitmapData):void {
			var flipHorizontalMatrix:Matrix = new Matrix();
			flipHorizontalMatrix.scale(-1,1);
			flipHorizontalMatrix.translate(myBitmapData.width,0);
			var flippedBitmapData:BitmapData=new BitmapData(myBitmapData.width,myBitmapData.height,true,0);
			flippedBitmapData.draw(myBitmapData,flipHorizontalMatrix);
			myBitmapData.fillRect(myBitmapData.rect,0);
			myBitmapData.draw(flippedBitmapData);
		}
		//------ SetScrolling  ------------------------------------
		public function setScrolling(delay:Number, offset:Number=5):void {
			_timer_delay=delay;
			_offset=offset;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}