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
package fms{
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import customClasses.*;
	import data.Data;
	
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;

	public class Walk extends MS_State{
		
		//Walk State
		public function Walk(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Walk";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Walk");
			if (!_object.bitmapSet)	return;
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Walk");
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(keyPad.upRight.isDown){
				updateAnim(frame.walk_up);
				updateState();
			}else if(keyPad.upLeft.isDown){
				updateAnim(frame.walk_up);
				updateState();
			}else if(keyPad.downRight.isDown){
				updateAnim(frame.walk_down);
				updateState();
			}else if(keyPad.downLeft.isDown){
				updateAnim(frame.walk_down);
				updateState();
			}else if(keyPad.down.isDown){
				updateAnim(frame.down);
				updateState();
			}else if(keyPad.right.isDown){
				anim(1,0,0);
				move(1,0);
			}else if(keyPad.left.isDown){
				anim(-1,0,0);
				move(-1,0);
			}else if(keyPad.up.isDown){
				move(0,0);
				updateAnim(frame.next);
				updateState();
			}else{
				updateAnim(frame.next);
				updateState();
				return;
			}
			super.update();
			if(_finiteStateMachine.currentState.name!=_name)	return;
		}
		//------ Anim ------------------------------------
		private function anim($x:Number, $y:Number, $z:Number):void {
			if(!_object.bitmapSet.flip && $x==-1 || _object.bitmapSet.flip && $x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
			if($x==1 && _object.spatialMove.facingDir.x==-1){
				_object.spatialMove.facingDir.x =1;
			}else if($x==-1 && _object.spatialMove.facingDir.x==1){
				_object.spatialMove.facingDir.x =-1;
			} 
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Walk");
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
			}
		}
	}
}