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
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import framework.entity.*;
	import framework.system.ISoundManager;
	import framework.system.SoundManager;

	/**
	* Sound Component
	* @ purpose: 
	* 
	*/
	public class SoundComponent extends GraphicComponent {

		private var _soundManager:ISoundManager=null;
		private var _soundPath:String	=null;
		private var _volume:Number		=0.5;//Between 0 and 100
		private var _isPlaying:Boolean	=false;
		private var _soundChannel:SoundChannel= null;
		private var _sound:Sound 		= null;
		private var _position:Number 	= 0;

		public function SoundComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		override protected function initVar($prop:Object):void {
			_soundManager=SoundManager.getInstance();
			if($prop && $prop.hasOwnProperty("volume")){
				_volume = $prop.volume;
			}
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Set Sound ------------------------------------
		public function set sound($sound:Sound):void {
			_sound = $sound;
		}
		//------ Set Sound ------------------------------------
		public function loadSound($soundPath:String,$callback:Function=null):void {
			_soundPath = $soundPath;
			_soundManager.loadSound($soundPath,$callback);
		}
		//------ Play ------------------------------------
		public function play($volume:Number=-1):void {
			if($volume==-1)		$volume = _volume;
			_isPlaying = true;
			_soundChannel = _sound.play();
			_soundChannel.soundTransform.volume = $volume;
		}
		//------ Resume ------------------------------------
		public function resume($volume:Number=-1):void {
			if($volume==-1)		$volume = _volume;
			_isPlaying = true;
			_soundChannel = _sound.play(_position);
			_soundChannel.soundTransform.volume = $volume;
		}
		//------ Stop ------------------------------------
		public function stop():void {
			_isPlaying = false;
			_position = _soundChannel.position;
			_soundChannel.stop();
		}
		//------ Is Playing ------------------------------------
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}