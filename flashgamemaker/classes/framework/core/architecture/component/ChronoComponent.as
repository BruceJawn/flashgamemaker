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
	import utils.time.Time;
	import framework.core.system.TimeManager;
	import framework.core.system.ITimeManager;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	/**
	
	/**
	* Chrono Class
	* @ purpose: 
	*/
	public class ChronoComponent extends GraphicComponent {
		private var _timeManager:ITimeManager = null;
		private var _chrono:TextField=null;
		private var _chrono_max:Number = 3;
		private var _chrono_count:Number = 3;
		private var _chrono_statut:Boolean = false;
		//Timer properties
		public var _timer_delay:Number=800;
		public var _timer_count:Number=0;
		
		public function ChronoComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_timeManager = TimeManager.getInstance();
			_chrono = new TextField();
			setFormat("Arial",30,0xFF0000);
			addChild(_chrono);						
			_chrono_count = _chrono_max;
			updateText();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("timer",_componentName);
		}
		//------Set Format -------------------------------------
		private function setFormat(font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null):void {
			var textFormat:TextFormat = new TextFormat(font, size,color,bold,italic,underline,url,target,align);
			_chrono.defaultTextFormat = textFormat;
			_chrono.autoSize = "center";
		}
		//------ Restart Chrono ------------------------------------
		public  function restartChrono():void {
			_chrono_count = _chrono_max;
		}
		//------ Reset Chrono ------------------------------------
		public  function resetChrono(max:Number):void {
			_chrono_max = max;
			_chrono_count = _chrono_max;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay && _chrono_count>0) {
				updateChrono();
				updateText();
			}
		}
		//------ Update Chrono ------------------------------------
		private function updateChrono():void {
			_chrono_count--;
		}
		//------ Get Time ------------------------------------
		private function updateText():void {
			if(_chrono_count==0){
				_chrono.text= "START";
			}else{
				_chrono.text = _chrono_count.toString();
			}
		}
	}
}