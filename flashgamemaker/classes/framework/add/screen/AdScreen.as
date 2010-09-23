/*
*   @author AngelStreet
*   Blog:http://angelstreetv2.blogspot.com/
*   Google Code: http://code.google.com/p/2d-isometric-engine/
*   Source Forge: https://sourceforge.net/projects/isoengineas3/
*/

/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*
*    This program is distrubuted through the Creative Commons Attribution-NonCommercial 3.0 Unported License.
*    Under this licence you are free to copy, adapt and distrubute the work. 
*    You must attribute the work in the manner specified by the author or licensor. 
*    You may not use this work for commercial purposes.  
*    You should have received a copy of the Creative Commons Public License along with this program.
*    If not,visit http://creativecommons.org/licenses/by-nc/3.0/ or send a letter to Creative Commons,
*    171 Second Street, Suite 300, San Francisco, California, 94105, USA.  
*/

package framework.add.screen{
	import framework.core.system.InterfaceEvent;
	
	import flash.display.*;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	* Interface Class
	* @ purpose: Interface Screen description.
	*/
	public class AdScreen extends InterfaceScreen {

		private var _skipBt:SimpleButton=null;
		private var _contentClip:MovieClip=null;

		public function AdScreen(name:String,clip:MovieClip) {
			super(name,clip);
			initVar();
			stopAnim();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_isAnimated = true;
			_skipBt=_clip.skipBt;
			_contentClip=_clip.contentClip;
		}
		//------ Start Anim ------------------------------------
		protected override function startAnim():void {
			restartAnim();
		}
		//------ Stop Anim ------------------------------------
		protected function stopAnim():void {
			_contentClip.stop();
		}
		//------ Restart Anim ------------------------------------
		protected function restartAnim():void {
			_contentClip.gotoAndPlay(1);
		}
		//------ Init Listener ------------------------------------
		private function initListener( ):void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_skipBt.addEventListener(MouseEvent.CLICK,onSkipClick);
			_clip.addEventListener(KeyboardEvent.KEY_UP, onKeyPress);
		}
		//------ On Enter Frame ------------------------------------
		private function onEnterFrame(event:Event):void {
			if (_contentClip.currentFrame==_contentClip.totalFrames) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_screenDestination="GameScreen";
				dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
			}
		}
		//------ On Skip Click ------------------------------------
		private function onSkipClick(event:MouseEvent):void {
			_screenDestination="GameScreen";
			dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
		}
		//------ On Press Enter ------------------------------------
		private function onKeyPress(keyBoardEvent:KeyboardEvent):void {
			var keyCode:uint=keyBoardEvent.keyCode;
			if (keyCode==Keyboard.ESCAPE) {
				_contentClip.gotoAndStop(1);
				_screenDestination="MenuScreen";
				dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
			} else if (keyCode==Keyboard.ENTER) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_screenDestination="GameScreen";
				dispatchEvent(new InterfaceEvent(InterfaceEvent.NAVIGATION_CHANGE));
			}
		}
	}
}