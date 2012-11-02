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
	
	import flash.geom.Point;
	
	import framework.component.core.GraphicComponent;
	
	import utils.math.SimpleMath;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;

	public class Target extends LFE_AiState{
		private var _longRangeDist:Number = 220; 
		//Target State
		public function Target($fms:FiniteStateMachine=null,$lfe_objectComponent:LFE_ObjectComponent=null){
			super($fms,$lfe_objectComponent);
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
				for each(var player:GraphicComponent in _object.collision){
					if(player is LFE_ObjectComponent && LFE_ObjectComponent(player).status.life>0){
						_object.target = player as LFE_ObjectComponent;
						return
					}
				}
			}
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Target");
			var anyDirection:Object = _object.collisionParam.anyDirection;
			if(anyDirection.components.length>0){
				for each(var target:LFE_ObjectComponent in  anyDirection.components){
					if (target.kind==Data.OBJECT_KIND_CHARACTER){
						_object.target = target;
						break
					}
				}
				anyDirection = null;
				var dist:Number = _object.getDistance(_object,_object.target);
				var lfeFrame:Object = _object.lfe_Frame;
				if(dist>_longRangeDist && lfeFrame.hasOwnProperty("longRangeAttack")){
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