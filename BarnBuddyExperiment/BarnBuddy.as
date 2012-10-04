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
package{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.*;
	
	import utils.bitmap.BitmapGraph;
	
	/**
	 * Bunny Mark test
	 * http://blog.iainlobb.com/2011/02/bunnymark-compiled-from-actionscript-to.html
	 */
	public class BarnBuddy {
		private var _entityManager:IEntityManager = null;
		private var _graphicManager:IGraphicManager = null;
		
		public function BarnBuddy() {
			_initVar();
			_initComponent();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager = EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			var entity:IEntity=_entityManager.createEntity("BarnBuddy");
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("BarnBuddy","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName("BarnBuddy","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("BarnBuddy","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var zoomComponent:ZoomComponent=_entityManager.addComponentFromName("BarnBuddy","ZoomComponent","myZoomComponent") as ZoomComponent;
			bitmapRenderComponent.registerPropertyReference("zoom");
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("BarnBuddy","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var spatialMoveComponent:SpatialMoveComponent=_entityManager.addComponentFromName("BarnBuddy","SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var panda:AnimationComponent=_entityManager.addComponentFromName("BarnBuddy","AnimationComponent","myPanda") as AnimationComponent;
			panda.loadGraphic(Framework.root+"assets/Panda.swf");
			//panda.registerPropertyReference("mouseInput",{onMouseRollOver:panda.onMouseRollOver, onMouseRollOut:panda.onMouseRollOut/*, onMouseDown:panda.onMouseDown, onMouseUp:panda.onMouseUp*/});
			panda.moveTo(Math.random()*Framework.width,Math.random()*Framework.height,1);
			var clone:AnimationComponent;
			for (var i:Number=0; i<500; i++){
				clone=panda.clone() as AnimationComponent;
				clone.moveTo(Math.random()*3000,Math.random()*3000+100,1);
				//clone.registerPropertyReference("mouseInput",{onMouseRollOver:clone.onMouseRollOver, onMouseRollOut:clone.onMouseRollOut/*, onMouseDown:clone.onMouseDown, onMouseUp:clone.onMouseUp*/});
			}
			var fox:MovingAnimationComponent=_entityManager.addComponentFromName("BarnBuddy","MovingAnimationComponent","myFox") as MovingAnimationComponent;
			fox.loadGraphic(Framework.root+"assets/Fox.swf",_onFoxAnimComplete);
			//fox.registerPropertyReference("mouseInput",{onMouseRollOver:fox.onMouseRollOver, onMouseRollOut:fox.onMouseRollOut/*, onMouseDown:fox.onMouseDown, onMouseUp:fox.onMouseUp*/});
			
			fox.moveTo(Math.random()*Framework.width,Math.random()*Framework.height,1);
		}
		//-------onFoxAnimComplete -------------------------------
		private function _onFoxAnimComplete($fox:AnimationComponent):void{
			_setFoxAnim($fox);
			var clone:MovingAnimationComponent;
			for (var i:Number=0; i<500; i++){
				clone=$fox.clone() as MovingAnimationComponent;
				clone.moveTo(Math.random()*3000,Math.random()*3000+100,1);
				//clone.registerPropertyReference("mouseInput",{onMouseRollOver:clone.onMouseRollOver, onMouseRollOut:clone.onMouseRollOut/*, onMouseDown:$animComponent.onMouseDown, onMouseUp:$animComponent.onMouseUp*/});
				_setFoxAnim(clone);
			}
		}
		//------- Set Fox Anim -------------------------------
		private function _setFoxAnim($fox:AnimationComponent):void{
			var foxPoses:Array = [
				{name:"POSE_IDLE", 		animations:[{name:"IDLE", f:2} , {name:"LOOK_UP", f:2}, {name:"IDLE_TAILWHIP", f:3}, {name:"GRAZE", f:2}, {name:"IDLE_TO_WALK", f:3}, {name:"IDLE_TO_RUN", f:3}]},
				{name:"POSE_WALK", 		animations:[{name:"WALK_CYCLE", f:1}]},
				{name:"POSE_WALK_IDLE", animations:[{name:"WALK_CYCLE", f:1},{name:"WALK_TO_IDLE", f:2}]},
				{name:"POSE_RUN", 		animations:[{name:"RUN_CYCLE", f:1}]},
				{name:"POSE_RUN_IDLE", 	animations:[{name:"RUN_CYCLE", f:1},{name:"RUN_TO_IDLE", f:2}]},
				{name:"POSE_FALL", 		animations:[{name:"FALL", f:1}]}
			];
			var graph:BitmapGraph = $fox.bitmapSet.graph;
			graph.createSequence(foxPoses);
			graph.animations["IDLE"].nextPose = "POSE_IDLE";
			graph.animations["LOOK_UP"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TAILWHIP"].nextPose = "POSE_IDLE";
			graph.animations["JUMP"].nextPose = "POSE_IDLE";
			graph.animations["GRAZE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_WALK"].nextPose = "POSE_WALK";
			graph.animations["WALK_CYCLE"].nextPose = "POSE_WALK_IDLE";
			graph.animations["WALK_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_RUN"].nextPose = "POSE_RUN";
			graph.animations["RUN_CYCLE"].nextPose = "POSE_RUN_IDLE";
			graph.animations["RUN_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["JUMP"].nextPose = "POSE_FALL";
			graph.animations["FALL"].nextPose = "POSE_IDLE";
		}
	}
}