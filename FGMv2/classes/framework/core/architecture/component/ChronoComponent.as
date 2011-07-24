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
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.core.architecture.entity.*;
	
	import utils.bitmap.BitmapSet;
	import utils.time.Time;

	/**
	* Chrono Class
	* @ purpose: 
	*/
	public class ChronoComponent extends GraphicComponent {
		
		private var _bitmapSet:BitmapSet = null;	//BitmapAnim property
		private var _delay:Number=1000; 			//Timer properties
		
		private var _chronoTF:TextField=null;
		private var _running:Boolean=false;
		private var _count:Number=9;
		private var _currentValue:Number;
		public var _inversed:Boolean = false;

		public function ChronoComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.delay)	_delay = $prop.delay;
			reset(_count);
			/*_chronoTF=new TextField  ;
			setFormat("Arial",30,0xFF0000);
			addChild(_chronoTF);*/
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("timer",{callback:onTick, delay:_delay});
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_bitmapSet = new BitmapSet($graphic as Bitmap);
			_bitmapSet.graph.createGraph("CHRONO", 0,0,32,45,10)
			_graphic = new Bitmap;
			FlashGameMaker.AddChild(_graphic,this);
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			_bitmapSet.graph.anim("CHRONO");
		}
		//------Set Format -------------------------------------
		private function setFormat(font:String=null,size:Object=null,color:Object=null,bold:Object=null,italic:Object=null,underline:Object=null,url:String=null,target:String=null,align:String=null):void {
			var textFormat:TextFormat=new TextFormat(font,size,color,bold,italic,underline,url,target,align);
			_chronoTF.defaultTextFormat=textFormat;
			_chronoTF.autoSize="center";
			_chronoTF.selectable=false;
		}
		//------ Start Chrono ------------------------------------
		public function start():void {
			_running=true;
		}
		//------ Stop Chrono ------------------------------------
		public function stop():void {
			_running=false;
		}
		//------ Rest Chrono ------------------------------------
		public function reset($count:Number):void {
			_count = $count;
			if(_inversed){
				_currentValue = 0;
			}else{
				_currentValue = _count;
			}
			_running=false;
		}
		//------ Update Chrono ------------------------------------
		private function updateChrono():void {
			/*_chronoTF_count--;
			if (_chronoTF_count==0&&_chronoTF_deleteAutomcatically) {
				dispatchEvent(new Event(Event.COMPLETE));
				entity.removeComponentFromName(_componentName);
			} else if (_chronoTF_count==0) {
				_chronoTF.text="START";
				stop();
				dispatchEvent(new Event("COMPLETE"));
			}*/
		}
		//------ Get Time ------------------------------------
		private function updateText():void {
			_chronoTF.text=_currentValue.toString();
		}
		//------ ActualizeChrono ------------------------------------
		public function actualizeChrono():void {
			
		}
	}
}