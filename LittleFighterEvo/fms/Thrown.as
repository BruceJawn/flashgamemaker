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
	import flash.net.sendToURL;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import customClasses.*;
	
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Thrown extends LFE_State{
		
		//Thrown State
		public function Thrown(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Thrown";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Thrown");
			if (!_object.bitmapSet || !_object.source)	return;//TODO verify why _object.source is null
			var frame:Object = _object.source.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(frame.hasOwnProperty("wpoint")){
				spatialMove.speed.z = frame.wpoint.dvz;
				spatialMove.speed.x = frame.wpoint.dvx;
			}
			if(frame.wpoint.dvz>0)
				spatialMove.movingDir.z=1;
			else{
				spatialMove.speed.z =0;
				spatialMove.movingDir.z=-1;
			}
			checkMovingDirX(spatialMove.speed.x);
			_object.source.weapon = null;
		}
		//------ Update ------------------------------------
		public override function update():void {
			//trace("Update Fall);
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(frame.hasOwnProperty("dvx")){
				spatialMove.speed.x = frame.dvx;
			}
			if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z+= spatialMove.gravity;
				if(_object.z>=0){
					spatialMove.speed.z =0;
					spatialMove.movingDir.z=0;
					_object.z=0;
				}
			}else if(spatialMove.movingDir.z==1){
				//trace("Jump",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z-= spatialMove.gravity;
				if(spatialMove.speed.z<0){
					spatialMove.speed.z =0;
					spatialMove.movingDir.z=-1;
				}
			}else if(spatialMove.movingDir.z==0){
				updateAnim(frame.next);
				updateState();
			}
			object.hurtEnemy();
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Thrown");
			_object.source = null;
			_object.z=0;
		}
	}
}