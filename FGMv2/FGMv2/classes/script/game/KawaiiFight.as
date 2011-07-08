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
	import framework.add.architecture.component.*;

	import flash.events.Event;
	/**
	* Script Class
	*
	*/
	public class KawaiiFight {

		private var _entityManager:IEntityManager=null;
		
		public function KawaiiFight() {
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
			//var entity:IEntity=_entityManager.createEntity("GameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponentFromName("GameEntity","KeyboardInputComponent","myKeyInputComponent") as KeyboardInputComponent;
			keyboardInputComponent.useZQSD();//AZERTY
			//keyboardInputComponent.useWASD();//QWERTY
			keyboardInputComponent.useOKLM();
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponentFromName("GameEntity","KeyboardMoveComponent","myKeyMoveComponent") as KeyboardMoveComponent;
			var animationComponent:AnimationComponent=_entityManager.addComponentFromName("GameEntity","AnimationComponent","myAnimationComponent") as AnimationComponent;
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponentFromName("GameEntity","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponentFromName("GameEntity","ProgressBarComponent","myProgressBarComponent") as ProgressBarComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("GameEntity","TimerComponent","myTimerComponent") as TimerComponent;
			var bg:GraphicComponent= _entityManager.addComponentFromName("GameEntity","GraphicComponent","myBgGraphicComponent") as GraphicComponent;
			bg.loadGraphic("../texture/framework/game/background/bladesquad/kawaiiFight.png");
			var statut:GraphicComponent= _entityManager.addComponentFromName("GameEntity","GraphicComponent","myStatutGraphicComponent") as GraphicComponent;
			statut.loadGraphic("../texture/framework/game/interface/bladesquad/statutClip.swf");
			var swfPlayerComponent:SwfPlayerComponent=_entityManager.addComponentFromName("GameEntity","SwfPlayerComponent","mySwfPlayerComponent") as SwfPlayerComponent;
			swfPlayerComponent.addEventListener(Event.COMPLETE, onBebeComplete);
			swfPlayerComponent.loadPlayer("../xml/framework/game/swfPlayerKawaiiFight.xml", "bebeClip",2);
			swfPlayerComponent.registerPropertyReference("keyboardMove");
			swfPlayerComponent.moveTo(150,300);
			var gamePadComponent:GamePadComponent=_entityManager.addComponentFromName("GameEntity","GamePadComponent","myGamePadComponent") as GamePadComponent;
			gamePadComponent.moveTo(60,290);
		}
		//------ On Bebe Complete ------------------------------------
		private function onBebeComplete(evt:Event):void {
			evt.currentTarget.addGraphicFromName("bebeVisage", "Head",2);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}