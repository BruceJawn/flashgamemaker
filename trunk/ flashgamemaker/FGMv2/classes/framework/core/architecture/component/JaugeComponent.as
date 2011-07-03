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
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	import flash.text.TextField;

	/**
	* Jauge Class
	* @ purpose: 
	*/
	public class JaugeComponent extends GraphicComponent {

		private var _text:TextField=null;
		private var _jauge:ProgressBar=null;
		private var _jauge_count:Number=0;
		private var _jauge_max:Number=100;
		private var _jauge_stepUp:Number=4;
		private var _jauge_stepDown:Number=1;
		private var _jauge_direction:String="right";
		private var _prevKey:Object=new Object;
		private var _isListening:Boolean=true;
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function JaugeComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_jauge=createProgressBar(50,20,0,0,0);
			_jauge.setStyle("themeColor", 0xFF0000);
			_jauge.maximum=100;
			addChild(_jauge);
			_text=new TextField  ;
			_text.autoSize="left";
			_text.text= "Press Left and Right arrows to run";
			_text.x-=70;
			_text.y+=20;
			addChild(_text);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("jauge");
			registerPropertyReference("keyboardInput");
			registerPropertyReference("timer");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String, componentOwner:String, component:Component):void {
			if (componentName==_componentName && (_timer_count>=_timer_delay||! _timer_on) && _isListening) {
				updateJauge();
				//update("jauge");
			}else if (componentName!=_componentName && _isListening){
				component._jauge_count = _jauge_count;
				component._jauge_max = _jauge_max;
				component._jauge = _jauge;
				component.actualizeComponent(componentName,componentOwner,component);
			}
		}
		//------ Update Jauge ------------------------------------
		private function updateJauge():void {
			if (_keyboard_gamePad!=null) {
				if (_keyboard_gamePad.right.isDown &&_jauge_count<_jauge_max) {
					if(_prevKey==_keyboard_gamePad.left && !_prevKey.isDown){
						_jauge_count+=_jauge_stepUp;
					}
					_prevKey = _keyboard_gamePad.right;
				}else if (_keyboard_gamePad.left.isDown &&_jauge_count<_jauge_max) {
					if(_prevKey==_keyboard_gamePad.right && !_prevKey.isDown){
						_jauge_count+=_jauge_stepUp;
					}
					_prevKey = _keyboard_gamePad.left;
				}
				else if (_jauge_count-_jauge_stepDown>0) {
					_jauge_count-=_jauge_stepDown;
				}else {
					_jauge_count=0;
				}
				
				_jauge.setProgress(_jauge_count,_jauge_max);
			}
		}
		//------ Create Progress Bar ------------------------------------
		public function createProgressBar(width:Number,height:Number,x:Number,y:Number,rotation:Number):ProgressBar {
			var progressBar:ProgressBar=new ProgressBar  ;
			progressBar.mode=ProgressBarMode.MANUAL;
			progressBar.setSize(width,height);
			progressBar.move(x,y);
			progressBar.rotation=rotation;
			return progressBar;
		}
		//------- Set Text -------------------------------
		public function setText(text:String):void {
			_text.text =text;
		}
		//------- Set Text Position -------------------------------
		public function setTextPosition(x:Number, y:Number):void {
			_text.x =x;
			_text.y =y;
		}
		//------- setDirection -------------------------------
		public function setDirection(direction:String):void {
			if(_jauge_direction!=direction && direction=="right"){
			_jauge_direction=direction;
			_jauge.rotation = 0;
			}else if(_jauge_direction!=direction && direction=="left"){
			_jauge_direction=direction;
			_jauge.rotation = 180;
			}else if(_jauge_direction!=direction && direction=="up"){
			_jauge_direction=direction;
			_jauge.rotation = -90;
			}else if(_jauge_direction!=direction && direction=="down"){
			_jauge_direction=direction;
			_jauge.rotation = 90;
			}
		}
		//------- isListeneing -------------------------------
		public function isListening(value:Boolean):void {
			_isListening=value;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}