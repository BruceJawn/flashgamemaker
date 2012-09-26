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

	public class ShortRange extends LFE_AiState{
		
		private var _frameName:String = null;
		private var _step:int=0;
		//ShortRange State
		public function ShortRange(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "ShortRange";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter ShortRange");
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
			//trace("Update ShortRange");
			releaseDirectionKeys();
			shortRangeAttack();
		}
		//------ Short Range Attack ------------------------------------
		private function shortRangeAttack():void {
			var lfeFrame:Object = _object.lfe_Frame;
			var frame:Object = _object.getCurrentFrame();
			var currentState:* = _object.getCurrentState();
			if(_step==1 && frame.name==_frameName)	_step++;
			else if(_step==1 && frame.name=="Stand" && _object.bitmapSet.readyToAnim)	_step++;
			else if(_step==2 && frame.name!=_frameName)_step++;
			if(_step==0 && lfeFrame.hasOwnProperty("shortRangeAttack")){
				if(lfeFrame.shortRangeAttack is Array){
					var frameId:int=lfeFrame.shortRangeAttack[SimpleMath.RandomBetween(0,lfeFrame.shortRangeAttack.length-1)];
					_frameName = lfeFrame.frames[frameId].name;
					updateAnim(frameId);
				}else{
					updateAnim(lfeFrame.shortRangeAttack);
				}
				_object.updateState();
				_step = 1;
			}else if(_step==3){
				_finiteStateMachine.changeStateByName("Seek");
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit ShortRange");
			_step=0;
		}
	}
}