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

package script{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	/**
	* Script Class
	*
	*/
	public class Factory {

		private var _entityManager:IEntityManager=null;
		
		public function Factory() {
			initVar();
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			var entity:IEntity=_entityManager.createEntity("Factory");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("Factory","KeyboardInputComponent","myKeyInputComponent");
			//keyboardInputComponent.setKeysFromPath("xml/framework/game/keyboardConfig.xml","KeyboardConfig");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("Factory","KeyboardMoveComponent","myKeyMoveComponent");
			var keyboardRotationComponent:KeyboardRotationComponent=_entityManager.addComponent("Factory","KeyboardRotationComponent","myKeyboardRotationComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("Factory","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("Factory","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("Factory","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("Factory","TimerComponent","myTimerComponent");
			var factoryComponent:FactoryComponent=_entityManager.addComponent("Factory","FactoryComponent","myFactoryComponent");
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}