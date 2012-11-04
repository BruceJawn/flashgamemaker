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
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Defense extends LFE_State{
		
		//Defense State
		public function Defense($fms:FiniteStateMachine=null,$lfe_objectComponent:LFE_ObjectComponent=null){
			super($fms,$lfe_objectComponent);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Defense";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Defense");
			if (!_object.bitmapSet)	return;
			stopMoving();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			var keyPad:KeyPad = _object.keyPad
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			var readyToAnim:Boolean = _object.bitmapSet.readyToAnim;
			updateSpeed();
			if ((_object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition || _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed) && readyToAnim){
				if(keyPad.anyDirection.isDown){
					updateAnim(frame.walk);
					updateState();
				}else{
					updateAnim(frame.stand);
					updateState();
				}
			}
			else if(frame.hasOwnProperty("dbl_hit_hold_direction") && (keyPad.fire3.isDown && keyPad.fire3.getLongClick() && (keyPad.right.isDown && keyPad.right.doubleClick && spatialMove.facingDir.x==-1  || keyPad.left.isDown && keyPad.left.doubleClick && spatialMove.facingDir.x==1 )||keyPad.fire3.doubleClick )){
				updateAnim(frame.dbl_hit_hold_direction);
				updateState();
				updateSpeed();
			}else if(keyPad.fire1.isDown && !keyPad.fire1.getLongClick()){
				if(frame.hasOwnProperty("hit_Da") && (keyPad.down.isDown || keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.down))){
					var powerFrame:Object = _object.lfe_Frame.frames[frame.hit_Da];
					if(!(powerFrame && powerFrame.hasOwnProperty("mp") && powerFrame.mp>_object.status.mp)){
						updateAnim(frame.hit_Da);
						updateState();
					}
				}else if(frame.hasOwnProperty("hit_Ua") && (keyPad.up.isDown || keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.up))){
					powerFrame = _object.lfe_Frame.frames[frame.hit_Ua];
					if(!(powerFrame && powerFrame.hasOwnProperty("mp") && powerFrame.mp>_object.status.mp)){
						updateAnim(frame.hit_Ua);
						updateState();
					}
				}else if(frame.hasOwnProperty("hit_Fa")){
					powerFrame = _object.lfe_Frame.frames[frame.hit_Fa];
					if(!(powerFrame && powerFrame.hasOwnProperty("mp") && powerFrame.mp>_object.status.mp)){
						updateAnim(frame.hit_Fa);
						updateState();
					}
				} 
			}else if(keyPad.fire2.isDown && !keyPad.fire2.getLongClick()){
				if(frame.hasOwnProperty("hit_Dj") &&(keyPad.down.isDown || keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.down))){
					powerFrame = _object.lfe_Frame.frames[frame.hit_Dj];
					if(!(powerFrame.hasOwnProperty("mp") && powerFrame.mp>_object.status.mp)){
						updateAnim(frame.hit_Dj);
						updateState();
					}
				}else if(frame.hasOwnProperty("hit_Uj") && (keyPad.up.isDown || keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.up))){
					powerFrame = _object.lfe_Frame.frames[frame.hit_Uj];
					if(!(powerFrame.hasOwnProperty("mp") && powerFrame.mp>_object.status.mp)){
						updateAnim(frame.hit_Uj);
						updateState();
					}
				}else if(frame.hasOwnProperty("hit_Fj")){
					powerFrame = _object.lfe_Frame.frames[frame.hit_Fj];
					if(!(powerFrame.hasOwnProperty("mp") && powerFrame.hit_Fj.mp>_object.status.mp)){
						updateAnim(frame.hit_Fj);
						updateState();
					}
				} 
			}else if(frame.hasOwnProperty("dbl_hit_direction") && (keyPad.right.isDown && keyPad.right.doubleClick || keyPad.left.isDown && keyPad.left.doubleClick)){
				updateAnim(frame.dbl_hit_direction);
			}
			if(!(keyPad.fire3.isDown && keyPad.fire3.getLongClick())){
				checkFlip();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Defense");
		}
	}
}