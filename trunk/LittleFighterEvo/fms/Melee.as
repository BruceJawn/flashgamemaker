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
	
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;
	import utils.space.Space;
	import utils.time.Time;

	public class Melee extends LFE_AiState{
		
		//Melee State
		public function Melee($fms:FiniteStateMachine=null,$lfe_objectComponent:LFE_ObjectComponent=null){
			super($fms,$lfe_objectComponent);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Melee";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Melee");
			
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Melee");
			var dir:int = Space.GetDirection(_object.getBounds(null), _object.target.getBounds(null),true,true);
			var target:LFE_ObjectComponent = _object.target;
			if(dir==Space.CENTER){
				var keyPad:KeyPad = _object.keyPad;
				keyPad.releaseFire1Key();
				var rand:Number = SimpleMath.RandomBetween(0,5);
				if(rand<5){
					keyPad.pressFire1Key();
					keyPad.fire1.isDownTime=Time.GetTime();
				}else{
					_finiteStateMachine.changeStateByName("Seek");
				}
			}else{
				_finiteStateMachine.changeStateByName("Seek");
			}
			
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Melee");
			_object.keyPad.releaseFire1Key();
		}
	}
}