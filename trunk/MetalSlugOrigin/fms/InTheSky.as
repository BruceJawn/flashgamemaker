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
	
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class InTheSky extends MS_State{
		private var _dvz:Number=0;
		
		//InTheSky State
		public function InTheSky(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "InTheSky";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter InTheSky");
			if (!_object.bitmapSet)	return;
		}
		//------ Update ------------------------------------
		public override function update():void {
			//trace("Update InTheSky);
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(_dvz==0){
				_dvz =spatialMove.speed.z;
				spatialMove.speed.z = 0;
				spatialMove.movingDir.z=-1;
			}
			if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z+= spatialMove.gravity;
				if(spatialMove.speed.z>_dvz){
					spatialMove.speed.z =0;
					spatialMove.movingDir.z=0;
				}
			}else if(spatialMove.movingDir.z==0){
				updateAnim(frame.next);
				updateState();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit InTheSky");
		}
	}
}