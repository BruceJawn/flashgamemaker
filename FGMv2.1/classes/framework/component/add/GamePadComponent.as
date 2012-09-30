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
*   Permission is granted to copy, distribute and/or modify graphic document
*   under the terms of the GNU Free Documentation License, Version 1.3
*   or any later version published by the Free Software Foundation;
*   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*   Under graphic licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.component.add{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import framework.Framework;
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.ui.LayoutUtil;

	/**
	* GamePad Class
	*/
	public class GamePadComponent extends GraphicComponent {

		//KeyboardInput properties
		private var _keyPad:KeyPad=null;
		
		private var _isCircle:Boolean;
		private var _isAligned:Boolean;
		private var _background:Sprite;
		private var _ball:Sprite;
		private var _ballX:int=0;
		private var _ballY:int=0;
		private var _button1:Sprite;
		private var _button1TF:TextField;
		private var _button2:Sprite;
		private var _button2TF:TextField;
		private var _button3:Sprite;
		private var _button3TF:TextField;
		private var _button4:Sprite;
		private var _button4TF:TextField;
		private var _up:Sprite;
		private var _upTF:TextField;
		private var _down:Sprite;
		private var _downTF:TextField;
		private var _left:Sprite;
		private var _leftTF:TextField;
		private var _right:Sprite;
		private var _rightTF:TextField;
		private var _colour:uint;
		private var _ballStep:Number=15;
		private var _alpha:Number = 0.6;
		private var _textFormat:TextFormat;
		public var update:Boolean=true;
		private var _colorTransform:ColorTransform = null;
		private var _redColorTransform:ColorTransform = null;
		private var _list:Array = null;
		// THE "STICK"
		private var _targetX:Number=0;
		private var _targetY:Number=0;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _mouseActions:Boolean = true;//To use the GamePad with Mouse or Touch Events 
		private var _stickDown:Boolean = false;
		
		public function GamePadComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
			_initListener();
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.hasOwnProperty("keyPad")){
				_keyPad = $prop.keyPad;
			}else{
				throw new Error("A keyPad must be given as parameter to the GamePadComponent !!!");
			}
			if($prop && $prop.hasOwnProperty("mouseActions"))	_mouseActions = $prop.mouseActions;
			graphic = new Sprite;
			_isCircle=false;
			_isAligned = true;
			_colour=0x333333;
			_textFormat = new TextFormat("Arial", 16, 0xFFFFFF, true);
			_ballX=40;
			_ballY=40;
			_colorTransform = new ColorTransform(1,1,1,_alpha);
			_redColorTransform =  new ColorTransform(1,0,0,1);
			drawBackground();
			createBall();
			createButtons();
			createKeypad();
			Framework.AddChild(this);
		}
		//------ Init Listener ------------------------------------
		private function _initListener():void {
			if(_mouseActions){
				_ball.addEventListener(MouseEvent.MOUSE_DOWN,onStickMouseDown,false,0,true);
				Framework.clip.addEventListener(MouseEvent.MOUSE_UP,onStickMouseUp,false,0,true);
				Framework.clip.addEventListener(MouseEvent.MOUSE_MOVE,onStickMouseMove,false,0,true);
			}
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("keyboardInput", {onKeyFire:onKeyFire});
		}
		//------ On Key Fire ------------------------------------
		public function onKeyFire($keyPad:KeyPad):void {
			if(update){
				updateState();
				step();
				updateGamePad();
			}
		}
		//------ Draw Background ------------------------------------
		private function drawBackground():void {
			if (_isCircle) {
				drawCircle();
			} else {
				drawSquare();
			}
			graphic.addChild(_background);
		}
		//------ Draw Square ------------------------------------
		private function drawSquare():void {
			_background = new Sprite();
			_background.graphics.beginFill(_colour, _alpha);
			_background.graphics.drawRoundRect(0, 0, 80, 80, 40, 40);
			_background.graphics.endFill();
		}
		//------ Draw Circle ------------------------------------
		private function drawCircle():void {
			_background.graphics.beginFill(_colour, 0.2);
			_background.graphics.drawCircle(0, 40, 40);
			_background.graphics.endFill();
		}
		//------ Create Ball ------------------------------------
		private function createBall():void {
			_ball = new Sprite();
			_ball.graphics.beginFill(_colour, 1);
			_ball.graphics.drawCircle(_ballX, _ballY, 20);
			_ball.graphics.endFill();
			graphic.addChild(_ball);
		}
		//------ Create Keypad ------------------------------------
		private function createKeypad($keyPad:KeyPad=null):void {
			_up=createKey();
			_up.x=140;
			_up.y=0;
			_upTF = new TextField();
			_upTF.autoSize = TextFieldAutoSize.CENTER;
			_up.addChild(_upTF);

			_down=createKey();
			_down.x=140;
			_down.y=_up.y+35;
			_downTF = new TextField();
			_downTF.autoSize = TextFieldAutoSize.CENTER;
			_down.addChild(_downTF);

			_left=createKey();
			_left.x=105;
			_left.y=_up.y+35;
			_leftTF = new TextField();
			_leftTF.autoSize = TextFieldAutoSize.CENTER;
			_left.addChild(_leftTF);

			_right=createKey();
			_right.x=175;
			_right.y=_up.y+35;
			_rightTF = new TextField();
			_rightTF.autoSize = TextFieldAutoSize.CENTER;
			_right.addChild(_rightTF);
			
			setKeyTouch();
		}
		//------ Create Buttons ------------------------------------
		private function createButtons():void {
			_button1=createButton();
			_button1TF = new TextField();
			_button1TF.autoSize = TextFieldAutoSize.CENTER;
			_button1.addChild(_button1TF);
			_button1.addEventListener(MouseEvent.MOUSE_DOWN,pressButton1,false,0,true);
			_button1.addEventListener(MouseEvent.MOUSE_UP,releaseButton1,false,0,true);
			_button2=createButton();
			_button2TF = new TextField();
			_button2TF.autoSize = TextFieldAutoSize.CENTER;
			_button2.addChild(_button2TF);
			_button2.addEventListener(MouseEvent.MOUSE_DOWN,pressButton2,false,0,true);
			_button2.addEventListener(MouseEvent.MOUSE_UP,releaseButton2,false,0,true);
			_button3=createButton();
			_button3TF = new TextField();
			_button3TF.autoSize = TextFieldAutoSize.CENTER;
			_button3.addChild(_button3TF);
			_button3.addEventListener(MouseEvent.MOUSE_DOWN,pressButton3,false,0,true);
			_button3.addEventListener(MouseEvent.MOUSE_UP,releaseButton3,false,0,true);
			_button4=createButton();
			_button4TF = new TextField();
			_button4TF.autoSize = TextFieldAutoSize.CENTER;
			_button4.addChild(_button4TF);
			_button4.addEventListener(MouseEvent.MOUSE_DOWN,pressButton4,false,0,true);
			_button4.addEventListener(MouseEvent.MOUSE_UP,releaseButton4,false,0,true);
			if(_isAligned){
				_button1.x=245;
				_button1.y=45;
				_button2.x=280;
				_button2.y=45;
				_button3.x=315;
				_button3.y=45;
				_button4.x=350;
				_button4.y=45;
			}else{
				_button1.x=243.50;
				_button1.y=30;
				_button2.x=265;
				_button2.y=60;
				_button3.x=272.5;
				_button3.y=25 -12.5;
				_button4.x=295;
				_button4.y=30 +12.5;
			}
		}
		//------ Create Button ------------------------------------
		private function createButton():Sprite {
			var button:Sprite = new Sprite();
			button.graphics.beginFill(_colour, 1);
			button.graphics.drawCircle(0, 0, 15);
			button.graphics.endFill();
			button.alpha=_alpha;
			button.buttonMode =true;
			button.mouseChildren =false;
			button.useHandCursor = false;
			button.tabEnabled = false;
			button.transform.colorTransform = _colorTransform;
			graphic.addChild(button);
			return button;
		}
		//------ Create Key ------------------------------------
		protected function createKey():Sprite {
			var key:Sprite = new Sprite();
			key.graphics.beginFill(_colour, 1);
			key.graphics.drawRoundRect(0, 0, 30, 30, 20, 20);
			key.graphics.endFill();
			key.alpha=_alpha;
			key.buttonMode =true;
			key.mouseChildren =false;
			key.useHandCursor = false;
			key.tabEnabled = false;
			key.transform.colorTransform = _colorTransform;
			graphic.addChild(key);
			return key;
		}
		//------ On Mouse Down ------------------------------------
		public function onStickMouseDown($mouseEvent:MouseEvent):void {
			//trace("Stick press");
			_stickDown = true;
			_ball.transform.colorTransform = _redColorTransform;
			step();
			updateStick();
		}
		//------ On Mouse Up ------------------------------------
		public function onStickMouseUp($mouseEvent:MouseEvent):void {
			if(_stickDown){
				//trace("Stick release");
				_stickDown = false;
				_ball.transform.colorTransform = _colorTransform;
				_targetX=0;
				_targetY=0;
				updateMouse();
				step();
				updateStick();
			}
		}
		//------ On Mouse Move ------------------------------------
		public function onStickMouseMove($mouseEvent:MouseEvent):void {
			if(_stickDown){
				var dirX:Number = $mouseEvent.stageX-x;
				var dirY:Number = $mouseEvent.stageY-y;
				if(dirX < _ballX/2){
					_targetX = -1;
				}else if(dirX > 3*_ballX/2){
					_targetX = 1;
				}else{
					_targetX = 0;
				}
				if(dirY < _ballY/2){
					_targetY = -1;
				}else if(dirY > 3*_ballY/2){
					_targetY = 1;
				}else{
					_targetY = 0;
				}
				updateMouse();
				step();
				updateStick();
			}
		}
		//------ UpdateGamePad ------------------------------------
		private function updateGamePad():void {
			updateStick();
			updateKeys();
		}
		//------ Update Stick ------------------------------------
		private function updateStick():void {
			var targetAngle:Number=Math.atan2(_targetX,_targetY);
			//trace(_targetX,_targetY,targetAngle);
			if (_isCircle&&_keyPad.anyDirection.isDown) {
				_targetX=Math.sin(targetAngle);
				_targetY=Math.cos(targetAngle);
			}
			_ball.x=_x*_ballStep;
			_ball.y=_y*_ballStep;
		}
		//------ Update Mouse ------------------------------------
		private function updateMouse():void {
			if(_keyPad.anyDirection.isDown && _targetX==0 && _targetY==0){
				_keyPad.releaseLeftKey();
				_keyPad.releaseRightKey();
				_keyPad.releaseUpKey();
				_keyPad.releaseDownKey();
			}else if(_targetX==1 && _targetY==0){
				if(!_keyPad.right.isDown)	_keyPad.pressRightKey();
				if(_keyPad.left.isDown)		_keyPad.releaseLeftKey();
				if(_keyPad.up.isDown)		_keyPad.releaseUpKey();
				if(_keyPad.down.isDown)		_keyPad.releaseDownKey();
			}else if(_targetX==-1 && _targetY==0){
				if(!_keyPad.left.isDown)	_keyPad.pressLeftKey();
				if(_keyPad.right.isDown)	_keyPad.releaseRightKey();
				if(_keyPad.up.isDown)		_keyPad.releaseUpKey();
				if(_keyPad.down.isDown)		_keyPad.releaseDownKey();
			}else if(_targetX==0 && _targetY==1){
				if(!_keyPad.down.isDown)	_keyPad.pressDownKey();
				if(_keyPad.right.isDown)	_keyPad.releaseRightKey();
				if(_keyPad.left.isDown)		_keyPad.releaseLeftKey();
				if(_keyPad.up.isDown)		_keyPad.releaseUpKey();
			}else if(_targetX==0 && _targetY==-1){
				if(!_keyPad.up.isDown)		_keyPad.pressUpKey();
				if(_keyPad.right.isDown)	_keyPad.releaseRightKey();
				if(_keyPad.left.isDown)		_keyPad.releaseLeftKey();
				if(_keyPad.down.isDown)		_keyPad.releaseDownKey();
			}else if(_targetX==1 && _targetY==1){
				if(!_keyPad.right.isDown)	_keyPad.pressRightKey();
				if(!_keyPad.down.isDown)	_keyPad.pressDownKey();
				if(_keyPad.left.isDown)		_keyPad.releaseLeftKey();
				if(_keyPad.up.isDown)		_keyPad.releaseUpKey();
			}else if(_targetX==1 && _targetY==-1){
				if(!_keyPad.right.isDown)	_keyPad.pressRightKey();
				if(!_keyPad.up.isDown)		_keyPad.pressUpKey();
				if(_keyPad.left.isDown)		_keyPad.releaseLeftKey();
				if(_keyPad.down.isDown)		_keyPad.releaseDownKey();
			}else if(_targetX==-1 && _targetY==1){
				if(!_keyPad.left.isDown)	_keyPad.pressLeftKey();
				if(!_keyPad.down.isDown)	_keyPad.pressDownKey();
				if(_keyPad.right.isDown)	_keyPad.releaseRightKey();
				if(_keyPad.up.isDown)		_keyPad.releaseUpKey();
			}else if(_targetX==-1 && _targetY==-1){
				if(!_keyPad.left.isDown)	_keyPad.pressLeftKey();
				if(!_keyPad.up.isDown)		_keyPad.pressUpKey();
				if(_keyPad.right.isDown)	_keyPad.releaseRightKey();
				if(_keyPad.down.isDown)		_keyPad.releaseDownKey();
			}
			
		}
		//------ Update Keys ------------------------------------
		private function updateKeys():void {
			if(_keyPad.fire1.isDown && _button1.transform.colorTransform.alphaMultiplier != 1){
				_button1.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.fire1.isDown && _button1.transform.colorTransform.alphaMultiplier == 1){
				_button1.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.fire2.isDown && _button2.transform.colorTransform.alphaMultiplier != 1){
				_button2.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.fire2.isDown && _button2.transform.colorTransform.alphaMultiplier == 1){
				_button2.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.fire3.isDown && _button3.transform.colorTransform.alphaMultiplier != 1){
				_button3.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.fire3.isDown && _button3.transform.colorTransform.alphaMultiplier == 1){
				_button3.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.fire4.isDown && _button4.transform.colorTransform.alphaMultiplier != 1){
				_button4.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.fire4.isDown && _button4.transform.colorTransform.alphaMultiplier == 1){
				_button4.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.down.isDown && _down.transform.colorTransform.alphaMultiplier != 1){
				_down.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.down.isDown && _down.transform.colorTransform.alphaMultiplier == 1){
				_down.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.up.isDown && _up.transform.colorTransform.alphaMultiplier != 1){
				_up.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.up.isDown && _up.transform.colorTransform.alphaMultiplier == 1){
				_up.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.left.isDown && _left.transform.colorTransform.alphaMultiplier != 1){
				_left.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.left.isDown && _left.transform.colorTransform.alphaMultiplier == 1){
				_left.transform.colorTransform=_colorTransform;
			}
			if(_keyPad.right.isDown && _right.transform.colorTransform.alphaMultiplier != 1){
				_right.transform.colorTransform=_redColorTransform;
			}else if(!_keyPad.right.isDown && _right.transform.colorTransform.alphaMultiplier == 1){
				_right.transform.colorTransform=_colorTransform;
			}
		}
		//------ Press Buttons ------------------------------------
		private function pressButton1($mouseEvent:MouseEvent):void {
			_button1.transform.colorTransform = _redColorTransform;
			_keyPad.pressFire1Key();
		}
		private function pressButton2($mouseEvent:MouseEvent):void {
			_button2.transform.colorTransform = _redColorTransform;
			_keyPad.pressFire2Key();
		}
		private function pressButton3($mouseEvent:MouseEvent):void {
			_button3.transform.colorTransform = _redColorTransform;
			_keyPad.pressFire3Key();
		}
		private function pressButton4($mouseEvent:MouseEvent):void {
			_button4.transform.colorTransform = _redColorTransform;
			_keyPad.pressFire4Key();
		}
		//------ Release Buttons ------------------------------------
		private function releaseButton1($mouseEvent:MouseEvent):void {
			$mouseEvent.stopPropagation();
			_button1.transform.colorTransform = _colorTransform;
			_keyPad.releaseFire1Key();
		}
		private function releaseButton2($mouseEvent:MouseEvent):void {
			$mouseEvent.stopPropagation();
			_button2.transform.colorTransform = _colorTransform;
			_keyPad.releaseFire2Key();
		}
		private function releaseButton3($mouseEvent:MouseEvent):void {
			$mouseEvent.stopPropagation();
			_button3.transform.colorTransform = _colorTransform;
			_keyPad.releaseFire3Key();
		}
		private function releaseButton4($mouseEvent:MouseEvent):void {
			$mouseEvent.stopPropagation();
			_button4.transform.colorTransform = _colorTransform;
			_keyPad.releaseFire4Key();
		}
		//------ DisplayButton ------------------------------------
		public function showButton(buttonName:String):void {
			graphic[buttonName].alpha=_alpha;
		}
		//------ HideButton ------------------------------------
		public function hideButton(buttonName:String):void {
			graphic[buttonName].alpha=0;
		}
		//------ Show All ------------------------------------
		public function showAll():void {
			for (var i:int=0; i<graphic.numChildren; i++) {
				graphic.getChildAt(i).alpha=_alpha;
			}
		}
		//------ Hide All ------------------------------------
		public function hideAll():void {
			for (var i:int=0; i<graphic.numChildren; i++) {
				graphic.getChildAt(i).alpha=0;
			}
		}
		//------ Move Button ------------------------------------
		public function moveButton(buttonName:String,x:Number,y:Number):void {
			graphic[buttonName].x=x;
			graphic[buttonName].y=y;
		}
		//------ SetKeyTouch ------------------------------------
		public function setKeyTouch():void {
			_button1TF.text = KeyCode.GetKey(_keyPad.fire1.mappedKeys[0]);
			_button2TF.text = KeyCode.GetKey(_keyPad.fire2.mappedKeys[0]);
			_button3TF.text = KeyCode.GetKey(_keyPad.fire3.mappedKeys[0]);
			_button4TF.text = KeyCode.GetKey(_keyPad.fire4.mappedKeys[0]);
			_upTF.text = KeyCode.GetKey(_keyPad.up.mappedKeys[0]).charAt(0);
			_downTF.text = KeyCode.GetKey(_keyPad.down.mappedKeys[0]).charAt(0);
			_rightTF.text = KeyCode.GetKey(_keyPad.right.mappedKeys[0]).charAt(0);
			_leftTF.text = KeyCode.GetKey(_keyPad.left.mappedKeys[0]).charAt(0);
			
			_button1TF.setTextFormat(_textFormat);
			_button2TF.setTextFormat(_textFormat);
			_button3TF.setTextFormat(_textFormat);
			_button4TF.setTextFormat(_textFormat);
			_upTF.setTextFormat(_textFormat);
			_downTF.setTextFormat(_textFormat);
			_rightTF.setTextFormat(_textFormat);
			_leftTF.setTextFormat(_textFormat);
			
			_button1TF.x = _button2TF.x = _button3TF.x = _button4TF.x = -7.5;
			_button1TF.y = _button2TF.y = _button3TF.y = _button4TF.y = -10;
			_upTF.x =_downTF.x =_rightTF.x = _leftTF.x = 7;
			_upTF.y =_downTF.y =_rightTF.y = _leftTF.y = 5;
		}
		//------ Update State ------------------------------------
		private function updateState():void {
			if (_keyPad.up.isDown) {
				_targetY=-1;
			} else if (_keyPad.down.isDown) {
				_targetY=1;
			} else {
				_targetY=0;
			}
			if (_keyPad.left.isDown) {
				_targetX=-1;
			} else if (_keyPad.right.isDown) {
				_targetX=1;
			} else {
				_targetX=0;
			}
		}
		//------ Step ------------------------------------
		public function step():void {
			if(_stickDown || _keyPad.anyDirection.isDown){
				_x += (_targetX - _x);
				_y += (_targetY - _y);
			}else{
				_x=0;
				_y=0;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}