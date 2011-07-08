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

package framework.core.architecture.component{
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.*;
	
	import utils.keyboard.KeyCode;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class KeyboardInputComponent extends Component{

		private var _gamePad:Object = null;
		private var _isListening:Boolean = false;
		private var _shift:Boolean;
		private var _ctrl:Boolean;
		
		// INPUTS
		private var _up:Object;
		private var _down:Object;
		private var _left:Object;
		private var _right:Object;
		private var _fire1:Object;
		private var _fire2:Object;
		private var _fire3:Object;
		private var _fire4:Object;
		private var _inputs:Array;
		
		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		private var _upLeft:Object;
		private var _downLeft:Object;
		private var _upRight:Object;
		private var _downRight:Object;
		private var _anyDirection:Object;
		private var _multiInputs:Array;
		
		// THE "STICK"
		private var _x:Number=0;
		private var _y:Number=0;
		private var _targetX:Number=0;
		private var _targetY:Number=0;
		
		public function KeyboardInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
			//initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			initGamePad()
		}
		
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FlashGameMaker.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardInput") {
				super.actualizePropertyComponent($propertyName,$component, $param);
				if(!_isListening){
					_isListening=true;
					initListener();
				}
			}
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
		private function createGamepadInput():Object {
			var gamePadInput:Object={isDown:false,isPressed:false,isReleased:false,doubleClick:false,shift:false,ctrl:false,downTicks:-1,upTicks:-1,mappedKeys:new Array  };
			gamePadInput.mappedKeys=new Array  ;
			return gamePadInput;
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadMultiInput(inputs:Array, isOr:Boolean):Object {
			var gamePadMultiInput:Object={isDown:false,isPressed:false,isReleased:false,downTicks:-1,upTicks:-1,isOr:isOr,inputs:inputs};
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
		//------ Use OKLM ------------------------------------
		public function useOKLM(replaceExisting:Boolean = false):void {
			mapFireButtons(KeyCode.K, KeyCode.L,KeyCode.O,KeyCode.M, replaceExisting);
		}
		//------ On Key Down ------------------------------------
		private function onKeyDown(evt:KeyboardEvent):void {
			_shift=evt.shiftKey;
			_ctrl=evt.ctrlKey;
			for each (var gamepadInput:Object in _inputs) {
				keyDown(gamepadInput,evt.keyCode);
			}
			updateState();
			step();
			onKeyFire();
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp(evt:KeyboardEvent):void {
			_shift=evt.shiftKey;
			_ctrl=evt.ctrlKey;
			for each (var gamepadInput:Object in _inputs) {
				keyUp(gamepadInput,evt.keyCode);
			}
			updateState();
			step();
			onKeyFire();
		}
		//------ On Key Down ------------------------------------
		private function keyDown(gamepadInput:Object,keyCode:int):void {
			if (gamepadInput.mappedKeys.indexOf(keyCode)>-1) {
				if (gamepadInput==_right&&_left.isDown||gamepadInput==_left&&_right.isDown||gamepadInput==_up&&_down.isDown||gamepadInput==_down&&_up.isDown) {
					return;
				}
				gamepadInput.isDown=true;
			}
		}
		//------ On Key Up ------------------------------------
		private function keyUp(gamepadInput:Object,keyCode:int):void {
			if (gamepadInput.mappedKeys.indexOf(keyCode)>-1) {
				gamepadInput.isDown=false;
			}
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire():void {
			_gamePad = getGamePad();
			dispatch("onKeyFire");
		}
		//------ On Dispatch ------------------------------------
		private function dispatch(callback:String):void {
			var components:Vector.<Object> = _properties["keyboardInput"];
			for each (var object:Object in components){
				if(object.param.hasOwnProperty(callback)){
					object.param[callback](_gamePad);
				}
			}
		}
		//------ Update State ------------------------------------
		private function updateState():void {
			for each (var gamepadMultiInput:Object in _multiInputs) {
				updateGamepadMultiInput(gamepadMultiInput);
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
		public function updateGamePadInput(gamepadInput:Object):void {
			if (gamepadInput.isDown) {
				gamepadInput.isPressed=gamepadInput.downTicks==-1;
				gamepadInput.isReleased=false;
				gamepadInput.downTicks++;
				gamepadInput.upTicks=-1;
			} else {
				gamepadInput.isReleased=gamepadInput.upTicks==-1;
				gamepadInput.isPressed=false;
				gamepadInput.upTicks++;
				gamepadInput.downTicks=-1;
			}
		}
		//------ Update Gamepad Multi Input ------------------------------------
		public function updateGamepadMultiInput(gamepadMultiInput:Object):void {
			if (gamepadMultiInput.isOr) {
				gamepadMultiInput.isDown=false;
				for each (var gamepadInput:Object in _inputs) {
					if (gamepadInput.isDown) {
						gamepadMultiInput.isDown=true;
						break;
					}
				}
			} else {
				gamepadMultiInput.isDown=true;
				for each (gamepadInput in gamepadMultiInput.inputs) {
					if (! gamepadInput.isDown) {
						gamepadMultiInput.isDown=false;
						break;
					}
				}
			}
			if (gamepadMultiInput.isDown) {
				gamepadMultiInput.isPressed=gamepadMultiInput.downTicks==-1;
				gamepadMultiInput.isReleased=false;
				gamepadMultiInput.downTicks++;
				gamepadMultiInput.upTicks=-1;
			} else {
				gamepadMultiInput.isReleased=gamepadMultiInput.upTicks==-1;
				gamepadMultiInput.isPressed=false;
				gamepadMultiInput.upTicks++;
				gamepadMultiInput.downTicks=-1;
			}
		}
		//------ Step ------------------------------------
		public function step():void {
			_x += (_targetX - _x);
			_y += (_targetY - _y);
		}
		//------ Get GamePad ------------------------------------
		private function getGamePad():Object {
			var gamePad:Object=new Object  ;
			// INPUTS
			gamePad.shift=_shift;
			gamePad.ctrl=_ctrl;
			gamePad.up=_up;
			gamePad.down=_down;
			gamePad.left=_left;
			gamePad.right=_right;
			gamePad.fire1=_fire1;
			gamePad.fire2=_fire2;
			gamePad.fire3=_fire3;
			gamePad.fire4=_fire4;
			gamePad.inputs=_inputs;
			// MULTI-INPUTS
			gamePad.upLeft=_upLeft;
			gamePad.downLeft=_downLeft;
			gamePad.upRight=_upRight;
			gamePad.downRight=_downRight;
			gamePad.anyDirection=_anyDirection;
			gamePad.multiInputs_multiInputs;
			// THE "STICK"
			gamePad.x=_x;
			gamePad.y=_y;
			gamePad.targetX=_targetX;
			gamePad.targetY=_targetY;
			return gamePad;
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}