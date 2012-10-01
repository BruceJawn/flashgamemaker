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

package framework.component.core{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.component.Component;
	import framework.entity.*;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.time.Time;
	
	/**
	 * Chrono Class
	 * @ purpose: 
	 */
	public class ChronoComponent extends GraphicComponent {
		
		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=null;
		private var _bitmapData:BitmapData=null;
		private var _isRunning:Boolean = true;
		private var _callback:Function;
		
		private var _autoAnim:Boolean = true;
		private var _delay:Number=3500; 			//Timer properties
		private var _count:Number=3;
		private var _countMax:Number = 0;
		public var _reversed:Boolean = true;
		
		public function ChronoComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.delay)		_delay = $prop.delay;
			if($prop && $prop.hasOwnProperty("onChronoComplete"))	_callback = $prop.onChronoComplete;
		}
		//------ Create Chrono ------------------------------------
		private function createChrono($graphic:Bitmap=null):void {
			if(_bitmapData)			_bitmapData.dispose();
			if($graphic)			_source = $graphic;	
			_bitmapData = new BitmapData(_source.width/10*4,_source.height); // We suppose that the chrono doesn't exceed 9999 and that the source align the digits
			_bitmap = new Bitmap(_bitmapData);
			if(!contains(_bitmap))	addChild(_bitmap);
			actualizeChrono();
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function=null):void {
			createChrono($graphic as Bitmap)
			if($callback is Function)	$callback(this);
		}
		//------ Set graphic ------------------------------------
		public override function set graphic($graphic:*):void {
			createChrono($graphic as Bitmap);
		}
		//------ Actualize Score ------------------------------------
		public function actualizeChrono():void {
			if(_bitmapData!=null){
				_bitmapData.lock();
				_bitmapData.fillRect(_bitmapData.rect,0);
				var count:String = _count.toString();
				for (var i:int=0;i<count.length;i++){
					var X:int = Number(count.substr(count.length-i-1,1));
					_bitmapData.copyPixels(_source.bitmapData, new Rectangle(X*_source.width/10,0,_source.width/10 ,_source.height), new Point((count.length-i-1)*_source.width/10, 0),null,null,true);
				}
				_bitmapData.lock();
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			if(_isRunning){
				_reversed?_count--:_count++;
				actualizeChrono();
				if(_count==_countMax) 	stop();
			}
		}
		//------ Start ------------------------------------
		public function start($count:Number, $show:Boolean=true):void {
			if($count) 	_count = $count;
			if(!contains(_bitmap))		addChild(_bitmap);
			actualizeChrono();
			_isRunning = true;
			registerPropertyReference("timer",{callback:onTick, delay:_delay});
		}
		//------ Stop ------------------------------------
		public function stop($destroy:Boolean=true):void {
			dispatchEvent(new Event(Event.COMPLETE));
			if(_callback is Function)	_callback(this);
			_isRunning = false;
			unregisterPropertyReference("timer");
			if($destroy){
				visible=false;
				destroy();
			}
		}
		//------ Rest Chrono ------------------------------------
		public function reset($count:Number):void {
			_count = $count;
		}
	}
}