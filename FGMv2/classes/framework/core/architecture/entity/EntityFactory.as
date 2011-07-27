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
*    Inspired from Ember  
*    Tom Davies 2010
*    http://github.com/tdavies/Ember/wiki
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

package framework.core.architecture.entity{
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.add.architecture.component.*;
	import framework.core.architecture.component.*;
	import framework.core.architecture.entity.IEntity;
	
	/**
	 * Entity Factory 2D
	 */
	public class EntityFactory {
		
		private static var entityManager:IEntityManager=EntityManager.getInstance(); 
		
		//------- Create System Info -------------------------------
		public static function createSystemInfo($entityName:String, $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent = entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var systemInfoComponent:SystemInfoComponent=entityManager.addComponentFromName($entityName,"SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
			systemInfoComponent.moveTo($x, $y);
		}
		//------- Create GamePad -------------------------------
		public static function createGamePad($entityName:String, $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var gamePadComponent:GamePadComponent=entityManager.addComponentFromName($entityName,"GamePadComponent","myGamePadComponent") as GamePadComponent;
			gamePadComponent.moveTo($x, $y);
			FlashGameMaker.Focus();
		}
		//------- Create Graphic -------------------------------
		public static function createGraphic($entityName:String, $path:String,  $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var graphicComponent:GraphicComponent=entityManager.addComponentFromName($entityName,"GraphicComponent","myGraphicComponent") as GraphicComponent;
			graphicComponent.loadGraphic($path);
			graphicComponent.moveTo($x,$y);
		}
		//------- Create Cursor -------------------------------
		public static function createCursor($entityName:String, $path:String):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var cursorComponent:CursorComponent=entityManager.addComponentFromName($entityName,"CursorComponent","myCursorComponent") as CursorComponent;
			cursorComponent.loadGraphic($path);
		}
		//------- Create Time -------------------------------
		public static function createTime($entityName:String,$timerDelay:uint, $timeDelay:uint, $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:$timerDelay}) as TimerComponent;
			var timeComponent:TimeComponent=entityManager.addComponentFromName($entityName,"TimeComponent","myTimeComponent", {delay:$timeDelay}) as TimeComponent;
			timeComponent.moveTo($x,$y);
		}
		//------- Create Chrono -------------------------------
		public static function createChrono($entityName:String, $path:String, $timerDelay:uint, $chronoDelay:uint, $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:$timerDelay}) as TimerComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var chronoComponent:ChronoComponent=entityManager.addComponentFromName($entityName,"ChronoComponent","myChronoComponent",{delay:$chronoDelay}) as ChronoComponent;
			chronoComponent.loadGraphic($path);
			chronoComponent.moveTo($x,$y);
		}
		//------- Create 2D Player -------------------------------
		public static function create2DPlayer($entityName:String, $path:String,  $x:Number, $y:Number,  $speed:Point = null, $iso:Boolean=false, $horizontal:Boolean=true, $vertical:Boolean=true, $diagonal:Boolean=false):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var keyboardMoveComponent:KeyboardMoveComponent=entityManager.addComponentFromName($entityName,"KeyboardMoveComponent","myKeyboardMoveComponent") as KeyboardMoveComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var mouseMoveComponent:MouseMoveComponent=entityManager.addComponentFromName($entityName,"MouseMoveComponent","myMouseMoveComponent") as MouseMoveComponent;
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var playerComponent:PlayerComponent=entityManager.addComponentFromName($entityName,"PlayerComponent","myPlayerComponent") as PlayerComponent;
			playerComponent.loadGraphic($path);
			playerComponent.moveTo($x,$y);
		}
		//------- Create Animation -------------------------------
		public static function createAnimation($entityName:String, $path:String,  $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var animationComponent:AnimationComponent=entityManager.addComponentFromName($entityName,"AnimationComponent","myAnimationComponentt") as AnimationComponent;
			animationComponent.loadGraphic($path);
			animationComponent.moveTo($x,$y);
		}
		//------- Create Animations -------------------------------
		public static function createAnimations($entityName:String):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var panda:AnimationComponent=entityManager.addComponentFromName($entityName,"AnimationComponent","myPanda"/*, {bounds:new Rectangle(0,0,200,200)}*/) as AnimationComponent;
			panda.loadGraphic("../assets/Panda.swf");
			panda.moveTo(Math.random()*FlashGameMaker.width,Math.random()*FlashGameMaker.height);
			var fox:AnimationComponent=entityManager.addComponentFromName($entityName,"AnimationComponent","myFox"/*, {bounds:new Rectangle(0,0,100,80)}*/) as AnimationComponent;
			fox.loadGraphic("../assets/Fox.swf");
			fox.moveTo(Math.random()*FlashGameMaker.width,Math.random()*FlashGameMaker.height);
			var clone:AnimationComponent;
			for (var i:Number=0; i<200; i++){
				clone=panda.clone("myPandaClone"+i) as AnimationComponent;
				clone.moveTo(Math.random()*2000,Math.random()*1000);
				clone=fox.clone("myFoxClone"+i) as AnimationComponent;
				clone.moveTo(Math.random()*2000,Math.random()*1000);
			}
			var systemInfoComponent:SystemInfoComponent=entityManager.addComponentFromName($entityName,"SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
		}
		//------- Create Background Color -------------------------------
		public static function createBgColor($entityName:String, $color:uint, $alpha:Number=1):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var simpleGraphicComponent:SimpleGraphicComponent=entityManager.addComponentFromName($entityName,"SimpleGraphicComponent","mySimpleGraphicComponent", {color:$color, alpha:$alpha}) as SimpleGraphicComponent;
		}
		//------- Create Background Color -------------------------------
		public static function createBgGradientColor($entityName:String, $type:String, $colors:Array, $alphas:Array, $ratios:Array, $rectangle:Rectangle=null,$matrix:Matrix=null):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			if(!$matrix){
				$matrix = new Matrix();
				$matrix.createGradientBox(50, 50, Math.PI/2, 0, 0);
			}
			var simpleGraphicComponent:SimpleGraphicComponent=entityManager.addComponentFromName($entityName,"SimpleGraphicComponent","mySimpleGraphicComponent", {type:$type, colors:$colors, alphas:$alphas, ratios:$ratios, rectangle:$rectangle, matrix:$matrix}) as SimpleGraphicComponent;
		}
		//------- Create Scrolling Bitmap -------------------------------
		public static function createScrollingBitmap($entityName:String, $path:String,  $x:Number, $y:Number, $frameRate:Number, $speed:Point=null, $autoScroll:Boolean=true, $loop:Boolean=true):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent",{frameRate:$frameRate}) as EnterFrameComponent;
			var scrollingBitmapComponent:ScrollingBitmapComponent=entityManager.addComponentFromName($entityName,"ScrollingBitmapComponent","myScrollingBitmapComponent", {speed:$speed, autoScroll:$autoScroll, loop:$loop}) as ScrollingBitmapComponent;
			scrollingBitmapComponent.loadGraphic($path);
			scrollingBitmapComponent.moveTo($x,$y);
		}
		//------- ToString -------------------------------
		public function ToString():void{
			trace();
		}
	}
}