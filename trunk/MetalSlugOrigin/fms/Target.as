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
	import flash.geom.Point;
	
	import customClasses.*;
	import data.Data;
	
	import utils.math.SimpleMath;
	import utils.richardlord.State;

	public class Target extends MS_AiState{
		private var _longRangeDist:Number = 220; 
		//Target State
		public function Target(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Target";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Target");
			if(_object.collision.length==0 && !_object.target){
				_object.collisionParam.anyDirection = {range:-500,components:new Array,dists:new Array};
				//_object.collisionParam.leftSide 	= {range:-500,components:new Array,dists:new Array};
			}else{
				_object.target = _object.collision[0];
			}
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Target");
			var anyDirection:Object = _object.collisionParam.anyDirection;
			if(anyDirection.components.length>0){
				for each(var target:MS_ObjectComponent in  anyDirection.components){
					if (target.kind==Data.OBJECT_KIND_CHARACTER){
						_object.target = target;
						break
					}
				}
				anyDirection = null;
				var dist:Number = _object.getDistance(_object,_object.target);
				var msFrame:Object = _object.ms_Frame;
				if(dist>_longRangeDist && msFrame.hasOwnProperty("longRangeAttack")){
					_finiteStateMachine.changeStateByName("LongRange");
				}else{
					_finiteStateMachine.changeStateByName("Seek");
				}
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Target");
		}
	}
}