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
	import flash.geom.Rectangle;
	
	import script.game.littleFighterEvo.customClasses.*;
	
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.richardlord.State;
	import utils.space.Space;

	public class LongRange extends LFE_AiState{
		
		private var _distMax:Number =5;
		private var _isAttacking:Boolean = false;
		//LongRange State
		public function LongRange(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "LongRange";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter LongRange");
			var bounds1:Rectangle = _object.getBounds(null);
			var bounds2:Rectangle  = _object.target.getBounds(null);
			releaseDirectionKeys();
			if(Space.IsOnLeftSide(bounds1,bounds2)){
				_object.keyPad.pressLeftKey();
			}else{
				_object.keyPad.pressRightKey();
			}
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update LongRange");
			var verticalDist:Number = 	_object.getVerticalDistance(_object,_object.target);
			if(verticalDist<=_distMax){
				longRangeAttack();		
			}else if(!_isAttacking){
				var bounds1:Rectangle = _object.getBounds(null);
				var bounds2:Rectangle  = _object.target.getBounds(null);
				releaseDirectionKeys();
				if(Space.IsOnUpSide(bounds1,bounds2)){
					_moveUp();
				}else{
					_moveDown();
				}
			}else{
				_finiteStateMachine.changeStateByName("Seek");
			}
		}
		//------ Long Range Attack ------------------------------------
		private function longRangeAttack():void {
			var lfeFrame:Object = _object.lfe_Frame;
			var frame:Object = _object.getCurrentFrame();
			var currentState:* = _object.getCurrentState();
			if(lfeFrame.hasOwnProperty("longRangeAttack")){
				if(_isAttacking && currentState.hasOwnProperty("hit_a")){
					var rand:Number = SimpleMath.RandomBetween(0,5);
					if(rand<3)currentState.hit_a=true;
					else _finiteStateMachine.changeStateByName("Seek");
				}else{
					releaseDirectionKeys();
					if(lfeFrame.longRangeAttack is Array){
						var frameId:int=lfeFrame.longRangeAttack[SimpleMath.RandomBetween(0,lfeFrame.longRangeAttack.length-1)];
						updateAnim(frameId);
					}else{
						updateAnim(lfeFrame.longRangeAttack);
					}
					_isAttacking=true;
					_object.updateState();
				}
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit LongRange");
			_isAttacking =false;
			releaseDirectionKeys();
		}
	}
}