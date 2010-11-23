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
	import framework.core.system.SoundManager;
	import framework.core.system.ISoundManager;

	import flash.events.EventDispatcher;
	import flash.events.*;

	/**
	* Sound Component
	* @ purpose: 
	* 
	*/
	public class SoundComponent extends GraphicComponent {

		private var _soundManager:ISoundManager=null;
		//Sound properties
		public var _sound_name:String;
		public var _sound_path:String;
		public var _sound_volume:Number=0.5;//Between 0 and 100
		public var _sound_isPlaying:Boolean=false;
		public var _sound_play:Boolean=false;
		public var _sound_position:Number=0;

		public function SoundComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_soundManager=SoundManager.getInstance();
			_sound_name="MySound";
			_sound_path="sound/sound.mp3";
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			/*if (! component._sound_isPlaying&&component._sound_play) {
			component._sound_isPlaying=true;
			_soundManager.play(component._sound_name,component._sound_path,component._sound_volume);
			} else if (component._sound_isPlaying&&! component._sound_play) {
			component._sound_isPlaying=false;
			_soundManager.stop(component._sound_name);
			}*/
		}

		//------- Play -------------------------------
		public function play(path:String,name:String, volume:Number):void {
			_sound_name=name;
			_sound_path=path;
			_sound_volume=volume;
			_sound_isPlaying=true;
			_soundManager.play(_sound_name,_sound_path,_sound_volume);
		}
		//------- ToString -------------------------------
		public override function reset(ownerName:String,componentName:String):void {
			if (_sound_isPlaying) {
				_sound_isPlaying=false;
				_sound_play=false;
				_soundManager.stop(_sound_name);
			}
		}
		//------- SetController -------------------------------
		public function setController(path:String,name:String):void {
			loadGraphic(path,name);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,onGraphicLoadingProgress);
			if (_graphicName!=null) {
				_graphic=_graphicManager.getGraphic(_graphicName);
				_graphic.addEventListener(MouseEvent.CLICK,onClick);
				addChild(_graphic);
				dispatchEvent(evt);
			}
		}
		//------- On Click -------------------------------
		private function onClick(evt:MouseEvent):void {
			if (_graphic.currentFrame==1) {
				_graphic.nextFrame();
				_sound_isPlaying=false;
				_sound_position=_soundManager.stop(_sound_name);
			} else {
				_graphic.prevFrame();
				_sound_isPlaying=true;
				_soundManager.resume(_sound_name, _sound_position);
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}