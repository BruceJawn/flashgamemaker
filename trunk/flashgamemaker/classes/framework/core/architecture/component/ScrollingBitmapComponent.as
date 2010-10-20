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
		private var _position:Point=new Point(0,0);
		private var _direction:String="Horizontal";
		private var _speed:Point=new Point(1,0);
		//KeyboardInput properties
		public var _keyboard_key:Object=null;
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
				var width:Number=FlashGameMaker.WIDTH;
				var height:Number=FlashGameMaker.HEIGHT;
				var myBitmapData:BitmapData=new BitmapData(width,height,true,0);
				myBitmapData.copyPixels(_source.bitmapData, new Rectangle(0, 0,width,height), new Point(0, 0),null,null,true);
				_bitmap=new Bitmap(myBitmapData);
				setGraphic(_graphicName,_bitmap);
				//displayGraphic(_graphicName,_bitmap,1);
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			//scrollBitmap();
			if (_timer_count>=_timer_delay) {
				loopBitmap();
			}
		}
		//----- Scroll Bitmap  -----------------------------------
		public function scrollBitmap():void {
			if (_keyboard_key!=null&&_keyboard_key.keyStatut=="DOWN") {
				if (_keyboard_key.keyTouch=="RIGHT" && (_direction=="Diagonal" || _direction=="Horizontal")) {
					if (_position.x+_offset+_bitmap.width<=_source.width) {
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x+_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
					} else {
						var dist:Number=_position.x+_offset+_bitmap.width-_source.width;
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x+_offset, 0,_bitmap.width-dist,_bitmap.height), new Point(0, 0),null,null,true);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(0, 0,dist,_bitmap.height), new Point(_bitmap.width-dist, 0),null,null,true);
					}
					_position.x+=_offset;
					if (_position.x>_source.width) {
						_position.x=_position.x-_source.width;
					}
				} else if (_keyboard_key.keyTouch=="LEFT" && (_direction=="Diagonal" || _direction=="Horizontal")) {
					if (_position.x-_offset>=0) {
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x-_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
					} else {
						dist=Math.abs(_position.x-_offset);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x, 0,_bitmap.width-dist,_bitmap.height), new Point(dist, 0),null,null,true);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_source.width-dist, 0,dist,_bitmap.height), new Point(0, 0),null,null,true);
					}
					_position.x-=_offset;
					if (Math.abs(_position.x)>_source.width) {
						_position.x=-(Math.abs(_position.x)-_source.width);
					}
				}
			}
		}
		//----- Loop Bitmap  -----------------------------------
		public function loopBitmap():void {
			if (_bitmap!=null&&_source!=null) {
				if (_speed.x>0 && (_direction=="Diagonal" || _direction=="Horizontal")) {
					if (_position.x+_offset+_bitmap.width<=_source.width) {
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x+_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
					} else {
						var dist:Number=_position.x+_offset+_bitmap.width-_source.width;
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x+_offset, 0,_bitmap.width-dist,_bitmap.height), new Point(0, 0),null,null,true);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(0, 0,dist,_bitmap.height), new Point(_bitmap.width-dist, 0),null,null,true);
					}
					_position.x+=_offset;
					if (_position.x>_source.width) {
						_position.x=_position.x-_source.width;
					}
				} else if (_speed.x<0 && (_direction=="Diagonal" || _direction=="Horizontal")) {
					if (_position.x-_offset>=0) {
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x-_offset, 0,_bitmap.width,_bitmap.height), new Point(0, 0),null,null,true);
					} else {
						dist=Math.abs(_position.x-_offset);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_position.x, 0,_bitmap.width-dist,_bitmap.height), new Point(dist, 0),null,null,true);
						_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(_source.width-dist, 0,dist,_bitmap.height), new Point(0, 0),null,null,true);
					}
					_position.x-=_offset;
					if (Math.abs(_position.x)>_source.width) {
						_position.x=-(Math.abs(_position.x)-_source.width);
					}
				}
			}
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
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String,componentName:String):void {
			removeGraphic(_graphicName);
		}
		//------ SetScrolling  ------------------------------------
		public  function setScrolling(delay:Number, offset:Number=5):void {
			_timer_delay=delay;
			_offset=offset;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}