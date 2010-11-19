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
	
	import framework.core.architecture.component.add.*;
	/**
	* Component Reference Class
	* 
	*/
	public class ComponentReference{

		public function ComponentReference() {
			initReference();
		}
		//------ Init Reference ------------------------------------
		private function initReference():void {
			//-- In order to import your component  classes in the compiled SWF and use them at runtime --
			//-- please insert your component classes here as follow --
			var keyboardInputComponent:KeyboardInputComponent;
			var keyboardMoveComponent:KeyboardMoveComponent;
			var mouseInputComponent:MouseInputComponent;
			var serverInputComponent:ServerInputComponent;
			var systemInfoComponent:SystemInfoComponent;
			var renderComponent:RenderComponent;
			var spatialComponent:SpatialComponent;
			var timeComponent:TimeComponent;
			var timerComponent:TimerComponent;
			var graphicComponent:GraphicComponent;
			var tileMapComponent:TileMapComponent;
			var scrollingBitmapComponent:ScrollingBitmapComponent;
			var playerComponent:PlayerComponent;
			var bitmapPayerComponent:BitmapPlayerComponent;
			var animationComponent:AnimationComponent;
			var textComponent:TextComponent;
			var factoryComponent:FactoryComponent;
			var swfPlayerComponent:SwfPlayerComponent;
			var progressBarComponent:ProgressBarComponent;
			var soundComponent:SoundComponent;
			var messageComponent:MessageComponent;
			var multiPlayerComponent:MultiPlayerComponent;
			var cursorComponent:CursorComponent;
			var jaugeComponent:JaugeComponent;
			var jaugeMoveComponent:JaugeMoveComponent;
			var chronoComponent:ChronoComponent;
			var keyboardRotationComponent:KeyboardRotationComponent;
			var groundSphereComponent:GroundSphereComponent;
			var exportComponent:ExportComponent;
			var navigationComponent:NavigationComponent;
			var backgroundColorComponent:BackgroundColorComponent;
			var tileMapEditorComponent:TileMapEditorComponent;
			var healthComponent:HealthComponent;
			var keyboardAttackComponent:KeyboardAttackComponent;
			var tweenComponent:TweenComponent;
			var loadingComponent:LoadingComponent;
			var gamePadComponent:GamePadComponent;
		}
	}
}