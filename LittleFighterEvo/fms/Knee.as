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
	
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Knee extends LFE_State{
		
		//Stand State
		public function Knee($fms:FiniteStateMachine=null){
			super($fms);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Knee";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Knee");
			if (!_object.bitmapSet)	return;
			stopMoving();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Knee");
			var frame:Object = _object.getCurrentFrame();
			if((_object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition|| _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed) && _object.bitmapSet.readyToAnim){
				updateAnim(frame.next);
				updateState();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Knee");
		}
	}
}