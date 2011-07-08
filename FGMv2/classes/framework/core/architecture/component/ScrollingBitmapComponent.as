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
	import flash.display.*;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.iso.IsoPoint;

	/**
	* Scrolling Bitmap Component
	* @ purpose: 
	*/
	public class ScrollingBitmapComponent extends GraphicComponent {

		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=new Bitmap();
		private var _rectangle:Rectangle=null;
		private var _scrollingTarget:*=null;
		private var _loop:Boolean=true;
		private var _autoScroll:Boolean = true;
		private var _speed:Point=new Point(1,0);
		private var _isRunning:Boolean = false;
		
		public function ScrollingBitmapComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function initVar($prop:Object):void {
			if($prop && $prop.speed)		_speed 		= $prop.speed;
			if($prop && $prop.autoScroll)	_autoScroll = $prop.autoScroll;
			if($prop && $prop.loop)			_loop 		= $prop.loop;
			_rectangle=new Rectangle(0,0,FlashGameMaker.width,FlashGameMaker.height);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			addEventListener(Event.ENTER_FRAME, onTick);
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			removeEventListener(Event.ENTER_FRAME, onTick);
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_source = $graphic as Bitmap;
			_bitmap.bitmapData = new BitmapData(_rectangle.width,_source.height );
			_bitmap.bitmapData.copyPixels(_source.bitmapData,_source.bitmapData.rect , new Point(0, 0),null,null,true);
			addChild(_bitmap);
			if(_autoScroll){
				start();
			}
		}
		//------ On Tick ------------------------------------
		private function onTick($evt:Event):void {
			scrollBitmap();
		}
		//----- Scroll Bitmap  -----------------------------------
		public function scrollBitmap():void {
			if(_speed.x!=0){//Horizontal
				scrollH();
			}
			if(_speed.y!=0){//Vertical
				scrollV();
			}
		}
		//----- Scroll Horizontal  -----------------------------------
		public function scrollH():void {
			if(_rectangle.x+_rectangle.width+_speed.x<_source.width){
				_rectangle.x+=_speed.x;
			}else if(_loop){
				if(_rectangle.x+_speed.x<_source.width){
					_rectangle.x+=_speed.x;
					var dist:Number = _rectangle.x+_rectangle.width+_speed.x - _source.width;
					var rect1:Rectangle = new Rectangle(_rectangle.x, _rectangle.y, _rectangle.width-dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_source.bitmapData,rect1 , new Point(0, 0),null,null,true);
					var rect2:Rectangle = new Rectangle(0, _rectangle.y, dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_source.bitmapData,rect2 , new Point(_rectangle.width-dist, 0),null,null,true);
					return;
				}else{
					_rectangle.x=0;
				}
			}else{
				_rectangle.x=_source.width-_rectangle.width;
			}
			_bitmap.bitmapData.copyPixels(_source.bitmapData,_rectangle , new Point(0, 0),null,null,true);
		}
		//----- Scroll Vertical  -----------------------------------
		public function scrollV():void {
			if(_rectangle.y+_rectangle.height+_speed.y<_source.height){
				_rectangle.y+=_speed.y;
			}else if(_loop){
				if(_rectangle.y+_speed.y<_source.height){
					_rectangle.y+=_speed.y;
					var dist:Number = _rectangle.y+_rectangle.height+_speed.y - _source.height;
					var rect1:Rectangle = new Rectangle(_rectangle.y, _rectangle.y, _rectangle.height-dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_source.bitmapData,rect1 , new Point(0, 0),null,null,true);
					var rect2:Rectangle = new Rectangle(0, _rectangle.y, dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_source.bitmapData,rect2 , new Point(_rectangle.height-dist, 0),null,null,true);
					return;
				}else{
					_rectangle.y=0;
				}
			}else{
				_rectangle.y=_source.height-_rectangle.height;
			}
			_bitmap.bitmapData.copyPixels(_source.bitmapData,_rectangle , new Point(0, 0),null,null,true);
		}
		//----- Scroll  -----------------------------------
		public function scroll(x:Number,y:Number):void {
			_rectangle.x=x;
			_rectangle.y=y;
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
		//----- Set Loop -----------------------------------
		public function set loop(loop:Boolean):void {
			_loop=loop;
		}
		//------Stop ------------------------------------
		public function start():void {
			if(!_isRunning){
				initListener();
				_isRunning = true;
			}
		}
		//------Stop ------------------------------------
		public function stop():void {
			if(_isRunning){
				removeListener();
				_isRunning = false;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}