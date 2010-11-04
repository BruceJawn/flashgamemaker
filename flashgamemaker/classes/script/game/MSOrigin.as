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

package script.game{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	
	import flash.events.Event;
	/**
	* Script Class
	*
	*/
	public class MSOrigin {

		private var _scriptName:String=null;
		private var _entityManager:IEntityManager=null;

		public function MSOrigin(scriptName:String) {
			initVar(scriptName);
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar(scriptName:String):void {
			_scriptName=scriptName;
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			//var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("GameEntity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.setKeysFromPath("xml/framework/game/keyboardConfig.xml","KeyboardConfig");
			keyboardInputComponent.setKey(40, "SIT");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("GameEntity","KeyboardMoveComponent","myKeyMoveComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("GameEntity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("GameEntity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("GameEntity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("GameEntity","TimerComponent","myTimerComponent");
			var backGroundColorComponent:BackGroundColorComponent= _entityManager.addComponent("GameEntity","BackGroundColorComponent","myBackGroundColorComponent");
			backGroundColorComponent.changeColor("111111");
			var bitmapPlayerComponent:BitmapPlayerComponent=_entityManager.addComponent("GameEntity","BitmapPlayerComponent","myBitmapPlayerComponent");
			bitmapPlayerComponent.loadPlayer("xml/framework/game/bitmapPlayerMSOrigin.xml","MSOrigin");
			bitmapPlayerComponent.setPropertyReference("keyboardFire",bitmapPlayerComponent._componentName);
			bitmapPlayerComponent.setDirection("Horizontal");
			bitmapPlayerComponent.setCollision(true);
			bitmapPlayerComponent.moveTo(50,200);
			bitmapPlayerComponent.setAnim("WALK",2);
			bitmapPlayerComponent.setAnim("ATTACK",1);
			bitmapPlayerComponent.setAnim("JUMP",8);
			bitmapPlayerComponent.setAnim("SIT",5);
			var backGroundComponent:ScrollingBitmapComponent= _entityManager.addComponent("GameEntity","ScrollingBitmapComponent","myBackGroundComponent");
			backGroundComponent.loadGraphic("texture/framework/game/background/ms/BG.gif", "MS_BG");
			backGroundComponent.setScrolling(30,5);
			//backGroundComponent.setDirection(swfPlayerComponent.getDirection());
			backGroundComponent.setPropertyReference("timer",backGroundComponent._componentName);
			backGroundComponent.moveTo(0,100);
			var soundComponent:SoundComponent=_entityManager.addComponent("GameEntity","SoundComponent","mySoundComponent");
			soundComponent.setController("texture/framework/interface/soundControl.swf","SoundControl");
			//soundComponent.play("sound/ms/No_Need_to_Reload.mp3","NoNeedToReload", 0.1);
			soundComponent.moveTo(300,310);
			var tweenComponent:TweenComponent=_entityManager.addComponent("GameEntity","TweenComponent","myTweenComponent");
			var healthComponent:HealthComponent=_entityManager.addComponent("GameEntity","HealthComponent","myHealthComponent");
			var keyboardFireComponent:KeyboardFireComponent=_entityManager.addComponent("GameEntity","KeyboardFireComponent","myKeyboardFireComponent");
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}