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
package utils.keyboard{
	import flash.ui.Keyboard;
	
	public class KeyPad{
		// INPUTS
		private var _up:KeyPadInput;
		private var _down:KeyPadInput;
		private var _left:KeyPadInput;
		private var _right:KeyPadInput;
		private var _fire1:KeyPadInput;
		private var _fire2:KeyPadInput;
		private var _fire3:KeyPadInput;
		private var _fire4:KeyPadInput;
		private var _inputs:Array;
		
		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		private var _upLeft:KeyPadMultiInput;
		private var _downLeft:KeyPadMultiInput;
		private var _upRight:KeyPadMultiInput;
		private var _downRight:KeyPadMultiInput;
		private var _anyDirection:KeyPadMultiInput;
		private var _multiInputs:Array;
		
		// THE "STICK"
		private var _x:Number=0;
		private var _y:Number=0;
		private var _targetX:Number=0;
		private var _targetY:Number=0;
		
		public function KeyPad(){
			initGamePad();
		}
		//------ Init Game Pad ------------------------------------
		private function initGamePad():void {
			_up=createGamepadInput();
			_down=createGamepadInput();
			_left=createGamepadInput();
			_right=createGamepadInput();
			_fire1=createGamepadInput();
			_fire2=createGamepadInput();
			_fire3=createGamepadInput();
			_fire4=createGamepadInput();
			_inputs=[_up,_down,_left,_right,_fire1,_fire2,_fire3,_fire4];
			_upLeft=createGamepadMultiInput([_up,_left],false);
			_upRight=createGamepadMultiInput([_up,_right],false);
			_downLeft=createGamepadMultiInput([_down,_left],false);
			_downRight=createGamepadMultiInput([_down,_right],false);
			_anyDirection=createGamepadMultiInput([_up,_down,_left,_right],true);
			_multiInputs=[_upLeft,_upRight,_downLeft,_downRight,_anyDirection];
			useArrows();
			useJKLM();
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadInput():KeyPadInput {
			var gamePadInput:KeyPadInput= new KeyPadInput;
			return gamePadInput;
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadMultiInput(inputs:Array, isOr:Boolean):KeyPadMultiInput {
			var gamePadMultiInput:KeyPadMultiInput=new KeyPadMultiInput(inputs, isOr);
			return gamePadMultiInput;
		}
		//------ Map Direction ------------------------------------
		public function mapDirection(up:int, down:int, left:int, right:int, replaceExisting:Boolean = false):void {
			mapKey(_up,up, replaceExisting);
			mapKey(_down,down, replaceExisting);
			mapKey(_left,left, replaceExisting);
			mapKey(_right,right, replaceExisting);
		}
		//------ Map Fire Buttons ------------------------------------
		public function mapFireButtons(fire1:int, fire2:int,fire3:int, fire4:int,replaceExisting:Boolean = false):void{
			mapKey(_fire1,fire1, replaceExisting);
			mapKey(_fire2,fire2, replaceExisting);
			mapKey(_fire3,fire3, replaceExisting);
			mapKey(_fire4,fire4, replaceExisting);
		}
		//------ Use Arrows ------------------------------------
		public function useArrows(replaceExisting:Boolean = false):void {
			mapDirection(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, replaceExisting);
		}
		//------ Use WASD ------------------------------------
		public function useWASD(replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.W, KeyCode.S, KeyCode.A, KeyCode.D, replaceExisting);
		}
		//------ Use IJKL ------------------------------------
		public function useIJKL(replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.I, KeyCode.K, KeyCode.J, KeyCode.L, replaceExisting);
		}
		//------ Use ZQSD ------------------------------------
		public function useZQSD(replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.Z, KeyCode.S, KeyCode.Q, KeyCode.D, replaceExisting);
		}
		//------ Use JKLM ------------------------------------
		public function useJKLM(replaceExisting:Boolean = false):void {
			mapFireButtons(KeyCode.J, KeyCode.K,KeyCode.L,KeyCode.M, replaceExisting);
		}
		//------ Map Key ------------------------------------
		public function mapKey(key:Object,keyCode:int, replaceExisting:Boolean = false):void {
			if (replaceExisting) {
				key.mappedKeys=[keyCode];
			} else if (key.mappedKeys.indexOf(keyCode) == -1) {
				key.mappedKeys.push(keyCode);
			}
		}
		//------ Unmap Key ------------------------------------
		public function unmapKey(key:Object,keyCode:int):void {
			key.mappedKeys.splice(key.mappedKeys.indexOf(keyCode), 1);
		}
		//------ Update Gamepad Input ------------------------------------
		public function updateKeyPadInput(keyPadInput:Object):void {
			if (keyPadInput.isDown) {
				keyPadInput.isPressed=keyPadInput.downTicks==-1;
				keyPadInput.isReleased=false;
				keyPadInput.downTicks++;
				keyPadInput.upTicks=-1;
			} else {
				keyPadInput.isReleased=keyPadInput.upTicks==-1;
				keyPadInput.isPressed=false;
				keyPadInput.upTicks++;
				keyPadInput.downTicks=-1;
			}
		}
		//------ Update Gamepad Multi Input ------------------------------------
		public function updateKeyPadMultiInput(keyPadMultiInput:KeyPadMultiInput):void {
			if (keyPadMultiInput.isOr) {
				keyPadMultiInput.isDown=false;
				for each (var keyPadInput:Object in _inputs) {
					if (keyPadInput.isDown) {
						keyPadMultiInput.isDown=true;
						break;
					}
				}
			} else {
				keyPadMultiInput.isDown=true;
				for each (keyPadInput in keyPadMultiInput.inputs) {
					if (! keyPadInput.isDown) {
						keyPadMultiInput.isDown=false;
						break;
					}
				}
			}
			if (keyPadMultiInput.isDown) {
				keyPadMultiInput.isPressed=keyPadMultiInput.downTicks==-1;
				keyPadMultiInput.isReleased=false;
				keyPadMultiInput.downTicks++;
				keyPadMultiInput.upTicks=-1;
			} else {
				keyPadMultiInput.isReleased=keyPadMultiInput.upTicks==-1;
				keyPadMultiInput.isPressed=false;
				keyPadMultiInput.upTicks++;
				keyPadMultiInput.downTicks=-1;
			}
		}
		//------ On Key Down ------------------------------------
		public function keyDown(keyCode:int):void {
			for each (var keyPadInput:KeyPadInput in _inputs) {
				if (keyPadInput.mappedKeys.indexOf(keyCode)>-1) {
					if (keyPadInput==_right&&_left.isDown||keyPadInput==_left&&_right.isDown||keyPadInput==_up&&_down.isDown||keyPadInput==_down&&_up.isDown) {
						return;
					}
					keyPadInput.isDown=true;
				}
			}
			updateState();
			step();
		}
		//------ On Key Up ------------------------------------
		public function keyUp(keyCode:int):void {
			for each (var keyPadInput:KeyPadInput in _inputs) {
				if (keyPadInput.mappedKeys.indexOf(keyCode)>-1) {
					keyPadInput.isDown=false;
				}
			}
			updateState();
			step();
		}
		//------ Step ------------------------------------
		public function step():void {
			_x += (_targetX - _x);
			_y += (_targetY - _y);
		}
		//------ Update State ------------------------------------
		private function updateState():void {
			for each (var keyPadMultiInput:KeyPadMultiInput in _multiInputs) {
				updateKeyPadMultiInput(keyPadMultiInput);
			}
			if (_up.isDown) {
				_targetY=-1;
			} else if (_down.isDown) {
				_targetY=1;
			} else {
				_targetY=0;
			}
			if (_left.isDown) {
				_targetX=-1;
			} else if (_right.isDown) {
				_targetX=1;
			} else {
				_targetX=0;
			}
		}
		//------ Getter ------------------------------------
		public function get up():KeyPadInput {
			return _up;
		}
		public function get down():KeyPadInput {
			return _down;
		}
		public function get left():KeyPadInput {
			return _left;
		}
		public function get right():KeyPadInput {
			return _right;
		}
		public function get fire1():KeyPadInput {
			return _fire1;
		}
		public function get fire2():KeyPadInput {
			return _fire2;
		}
		public function get fire3():KeyPadInput {
			return _fire3;
		}
		public function get fire4():KeyPadInput {
			return _fire4;
		}
		public function get upLeft():KeyPadMultiInput {
			return _upLeft;
		}
		public function get downLeft():KeyPadMultiInput {
			return _downLeft;
		}
		public function get upRight():KeyPadMultiInput {
			return _upRight;
		}
		public function get downRight():KeyPadMultiInput {
			return _downRight;
		}
		public function get anyDirection():KeyPadMultiInput {
			return _anyDirection;
		}
		public function get x():Number {
			return _x;
		}
		public function get y():Number {
			return _y;
		}
		public function get targetX():Number {
			return _targetX;
		}
		public function set targetX($targetX:Number):void {
			_targetX = $targetX;
		}
		public function get targetY():Number {
			return _targetY;
		}
		public function set targetY($targetY:Number):void {
			_targetY = $targetY;
		}
	}
}