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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import script.game.littleFighterEvo.customClasses.*;
	
	import utils.math.SimpleMath;
	import utils.richardlord.State;
	import utils.space.Space;

	public class Flee extends LFE_AiState{
		private var _target:LFE_ObjectComponent = null;
		private var _runningDistance:Number = 200; 
		//Flee State
		public function Flee(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Flee";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Flee");
			releaseDirectionKeys();
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Flee");
			var bounds1:Rectangle = _object.getBounds(null);
			var bounds2:Rectangle  = _object.target.getBounds(null);
			var dir:int = Space.GetDirection(bounds1,bounds2 ,true,true);
			var dist:Number = 0;
			var rand:Number = SimpleMath.RandomBetween(0,20);
			dist = _object.getDistance(_object,_object.target);
			if(dir==Space.CENTER && rand<12){
				var depthAlignement:Number =  Math.abs(object.y+object.height-object.z-object.target.y-object.target.height+object.target.z);
				if(depthAlignement<5){
					releaseDirectionKeys();
					if(rand<5){
						_finiteStateMachine.changeStateByName("ShortRange");
					}else if(rand<8){
						_finiteStateMachine.changeStateByName("Dodge");
					}else if(rand<12){
						_finiteStateMachine.changeStateByName("Melee");
					}
					return;
				}
			}
			var doubleClick:Boolean = dist>_runningDistance;
			if(doubleClick){
				if(rand<2){
					releaseDirectionKeys();
					_finiteStateMachine.changeStateByName("LongRange");
					return;
				}
			}
			doubleClick=!doubleClick; //Run if target is close
			switch(dir){
				case Space.LEFT: 		_moveRight(doubleClick); 		break;
				case Space.RIGHT: 		_moveLeft(doubleClick);			break;
				case Space.DOWN: 		_moveUp();						break;
				case Space.UP: 			_moveDown();					break;
				case Space.UP_RIGHT: 	_moveRightDown(doubleClick);	break;
				case Space.LEFT_UP: 	_moveDownLeft(doubleClick);		break;
				case Space.DOWN_LEFT: 	_moveLeftUp(doubleClick);		break;
				case Space.RIGHT_DOWN: 	_moveUpRight(doubleClick);		break;
			}
			
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Flee");
		}
	}
}