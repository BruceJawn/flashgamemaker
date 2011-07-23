/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://flashgamemakeras3.blogspot.com/
*   Gro_up:        http://gro_ups.google.com.au/gro_up/flashgamemaker
*   Google Code:  http://code.google.com/p/flashgamemaker/_downloads/list
*   Source Forge: https://sourceforge.net/projects/flashgamemaker/files/
*/
/*
*    Inspired from GamePad  
*    Ian Lobb 2008
*    http://blog.iainlobb.com/search/label/gamepad
*/
/*
* Copy_right (C) <2010>  <Joachim N'DOYE>
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

package framework.add.architecture.component{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	
	import framework.core.architecture.component.*;
	import framework.core.architecture.entity.*;
	
	import utils.keyboard.KeyPad;

	/**
	* GamePad Class
	*/
	public class GamePadComponent extends SimpleGraphicComponent {

		//KeyboardInput properties
		public var _keyPad:KeyPad=null;
		
		private var _isCircle:Boolean;
		private var _background:Sprite;
		private var _ball:Sprite;
		private var _button1:Sprite;
		private var _button2:Sprite;
		private var _button3:Sprite;
		private var _button4:Sprite;
		private var _up:Sprite;
		private var _down:Sprite;
		private var _left:Sprite;
		private var _right:Sprite;
		private var _colour:uint;
		private var _ballStep:Number=15;


		public function GamePadComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_isCircle=false;
			_colour=0x333333;
			drawBackground();
			createBall();
			createButtons();
			createKeypad();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("keyboardInput", {onKeyFire:onKeyFire});
			registerPropertyReference("mouseInput", {onMouseDown:onMouseDown, onMouseUp:onMouseUp, onMouseOut:onMouseUp});
		}
		//------ On Key Fire ------------------------------------
		public function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
			updateGamePad();
			dispatch("onKeyFire");
		}
		//------ On Dispatch ------------------------------------
		private function dispatch(callback:String):void {
			var components:Vector.<Object> = _properties["gamePadComponent"];
			for each (var object:Object in components){
				if(object.param.hasOwnProperty(callback)){
					object.param[callback](_keyPad);
				}
			}
		}
		//------ Draw Background ------------------------------------
		private function drawBackground():void {
			if (_isCircle) {
				drawCircle();
			} else {
				drawSquare();
			}
			addChild(_background);
		}
		//------ Draw Square ------------------------------------
		private function drawSquare():void {
			_background = new Sprite();
			_background.graphics.beginFill(_colour, 0.5);
			_background.graphics.drawRoundRect(0, -40, 80, 80, 40, 40);
			_background.graphics.endFill();
		}
		//------ Draw Circle ------------------------------------
		private function drawCircle():void {
			_background.graphics.beginFill(_colour, 0.2);
			_background.graphics.drawCircle(0, 0, 40);
			_background.graphics.endFill();
		}
		//------ Create Ball ------------------------------------
		private function createBall():void {
			_ball = new Sprite();
			_ball.graphics.beginFill(_colour, 1);
			_ball.graphics.drawCircle(40, 0, 20);
			_ball.graphics.endFill();
			addChild(_ball);
		}
		//------ Create Keypad ------------------------------------
		private function createKeypad():void {
			_up=createKey();
			_up.x=140;
			_up.y=-25;

			_down=createKey();
			_down.x=140;
			_down.y=10;

			_left=createKey();
			_left.x=105;
			_left.y=10;

			_right=createKey();
			_right.x=175;
			_right.y=10;
		}
		//------ Create Buttons ------------------------------------
		private function createButtons():void {
			_button1=createButton();
			_button1.x=243.50;
			_button1.y=5;
			_button2=createButton();
			_button2.x=265;
			_button2.y=30;
			_button3=createButton();
			_button3.x=272.5;
			_button3.y=-12.5;
			_button4=createButton();
			_button4.x=295;
			_button4.y=12.5;
		}
		//------ Create Button ------------------------------------
		private function createButton():Sprite {
			var button:Sprite = new Sprite();
			button.graphics.beginFill(_colour, 1);
			button.graphics.drawCircle(0, 0, 15);
			button.graphics.endFill();
			button.alpha=0.5;
			button.buttonMode =true;
			button.useHandCursor = true;
			addChild(button);
			return button;
		}
		//------ Create Key ------------------------------------
		protected function createKey():Sprite {
			var key:Sprite = new Sprite();
			key.graphics.beginFill(_colour, 1);
			key.graphics.drawRoundRect(0, 0, 30, 30, 20, 20);
			key.graphics.endFill();
			key.alpha=0.5;
			key.buttonMode =true;
			key.useHandCursor = true;
			addChild(key);
			return key;
		}
		//------ On Mouse Down ------------------------------------
		public function onMouseDown($mouseObject:Object):void {
			if ($mouseObject.target.alpha!=0) {
				$mouseObject.target.alpha=1;
			}
		}
		//------ On Mouse Up ------------------------------------
		public function onMouseUp($mouseObject:Object):void {
			if ($mouseObject.target.alpha!=0) {
				$mouseObject.target.alpha=0.5;
			}
		}
		//------ UpdateGamePad ------------------------------------
		private function updateGamePad():void {
			var targetAngle:Number=Math.atan2(_keyPad.targetX,_keyPad.targetY);
			if (_isCircle&&_keyPad.anyDirection.isDown) {
				_keyPad.targetX=Math.sin(targetAngle);
				_keyPad.targetY=Math.cos(targetAngle);
			}
			_ball.x=_keyPad.x*_ballStep;
			_ball.y=_keyPad.y*_ballStep;
			if (_button1.alpha!=0) {
				_button1.alpha=_keyPad.fire1.isDown?1:0.5;
			}
			if (_button2.alpha!=0) {
				_button2.alpha=_keyPad.fire2.isDown?1:0.5;
			}
			if (_button3.alpha!=0) {
				_button3.alpha=_keyPad.fire3.isDown?1:0.5;
			}
			if (_button4.alpha!=0) {
				_button4.alpha=_keyPad.fire4.isDown?1:0.5;
			}
			if (_up.alpha!=0) {
				_up.alpha=_keyPad.up.isDown?1:0.5;
			}
			if (_down.alpha!=0) {
				_down.alpha=_keyPad.down.isDown?1:0.5;
			}
			if (_left.alpha!=0) {
				_left.alpha=_keyPad.left.isDown?1:0.5;
			}
			if (_right.alpha!=0) {
				_right.alpha=_keyPad.right.isDown?1:0.5;
			}
		}
		//------ DisplayButton ------------------------------------
		public function showButton(buttonName:String):void {
			this[buttonName].alpha=0.5;
		}
		//------ HideButton ------------------------------------
		public function hideButton(buttonName:String):void {
			this[buttonName].alpha=0;
		}
		//------ Show All ------------------------------------
		public function showAll():void {
			for (var i:int=0; i<this.numChildren; i++) {
				this.getChildAt(i).alpha=0.5;
			}
		}
		//------ Hide All ------------------------------------
		public function hideAll():void {
			for (var i:int=0; i<this.numChildren; i++) {
				this.getChildAt(i).alpha=0;
			}
		}
		//------ Move Button ------------------------------------
		public function moveButton(buttonName:String,x:Number,y:Number):void {
			this[buttonName].x=x;
			this[buttonName].y=y;
		}
		//------ Change Color ------------------------------------
		public function changeColor(color:String):void {
			var myColorTransform:ColorTransform = this.transform.colorTransform;
			myColorTransform.color = uint("0x"+color);
			this.transform.colorTransform = myColorTransform; 
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}