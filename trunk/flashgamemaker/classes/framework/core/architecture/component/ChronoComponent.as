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
	import framework.core.system.TimeManager;
	import framework.core.system.ITimeManager;
	import utils.time.Time;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	* Chrono Class
	* @ purpose: 
	*/
	public class ChronoComponent extends GraphicComponent {
		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=null;

		private var _timeManager:ITimeManager=null;
		private var _chrono:TextField=null;
		private var _chrono_on:Boolean=false;
		private var _chrono_deleteAutomcatically:Boolean=true;
		private var _chrono_max:Number=9;
		private var _chrono_count:Number=9;
		private var _chrono_statut:Boolean=false;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=800;
		public var _timer_count:Number=0;

		public function ChronoComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_timeManager=TimeManager.getInstance();
			_chrono=new TextField  ;
			setFormat("Arial",30,0xFF0000);
			addChild(_chrono);
			_chrono_count=_chrono_max;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("timer",_componentName);
		}
		//------Set Format -------------------------------------
		private function setFormat(font:String=null,size:Object=null,color:Object=null,bold:Object=null,italic:Object=null,underline:Object=null,url:String=null,target:String=null,align:String=null):void {
			var textFormat:TextFormat=new TextFormat(font,size,color,bold,italic,underline,url,target,align);
			_chrono.defaultTextFormat=textFormat;
			_chrono.autoSize="center";
			_chrono.selectable=false;
		}
		//------ Restart Chrono ------------------------------------
		public function start():void {
			_chrono_count=_chrono_max;
			_chrono_on=true;
		}
		//------ Stop Chrono ------------------------------------
		public function stop():void {
			_chrono_on=false;
		}
		//------ Restart Chrono ------------------------------------
		public function restart(max:Number=3):void {
			_chrono_max=max;
			_chrono_count=_chrono_max;
			updateText();
			_chrono_on=true;
			
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay&&_chrono_count>0&&_chrono_on) {
				updateChrono();
				if (_source==null) {
					updateText();
				} else {
					actualizeChrono();
				}
			}
		}
		//------ Update Chrono ------------------------------------
		private function updateChrono():void {
			_chrono_count--;
			if (_chrono_count==0&&_chrono_deleteAutomcatically) {
				dispatchEvent(new Event(Event.COMPLETE));
				removeComponent(_componentName);
			} else if (_chrono_count==0) {
				_chrono.text="START";
				stop();
				dispatchEvent(new Event("COMPLETE"));
			}
		}
		//------ Set Chrono ------------------------------------
		public function setChrono(path:String,name:String):void {
			loadGraphic(path,name);
			if (contains(_chrono)) {
				removeChild(_chrono);
			}
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,onGraphicLoadingProgress);
			if (_graphicName!=null) {
				_source=_graphicManager.getGraphic(_graphicName) as Bitmap;
				createChrono();
			}
		}
		//------ Create Chrono ------------------------------------
		private function createChrono():void {
			if (_source!=null) {
				var myBitmapData:BitmapData=new BitmapData(_source.width/5,_source.height,true,0);
				_bitmap=new Bitmap(myBitmapData);
				setGraphic(_graphicName,_bitmap);
				actualizeChrono();
			}
		}
		//------ Get Time ------------------------------------
		private function updateText():void {
			_chrono.text=_chrono_count.toString();
		}
		//------ ActualizeChrono ------------------------------------
		public function actualizeChrono():void {
			if (_bitmap!=null) {
				var myBitmapData:BitmapData=_bitmap.bitmapData;
				myBitmapData.fillRect(myBitmapData.rect,0);
				var X:int=Math.floor(_chrono_count/10);
				var Y:int=_chrono_count%10;
				myBitmapData.copyPixels(_source.bitmapData,new Rectangle(X*_source.width/10,0,_source.width/10,_source.height),new Point(0,0),null,null,true);
				myBitmapData.copyPixels(_source.bitmapData,new Rectangle(Y*_source.width/10,0,_source.width/10,_source.height),new Point(_source.width/10,0),null,null,true);
			}
		}
	}
}