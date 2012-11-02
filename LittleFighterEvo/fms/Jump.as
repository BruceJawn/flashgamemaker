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
	import customClasses.*;
	
	import data.Data;
	
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Jump extends LFE_State{
		private var _movingDir:IsoPoint = null;
		private var _bool:Boolean = true;
		private var _rowing:Boolean=false;
		private var _dash:Boolean=false;
		private var _throw:Boolean=false;
		
		//Jump State
		public function Jump($fms:FiniteStateMachine=null,$lfe_objectComponent:LFE_ObjectComponent=null){
			super($fms,$lfe_objectComponent);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Jump";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Jump");
			if (!_object.bitmapSet)	return;
			var spatialMove:SpatialMove = _object.spatialMove;
			var frame:Object = _object.getCurrentFrame();
			_movingDir = new IsoPoint(spatialMove.movingDir.x,spatialMove.movingDir.y);
			if(frame.name == "Jump"){
				stopMoving();
			}else if(frame.name == "RunJump"){
				_object.bitmapSet.currentAnim.autoAnim = false;
				updateSpeed();
			}
			checkSound();
			update();
		}
		//------ Update ------------------------------------
		public override function update():void {
			//trace("Update Jump");
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			updateWeapon();
			//trace(frame.name, frame.id, frame.frame, frame.wpoint.x,frame.wpoint.y,frame.wpoint.weaponact);
			if(spatialMove.movingDir.z==0 && _bool && (frame.hasOwnProperty("dvz")|| frame.name=="RunJump" )){
				spatialMove.movingDir.z=1;
				spatialMove.speed.z = frame.dvz;
				spatialMove.movingDir.x=_movingDir.x;
				spatialMove.movingDir.y=_movingDir.y;
			}else if(spatialMove.movingDir.z==1){
				//trace("Jump",spatialMove.speed.z,spatialMove.gravity );
				if((keyPad.fire1.isDown) && (frame.hasOwnProperty("hit_a")|| frame.hasOwnProperty("hit_n_w_a")) && (frame.name == "Jump" || frame.name == "RunJump")){
					_object.bitmapSet.currentAnim.reverse=0;
					if(_object.weapon && (keyPad.right.isDown || keyPad.left.isDown)){
						updateAnim(frame.hit_t_w_a);
						_object.weapon.updateAnim(_object.getCurrentFrame().wpoint.weaponact);
						_throw=true;
					}else if(_object.weapon){
						updateAnim(frame.hit_n_w_a);
					}else{
						updateAnim(frame.hit_a);
					}
				}
				if(keyPad.fire3.isDown && keyPad.fire3.doubleClick){
					_rowing=true;
				}
				spatialMove.speed.z-= spatialMove.gravity;
				if(spatialMove.speed.z<=0){
					spatialMove.movingDir.z=-1;
					spatialMove.speed.z =0;
				}
			}else if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z+= spatialMove.gravity;
				if(keyPad.fire3.isDown && keyPad.fire3.doubleClick && !keyPad.fire3.getLongClick()){
					_rowing=true;
				}else if(keyPad.fire2.isDown && !keyPad.fire2.getLongClick() && frame.name!="RunJump"){
					_dash=true;
				}
				if(_object.z>=0){
					if(frame.name=="Jump"){
						_object.bitmapSet.currentAnim.reverse=-1;
					}else if(frame.name=="RunJump"){
						_object.bitmapSet.currentAnim.reverse=1;
						_object.bitmapSet.currentAnim.autoAnim = true;
					}
					_bool = false;
					_object.z=0;
					stopMoving();
				}
			}else if((frame.name!="Jump" && frame.name!="RunJump") || frame.name=="Jump" && (_rowing||_dash ||_object.bitmapSet.currentAnim.position == 0 && _object.bitmapSet.currentAnim.reverse==-1) || frame.name=="RunJump" && (_rowing||_dash|| _object.bitmapSet.currentAnim.position == _object.bitmapSet.currentAnim.lastPosition)){
				_bool = true;
				_object.bitmapSet.currentAnim.reverse=0;
				if(_rowing && (frame.name=="Jump" || frame.name=="RunJump")&& frame.hasOwnProperty("dbl_hit_d")){
					_rowing = false;
					updateAnim(frame.dbl_hit_d);
				}else if(_dash && frame.name=="Jump" && frame.hasOwnProperty("dbl_hit_j")){
					_dash = false;
					updateAnim(frame.dbl_hit_j);
					enter(this);
					updateSpeed();
				}else{
					updateAnim(frame.next);
				}
				updateState();
			}
			object.hurtEnemy();
			checkFlip();
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Jump");
			checkSound();
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