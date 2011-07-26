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
package utils.bitmap{
	import flash.display.Bitmap;
	
	import utils.time.Time;

	public class BitmapAnim{
		
		public var name:String;
		private var _list:Vector.<BitmapCell>;
		private var _position:int=0;
		private var _fps:int = 0;
		private var _lastAnim:Number=0;			//Time of the last animation
		private var _endAnim:Boolean = false; 	//If true finish the animation (jump, slide, attack...)
		private var _nextPose:String;
		
		public function BitmapAnim($name:String, $list:Vector.<BitmapCell> , $position:int=0, $fps:int=0, $nextPose:String =null){
			_initVar($name,$list,$position, $fps, $nextPose);
		}
		//------ Init Var ------------------------------------
		private function _initVar($name:String, $list:Vector.<BitmapCell>,  $position:int, $fps:int, $nextPose:String):void {
			name 		= $name
			_list 		= $list;
			_position 	= $position;
			_fps 		= $fps
			_nextPose	= $nextPose;
		}
		//------ Get Cell ------------------------------------
		public function getCell():BitmapCell {
			return _list[_position];
		}
		//------ Next ------------------------------------
		public function next():BitmapCell {
			if(readyToAnim()){
				if(_position<_list.length-1){
					_position++;
				}else{
					_position=0;	
				}
			}
			return getCell();
		}
		//------ Prev ------------------------------------
		public function prev():BitmapCell {
			if(readyToAnim()){
				if(_position==0){
					_position = _list.length-1;
				}else{
					_position--;	
				}
			}
			return getCell();
		}
		//------ Next ------------------------------------
		public function readyToAnim():Boolean {
			if(_fps==0){
				return true;
			}
			var delay:Number = Math.round(1000 / _fps);
			if(Time.GetTime()-_lastAnim< delay)
				return false
			_lastAnim = Time.GetTime();
			return true;
		}
		//------ GETTER ------------------------------------
		public function get position():int {
			return _position;	
		}
		public function get nextPose():String {
			return _nextPose;	
		}
		public function get lastPosition():int {
			return _list.length-1;	
		}
		//------ Setter ------------------------------------
		public function set position($position:int):void {
			_position=$position;	
		}
		public function set nextPose($nextPose:String):void {
			_nextPose=$nextPose;	
		}
	}
}