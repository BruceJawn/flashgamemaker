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
*Under this licence you are free to copy, adapt and distrubute the work. 
*You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import utils.loader.*;
	
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.media.*;

	/**
	* Sound Manager
	* @ purpose: 
	*/
	public class SoundManager extends LoaderDispatcher implements ISoundManager {

		private static var _instance:ISoundManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _isSoundPlaying:Boolean=false;
		private var _mute:Boolean=false;
		private var _sounds:Dictionary=null;
		private var _volume:Number=0.5;//between 0 and 1
		private var _soundToLoad:Array = null;

		public function SoundManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():ISoundManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new SoundManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_sounds = new Dictionary();
			_soundToLoad = new Array();
		}
		//------ Init Var ------------------------------------
		public function play(soundName:String, path:String, volume:Number =0.5):void {
			if (_sounds[soundName]==null) {
				_soundToLoad.push({soundName:soundName, path:path, volume:volume});
				if(_soundToLoad.length==1){
					load(soundName,path);
				}
			} else {
				var sound:Sound=_sounds[soundName].sound;
				_sounds[soundName].soundChannel = sound.play();
			}
		}
		//------ Load ------------------------------------
		private function load(soundName:String, path:String):void {
			var sound:Sound= new Sound();
			sound.addEventListener(Event.OPEN,onSoundOpen);
			sound.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			sound.load(new URLRequest(path));
		}
		//------ Sound Open ------------------------------------
		private function onSoundOpen(evt:Event):void {
			evt.target.removeEventListener(Event.OPEN,onSoundOpen);
			evt.target.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			var soundName:String = _soundToLoad[0].soundName;
			var sound:Sound=evt.target as Sound;
			var soundChannel:SoundChannel = sound.play();
			var volume:Number=_soundToLoad[0].volume;
			_sounds[soundName]={sound:sound,soundChannel:soundChannel,volume:volume};
			changeVolume(soundName, _volume)
			_soundToLoad.shift();
			if(_soundToLoad.length>0){
				load(_soundToLoad[0].soundName, _soundToLoad[0].path);
			}
			_isSoundPlaying=true;
		}
		//------ Io Error  ------------------------------------
		private function onIoError(evt: IOErrorEvent):void {
			trace("Fichier .mp3 introuvable", evt);
		}
		//------ Resume Music ------------------------------------
		public function resume(soundName:String, position:Number):void {
			var sound:Sound=_sounds[soundName].sound;
			var soundChannel:SoundChannel=_sounds[soundName].soundChannel;
			if (sound.bytesTotal>0) {
				soundChannel=sound.play(position);
				_isSoundPlaying=true;
			}
		}
		//------ Stop Music ------------------------------------
		public function stop(soundName:String):Number {
			var sound:Sound=_sounds[soundName].sound;
			var soundChannel:SoundChannel=_sounds[soundName].soundChannel;
			if (sound.bytesTotal>0) {
				var position:Number=soundChannel.position;
				soundChannel.stop();
				return position;
			}
			return 0;
		}
		//------ Change Volume ------------------------------------
		public function changeVolume(soundName:String, volume:Number):void {
			if(_sounds[soundName]==null){
				throw new Error("The sound "+soundName+".mp3  doesn't exsist !!");
			}
			var sound:Sound=_sounds[soundName].sound;
			var soundChannel:SoundChannel=_sounds[soundName].soundChannel;
			var soundTransform:SoundTransform=soundChannel.soundTransform;
			soundTransform.volume=volume;
			soundChannel.soundTransform = soundTransform;
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}