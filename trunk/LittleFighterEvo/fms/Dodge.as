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
	
	import flash.geom.Rectangle;
	
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;
	import utils.space.Space;

	public class Dodge extends LFE_AiState{
		
		private var _frameName:String = null;
		private var _step:int=0;
		private var _isDefending:Boolean = false;
		//Dodge State
		public function Dodge($fms:FiniteStateMachine=null,$lfe_objectComponent:LFE_ObjectComponent=null){
			super($fms,$lfe_objectComponent);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Dodge";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Dodge");
			releaseDirectionKeys();
			_object.keyPad.pressFire3Key();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Dodge");
			var currentState:Object = _object.getCurrentState();
			var ennemyFrame:Object = _object.target.getCurrentFrame();
			if(currentState.name=="Defense"){
				_isDefending = true;
				if(ennemyFrame.hasOwnProperty("itr"))
					_dodgeAttack();
			}else if(currentState.name=="Hurt"){
				_finiteStateMachine.changeStateByName("Flee");
			}else{
				_finiteStateMachine.changeStateByName("Flee");
			}
		}
		//------ Dodge Attack ------------------------------------
		private function _dodgeAttack():void {
			var rand:int = Math.random();
			if(rand==0)_object.keyPad.pressRightKey(true);
			else _object.keyPad.pressLeftKey(true);
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Dodge");
			_isDefending=false;
			releaseDirectionKeys();
			releaseFireKeys();
		}
	}
}