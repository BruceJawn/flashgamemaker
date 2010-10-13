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
		private var _jauge_stepDown:Number=2;
		private var _jauge_combinaison:String="";
		//KeyboardInput properties
		public var _keyboard_key:Object=null;
		//Timer properties
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function JaugeComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_jauge=createProgressBar(50,20,0,0,-90);
			_jauge.maximum=100;
			addChild(_jauge);
			_text=new TextField  ;
			_text.autoSize="left";
			_text.text= "Press 1 and 2 or Left and Right arrows to run";
			_text.x-=90;
			addChild(_text);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("jauge",_componentName);
			setPropertyReference("keyboardInput",_componentName);
			setPropertyReference("timer",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay && componentName==_componentName) {
				updateJauge();
			}else if(_timer_count>=_timer_delay){
				component._jauge_count = _jauge_count;
				component._jauge_max = _jauge_max;
				component._jauge = _jauge;
				component.refresh();
			}
		}
		//------ Update Jauge ------------------------------------
		private function updateJauge():void {
			if (_keyboard_key!=null) {
				var keyTouch:String=_keyboard_key.keyTouch;
				var prevTouch:String=_keyboard_key.prevTouch;
				var keyStatut:String=_keyboard_key.keyStatut;
				if ((keyTouch=="A"&&prevTouch=="B"||keyTouch=="B"&&prevTouch=="A" || keyTouch=="RIGHT"&&prevTouch=="LEFT"||keyTouch=="LEFT"&&prevTouch=="RIGHT")&&keyStatut=="DOWN"&&_jauge_count<_jauge_max /*&& _jauge_combinaison!=keyTouch+prevTouch*/) {
					_jauge_count+=_jauge_stepUp;
					_jauge_combinaison=keyTouch+prevTouch;
				} else if (_jauge_count-_jauge_stepDown>0) {
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
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}