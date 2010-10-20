﻿/*
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
	public class ScriptKawaiiOlympic {

		private var _scriptName:String = null;
		private var _entityManager:IEntityManager=null;
		
		public function ScriptKawaiiOlympic(scriptName:String) {
			initVar(scriptName);
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar(scriptName:String):void {
			_scriptName = scriptName;
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			var entity:IEntity=_entityManager.createEntity("Entity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyboardInputComponent:KeyboardInputComponent=_entityManager.addComponent("Entity","KeyboardInputComponent","myKeyInputComponent");
			keyboardInputComponent.setKeysFromPath("xml/framework/game/keyboardConfig.xml","KeyboardConfig");
			var keyboardMoveComponent:KeyboardMoveComponent=_entityManager.addComponent("Entity","KeyboardMoveComponent","myKeyMoveComponent");
			var animationComponent:AnimationComponent=_entityManager.addComponent("Entity","AnimationComponent","myAnimationComponent");
			var mouseInputComponent:MouseInputComponent=_entityManager.addComponent("Entity","MouseInputComponent","myMouseInputComponent");
			var progressBarComponent:ProgressBarComponent=_entityManager.addComponent("Entity","ProgressBarComponent","myProgressBarComponent");
			var timerComponent:TimerComponent=_entityManager.addComponent("Entity","TimerComponent","myTimerComponent");
			var scrollingBitmapComponent:ScrollingBitmapComponent=_entityManager.addComponent("Entity","ScrollingBitmapComponent","myScrollingBitmapComponent");
			scrollingBitmapComponent.loadGraphic("texture/framework/game/backGround/bladesquad/nuage.jpg","Nuage");
			scrollingBitmapComponent.setPropertyReference("keyboardInput",scrollingBitmapComponent._componentName);
			scrollingBitmapComponent.setScrolling(30,1);
			scrollingBitmapComponent.setPropertyReference("timer",scrollingBitmapComponent._componentName);
			var graphicComponent:GraphicComponent=_entityManager.addComponent("Entity","GraphicComponent","myGraphicComponent");
			graphicComponent.loadGraphic("texture/framework/game/backGround/bladesquad/piste.jpg","Piste");
			graphicComponent.moveTo(0,108);
			var swfPlayerComponent=_entityManager.addComponent("Entity","SwfPlayerComponent","mySwfPlayerComponent");
			swfPlayerComponent.loadPlayer("xml/framework/game/swfPlayerKawaiiIsland.xml", "mySwfPlayer");
			swfPlayerComponent.setDirection("Horizontal");
			swfPlayerComponent.setPropertyReference("jaugeMove",swfPlayerComponent._componentName);
			swfPlayerComponent.moveTo(120,300);
			var jaugeComponent:JaugeComponent=_entityManager.addComponent("Entity","JaugeComponent","myJaugeComponent");
			jaugeComponent.setDirection("vertical");
			jaugeComponent.moveTo(180,315);
			var jaugeMoveComponent:JaugeMoveComponent=_entityManager.addComponent("Entity","JaugeMoveComponent","myJaugeMoveComponent");
			var chronoComponent:ChronoComponent = _entityManager.addComponent("Entity","ChronoComponent","myChronoComponent");
			chronoComponent.moveTo(160,60);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}