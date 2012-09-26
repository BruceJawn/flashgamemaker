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

package script.game.littleFighterEvo.customClasses{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.getClassByAlias;
	
	import script.game.littleFighterEvo.data.Data;
	
	import utils.bitmap.BitmapSet;
	import utils.convert.BoolTo;
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.physic.SpatialMove;
	import utils.richardlord.State;

	/**
	* LFE_AiState
	*/
	public class LFE_AiState extends LFE_State implements LFE_IState{
		
		public function LFE_AiState(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			if(_debugMode){
				_initDebugMode();
			}
		}
		//------ Move Right ------------------------------------
		protected function _moveRight($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressRightKey($doubleClick);
		}
		//------ Move Left ------------------------------------
		protected function _moveLeft($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressLeftKey($doubleClick);
		}
		//------ Move Up ------------------------------------
		protected function _moveUp($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressUpKey($doubleClick);
		}
		//------ Move Down ------------------------------------
		protected function _moveDown($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressDownKey($doubleClick);
		}
		//------ Move Right Down ------------------------------------
		protected function _moveRightDown($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressRightKey($doubleClick);
			_object.keyPad.pressDownKey($doubleClick);
		}
		//------ Move Down Left ------------------------------------
		protected function _moveDownLeft($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressDownKey($doubleClick);
			_object.keyPad.pressLeftKey($doubleClick);
		}
		//------ Move Left Up ------------------------------------
		protected function _moveLeftUp($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressUpKey($doubleClick);
			_object.keyPad.pressLeftKey($doubleClick);
		}
		//------ Move Up Right ------------------------------------
		protected function _moveUpRight($doubleClick:Boolean=false):void {
			releaseDirectionKeys();
			_object.keyPad.pressRightKey($doubleClick);
			_object.keyPad.pressUpKey($doubleClick);
		}
		//------ Release Direction Keys ------------------------------------
		protected function releaseDirectionKeys():void {
			_object.keyPad.releaseRightKey();
			_object.keyPad.releaseUpKey();
			_object.keyPad.releaseLeftKey();
			_object.keyPad.releaseDownKey();
		}
		//------ Release Fire Keys ------------------------------------
		protected function releaseFireKeys():void {
			_object.keyPad.releaseFire1Key();
			_object.keyPad.releaseFire2Key();
			_object.keyPad.releaseFire3Key();
			_object.keyPad.releaseFire4Key();
		}
	}
}