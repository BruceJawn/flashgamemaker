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
	import flash.events.*;
	
	import framework.core.architecture.entity.IEntity;
	
	/**
	* AnimationComponent Class
	*/
	public class AnimationComponent extends Component {

		private var _isRunning:Boolean = false;
		
		public function AnimationComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
		
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			addEventListener(Event.ENTER_FRAME, onTick);
		}
		//------ Remove Listener ------------------------------------
		private function removeListener():void {
			removeEventListener(Event.ENTER_FRAME, onTick);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
		}
		//------ On Anim Change ------------------------------------
		protected function onAnimChange($gamePad:Object):void {
		}
		//------ On Tick ------------------------------------
		private function onTick($evt:Event):void {
			
		}
		//------ Move Right ------------------------------------
		protected function moveRight():void {
		}
		//------ Move Left ------------------------------------
		protected function moveLeft():void {
		}
		//------ Move Up ------------------------------------
		protected function moveUp():void {
		}
		//------ Move Down ------------------------------------
		protected function moveDown():void {
		}
		//------ Move  ------------------------------------
		protected function move():void {
		}
		//------Stop ------------------------------------
		public function start():void {
			if(!_isRunning){
				initListener();
				_isRunning = true;
			}
		}
		//------Stop ------------------------------------
		public function stop():void {
			if(_isRunning){
				removeListener();
				_isRunning = false;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}