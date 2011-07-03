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
	public class KawaiiOlympic {

		private var _entityManager:IEntityManager=null;

		public function KawaiiOlympic() {
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
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponentFromName("GameEntity","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponentFromName("GameEntity","ProgressBarComponent","myProgressBarComponent") as ProgressBarComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("GameEntity","TimerComponent","myTimerComponent") as TimerComponent;
			var swfPlayerComponent:SwfPlayerComponent=_entityManager.addComponentFromName("GameEntity","SwfPlayerComponent","mySwfPlayerComponent") as SwfPlayerComponent;
			swfPlayerComponent.loadGraphic("../texture/framework/game/charset/bladesquad/kidClip.swf");
			//swfPlayerComponent.setCollision(true);
			swfPlayerComponent.registerPropertyReference("jaugeMove");
			swfPlayerComponent.moveTo(50,300);
			swfPlayerComponent.addEventListener(Event.COMPLETE,onLoadingSuccessful);
			var scrollingBitmapComponent:ScrollingBitmapComponent = _entityManager.addComponentFromName("GameEntity", "ScrollingBitmapComponent", "myScrollingBitmapComponent") as ScrollingBitmapComponent;
			scrollingBitmapComponent.loadGraphic("../texture/framework/game/background/bladesquad/nuage.jpg");
			scrollingBitmapComponent.setLoop(true);
			scrollingBitmapComponent.setScrolling(30,1);
			scrollingBitmapComponent.registerPropertyReference("timer");
			var scrollingBitmapComponent2:ScrollingBitmapComponent = _entityManager.addComponentFromName("GameEntity", "ScrollingBitmapComponent", "myScrollingBitmapComponent2") as ScrollingBitmapComponent;
			scrollingBitmapComponent2.loadGraphic("../texture/framework/game/background/bladesquad/piste.jpg");
			scrollingBitmapComponent2.registerPropertyReference("timer");
			scrollingBitmapComponent2.setScrolling(30,4);
			scrollingBitmapComponent2.setScrollingTarget(swfPlayerComponent);
			scrollingBitmapComponent2.moveTo(0,108);
			var jaugeComponent:JaugeComponent = _entityManager.addComponentFromName("GameEntity", "JaugeComponent", "myJaugeComponent") as JaugeComponent;
			jaugeComponent.isListening(false);
			jaugeComponent.setDirection("vertical");
			jaugeComponent.moveTo(180,305);
			var chronoComponent:ChronoComponent = _entityManager.addComponentFromName("GameEntity", "ChronoComponent", "myChronoComponent") as ChronoComponent;
			chronoComponent.moveTo(160,60);
		}
		//------ On Loading Successful ------------------------------------
		private function onLoadingSuccessful( evt:Event ):void {
			evt.target.removeEventListener(Event.COMPLETE, onLoadingSuccessful);
			var chronoComponent:ChronoComponent = _entityManager.getComponent("GameEntity", "myChronoComponent") as ChronoComponent;
			chronoComponent.restart();
			chronoComponent.addEventListener(Event.COMPLETE, onChronoComplete);
		}
		//------ On Loading Successful ------------------------------------
		private function onChronoComplete( evt:Event ):void {
			var animationComponent:AnimationComponent=_entityManager.addComponentFromName("GameEntity","AnimationComponent","myAnimationComponent") as AnimationComponent;
			var jaugeComponent:JaugeComponent=_entityManager.getComponent("GameEntity","myJaugeComponent") as JaugeComponent;
			jaugeComponent.isListening(true);
			var jaugeMoveComponent:JaugeMoveComponent=_entityManager.addComponentFromName("GameEntity","JaugeMoveComponent","myJaugeMoveComponent") as JaugeMoveComponent;
			var gamePadComponent:GamePadComponent=_entityManager.addComponentFromName("GameEntity","GamePadComponent","myGamePadComponent") as GamePadComponent;
			gamePadComponent.hideAll();
			gamePadComponent.showButton("_left");
			gamePadComponent.moveButton("_left",170,60);
			gamePadComponent.showButton("_right");
			gamePadComponent.moveButton("_right",220,60);
			gamePadComponent.changeColor("FF0000");
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}