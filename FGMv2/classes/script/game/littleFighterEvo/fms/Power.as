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
package script.game.littleFighterEvo.fms{
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import script.game.littleFighterEvo.customClasses.*;
	import script.game.littleFighterEvo.data.Data;
	
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;

	public class Power extends LFE_State{
		private var _hit_a:Boolean = false;
		private var _hit_j:Boolean = false;
		private var _hit_d:Boolean = false;
		private var _dvz:Number=0;
		private var _bool:Boolean = true;
		
		//Power State
		public function Power(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Power";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Power");
			if (!_object.bitmapSet)	return;
			//_debugMode=true;
			if(_debugMode){
				_initDebugMode();
			}
			var spatialMove:SpatialMove = _object.spatialMove;
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			_dvz = frame.dvz;
			update();
			updateWeapon();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Power");
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER)	_updateDebugMode();
			var keyPad:KeyPad = _object.keyPad;
			var spatialMove:SpatialMove = _object.spatialMove;
			var frame:Object = _object.getCurrentFrame();
			updateSpeed();
			checkObject();
			if(spatialMove.speed.y<0){
				spatialMove.facingDir.y=1;
			}else if(spatialMove.speed.y>0){
				spatialMove.facingDir.y=1;
			}
			//Jump
			if(frame.hasOwnProperty("dvz") && spatialMove.movingDir.z==0 && _bool){
				spatialMove.movingDir.z=1;
				spatialMove.speed.z = _dvz;
			}else if(spatialMove.movingDir.z==1){
				//trace("Jump",spatialMove.speed.z,spatialMove.gravity );
				spatialMove.speed.z-= spatialMove.gravity;
				if(spatialMove.speed.z<=0){
					spatialMove.movingDir.z=-1;
				}
			}else if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity,_dvz);
				spatialMove.speed.z+= spatialMove.gravity;
				if(_object.z>=0){
					spatialMove.movingDir.z=0;
					_bool = false;
					_object.z=0;
				}
			}
			//Fire button hit
			if(spatialMove.movingDir.z!=0 && frame.hasOwnProperty("hit_a")){
				if(keyPad.fire1.isDown && !keyPad.fire1.getLongClick()){
					updateAnim(frame.hit_a);
				}
			}else if(_object.bitmapSet.currentAnim.position >0){
				if(keyPad.fire1.isDown && !keyPad.fire1.getLongClick(65)){
					//trace("_hit_a");
					_hit_a = true;
				}else if(keyPad.fire2.isDown && !keyPad.fire2.getLongClick(65)){
					//trace("_hit_j");
					_hit_j = true;
				}else if(keyPad.fire3.isDown && !keyPad.fire3.getLongClick(65)){
					//trace("_hit_d");
					_hit_d = true;
				}
			}
			//Update Anim
			if(spatialMove.movingDir.z==0){
				if(!_bool || (_object.bitmapSet.currentAnim.position == _object.bitmapSet.currentAnim.lastPosition && _object.bitmapSet.currentAnim.reverse==0 || _object.bitmapSet.currentAnim.position ==0 && _object.bitmapSet.currentAnim.reverse==-1)){
					if(_hit_a && frame.hasOwnProperty("hit_a")){
						updateAnim(frame.hit_a);
					}else if(_hit_j && frame.hasOwnProperty("hit_j")){
						updateAnim(frame.hit_j);
					}else if(_hit_d && frame.hasOwnProperty("hit_d")){
						updateAnim(frame.hit_d);
					}else{
						updateAnim(frame.next);
					}
					_bool = true;
					_hit_a = false;
					_hit_j = false;
					_hit_d = false;
					updateState();
				}
			}
			object.hurtEnemy();
		}
		//------ UpdateDebugMode ------------------------------------
		protected override function  _updateDebugMode():void {
			var frame:Object = _object.getCurrentFrame();
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
				if(frame.itr is Array){
					for each(var itr:Object in frame.itr)
						_drawArea(_object,itr,0x5FFF0000);
				}else{
					_drawArea(_object,frame.itr,0x5FFF0000);
				}
			}
		}
		//------ Remove MP ------------------------------------
		public function removeMp():void {
		}
		//------ Set Hit_a ------------------------------------
		public function set hit_a($hit_a:Boolean):void {
			_hit_a=$hit_a
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Power");
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