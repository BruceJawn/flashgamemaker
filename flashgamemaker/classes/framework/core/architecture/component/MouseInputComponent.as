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
	import framework.core.architecture.entity.*;
	import framework.core.system.MouseManager;
	import framework.core.system.IMouseManager;

	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MouseInputComponent extends Component {

		private var _mouseManager:IMouseManager=null;

		public function MouseInputComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_mouseManager=MouseManager.getInstance();
			_mouseManager.register(this);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			var dispatcher:EventDispatcher=_mouseManager.getDispatcher();
			dispatcher.addEventListener(MouseEvent.CLICK, onMouseFire);
			//dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, onMouseFire);
			//dispatcher.addEventListener(MouseEvent.MOUSE_UP, onMouseFire);
			//dispatcher.addEventListener(MouseEvent.MOUSE_MOVE, onMouseFire);
			dispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseFire);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			var dispatcher:EventDispatcher=_mouseManager.getDispatcher();
			dispatcher.removeEventListener(MouseEvent.CLICK, onMouseFire);
			dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseFire);
			dispatcher.removeEventListener(MouseEvent.MOUSE_UP, onMouseFire);
			dispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseFire);
			dispatcher.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseFire);
		}
		//------ On Mouse Change ------------------------------------
		private function onMouseFire(evt:MouseEvent):void {
			getMouse();
		}
		//------ Get Mouse ------------------------------------
		private function getMouse():void {
			var mouse:Object=_mouseManager.getMouse();
			var mouseObject:String="MouseInput Type:"+mouse.type+" ,TargetName:"+mouse.targetName;
			mouseObject+=" ,Target:"+mouse.target+" ,StageX:"+mouse.stageX+" ,StageY:"+mouse.stageY;
			mouseObject+=" ,Shift:"+mouse.shiftKey+" ,Ctrl:"+mouse.ctrlKey+" ,ButtonDown:"+mouse.buttonDown;
			mouseObject+=" ,Delta:"+mouse.delta+" ,LongClick:"+mouse.longClick;
			trace(mouseObject);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}