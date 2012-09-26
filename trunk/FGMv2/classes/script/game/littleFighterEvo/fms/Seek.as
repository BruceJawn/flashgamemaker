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

	public class Seek extends LFE_AiState{
		private var _target:LFE_ObjectComponent = null;
		private var _runningDistance:Number = 160; 
		//Seek State
		public function Seek(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Seek";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Seek");
			//trace("Target of "+_object+" is "+ _object.target);
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Seek");
			var bounds1:Rectangle = _object.getBounds(null);
			var bounds2:Rectangle  = _object.target.getBounds(null);
			var dir:int = Space.GetDirection(bounds1,bounds2 ,true,true);
			var dist:Number = 0;
			var rand:Number = SimpleMath.RandomBetween(0,20);
			if(dir==Space.CENTER){
				var depthAlignement:Number =  Math.abs(object.y+object.height-object.z-object.target.y-object.target.height+object.target.z);
				if(depthAlignement<5){
					releaseDirectionKeys();
					if(rand<2){
						_finiteStateMachine.changeStateByName("Flee");
					}else if(rand<4){
						_finiteStateMachine.changeStateByName("ShortRange");
					}else if(rand<6){
						_finiteStateMachine.changeStateByName("Dodge");
					}else{
						_finiteStateMachine.changeStateByName("Melee");
					}
					return;
				}else{
					dir = Space.GetDirection(bounds1,bounds2,true,false);
				}
			}else{
				dist = _object.getDistance(_object,_object.target);
			}
			var doubleClick:Boolean = dist>_runningDistance; //Run if target is far
			//trace("Seek Direction: "+dir+", doubleClick: "+doubleClick);
			if(doubleClick){
				if(rand<2){
					releaseDirectionKeys();
					_finiteStateMachine.changeStateByName("LongRange");
					return;
				}
			}
			switch(dir){
				case Space.RIGHT: 		_moveRight(doubleClick); 		break;
				case Space.LEFT: 		_moveLeft(doubleClick);			break;
				case Space.UP: 			_moveUp();						break;
				case Space.DOWN: 		_moveDown();					break;
				case Space.RIGHT_DOWN: 	_moveRightDown(doubleClick);	break;
				case Space.DOWN_LEFT: 	_moveDownLeft(doubleClick);		break;
				case Space.LEFT_UP: 	_moveLeftUp(doubleClick);		break;
				case Space.UP_RIGHT: 	_moveUpRight(doubleClick);		break;
			}
			
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Seek");
		}
	}
}