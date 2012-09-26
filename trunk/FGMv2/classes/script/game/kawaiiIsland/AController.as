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
package script.game.kawaiiIsland{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import framework.component.core.AnimationComponent;
	import framework.component.core.GraphicComponent;
	import framework.component.core.PlayerComponent;
	import framework.entity.EntityManager;
	import framework.entity.IEntityManager;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.fx.Fx;
	import utils.mouse.MousePad;
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;

	/**
	 * Animation Controller
	 */
	public class AController{
		
		private var _entityManager:IEntityManager=null;
		private var _mouseManager:IMouseManager = null;
		private var _kawaiiProgressBar:GraphicComponent = null;
		private var _kawaiiCraftBar:GraphicComponent = null;
		private var _kawaiiTreeRollOver:GraphicComponent = null;
		private var _kawaiiRockRollOver:GraphicComponent = null;
		private var _kawaiiWellRollOver:GraphicComponent = null;
		private var _kawaiiBuildRollOver:GraphicComponent = null;
		private var _game:Game = null;
		private var _baby:PlayerComponent=null;
		private var _currentCraft:GraphicComponent = null;
		private var _gInterface:GInterface = null;
		
		public function AController($game:Game, $gInterface:GInterface){
			initVar($game,$gInterface);
		}
		//------ Init Var ------------------------------------
		private function initVar($game:Game, $gInterface:GInterface):void {
			_game = $game;
			_gInterface = $gInterface;
			_entityManager=EntityManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_kawaiiProgressBar = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","progressBar") as GraphicComponent;
			_kawaiiProgressBar.graphic = new KawaiiProgressBar;
			_kawaiiProgressBar.visible = false;
			_kawaiiCraftBar = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","craftBar") as GraphicComponent;
			_kawaiiCraftBar.graphic = new KawaiiCraftBar;
			_kawaiiCraftBar.visible = false;
			_kawaiiTreeRollOver = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","treeRollOver") as GraphicComponent;
			_kawaiiTreeRollOver.graphic = new KawaiiTreeRollOver;
			_kawaiiTreeRollOver.visible = false;
			_kawaiiRockRollOver = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","rockRollOver") as GraphicComponent;
			_kawaiiRockRollOver.graphic = new KawaiiRockRollOver;
			_kawaiiRockRollOver.visible = false;
			_kawaiiWellRollOver = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","wellRollOver") as GraphicComponent;
			_kawaiiWellRollOver.graphic = new KawaiiWellRollOver;
			_kawaiiWellRollOver.visible = false;
			_kawaiiBuildRollOver = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","buildRollOver") as GraphicComponent;
			_kawaiiBuildRollOver.graphic = new KawaiiBuildRollOver;
			_kawaiiBuildRollOver.visible = false;
		}
		
		// **   Tree   **********
		//------ On Tree RollOver ------------------------------------
		public function onTreeRollOver($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = StyleManager.RedHalo;
			_kawaiiTreeRollOver.moveTo(target.x+target.graphic.width-30,target.y-_kawaiiTreeRollOver.graphic.height/2,1);
			_kawaiiTreeRollOver.visible = true;
			showCraftStatut(target);
		}
		//------ On Tree RollOut ------------------------------------
		public function onTreeRollOut($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = [];
			_kawaiiTreeRollOver.visible = false;
			hideCraftStatut();
		}
		//------ On Tree RollClick ------------------------------------
		public function onTreeClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			//_kawaiiTreeRollOver.visible = true;
			showCraftStatut(target);
			movePlayer($mousePad);
			_currentCraft = _kawaiiTreeRollOver;
		}
		// **   Rock   **********
		public function onRockRollOver($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = StyleManager.RedHalo;
			_kawaiiRockRollOver.moveTo(target.x+target.graphic.width-30,target.y-_kawaiiRockRollOver.graphic.height/2,1);
			_kawaiiRockRollOver.visible = true;
			showCraftStatut(target);
		}
		//------ On Rock RollOut ------------------------------------
		public function onRockRollOut($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = [];
			_kawaiiRockRollOver.visible = false;
			hideCraftStatut();
		}
		//------ On Rock RollOver ------------------------------------
		public function onRockClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			//_kawaiiRockRollOver.visible = true;
			showCraftStatut(target);
			movePlayer($mousePad);
			_currentCraft = _kawaiiRockRollOver;
		}
		// **   Well   **********
		public function onWellRollOver($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = StyleManager.RedHalo;
			_kawaiiWellRollOver.moveTo(target.x+target.graphic.width-30,target.y-_kawaiiWellRollOver.graphic.height/2,1);
			_kawaiiWellRollOver.visible = true;
			showCraftStatut(target);
		}
		//------ On Well RollOver ------------------------------------
		public function onWellRollOut($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = [];
			_kawaiiWellRollOver.visible = false;
			hideCraftStatut();
		}
		//------ On Well RollOver ------------------------------------
		public function onWellClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			//_kawaiiWellRollOver.visible = true;
			showCraftStatut(target);
			movePlayer($mousePad);
			_currentCraft = _kawaiiWellRollOver;
		}
		// **   Build   **********
		public function onBuildRollOver($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = StyleManager.RedHalo;
			_kawaiiBuildRollOver.moveTo(target.x+target.graphic.width,target.y-_kawaiiBuildRollOver.graphic.height/2,1);
			_kawaiiBuildRollOver.visible = true;
			showCraftStatut(target);
		}
		//------ On Build RollOut ------------------------------------
		public function onBuildRollOut($mousePad:MousePad):void {
			if(_currentCraft)	return;
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = [];
			_kawaiiBuildRollOver.visible = false;
			hideCraftStatut();
		}
		//------ On Build RollOver ------------------------------------
		public function onBuildClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			//_kawaiiBuildRollOver.visible = true;
			showCraftStatut(target);
			movePlayer($mousePad);
			_currentCraft = _kawaiiBuildRollOver;
		}
		//------ Show Craft Statut ------------------------------------
		public function showCraftStatut($target:GraphicComponent):void {
			_kawaiiCraftBar.moveTo($target.x+($target.graphic.width-_kawaiiCraftBar.graphic.width)/2+15,$target.y-_kawaiiCraftBar.graphic.height-5,1);
			_kawaiiCraftBar.visible = true;
		}
		//------ Hide Craft Statut ------------------------------------
		public function hideCraftStatut():void {
			_kawaiiCraftBar.visible = false;
		}
		//------ Move Player ------------------------------------
		public function movePlayer($mousePad:MousePad):void {
			if(_baby){
				_mouseManager.mouseTargets = new Array;
				_baby.callback.onMouseStopMoving = onBabyStopMoving;
				var target:AnimationComponent = _mouseManager.clicked as AnimationComponent;
				if(target){
					$mousePad.offset.x =  - Math.round($mousePad.mouseEvent.stageX - target.x  - target.bitmapData.width/2+_baby.graphic.width/2);
					$mousePad.offset.y =  - Math.round($mousePad.mouseEvent.stageY - target.y  - target.bitmapData.height+_baby.graphic.height/2-5);
				}
				
				_baby.onMouseUp($mousePad);
				$mousePad.offset = new Point();
			}
		}
		//------ Move Player ------------------------------------
		public function onBabyStopMoving():void {
			if(!_currentCraft)	return;
			_kawaiiProgressBar.visible = true;
			_kawaiiProgressBar.moveTo(_kawaiiCraftBar.x-5,_kawaiiCraftBar.y-_kawaiiProgressBar.graphic.height-5,1);
			var target:MovieClip = _kawaiiProgressBar.graphic.progressBar.bar;
			TweenLite.killTweensOf(target);
			target.x = -target.width;
			TweenLite.to(target,6,{x:0, onComplete:onProgressComplete});
			if(_currentCraft==_kawaiiTreeRollOver){
				_baby.anim("CHOP_RIGHT");
			}else if(_currentCraft==_kawaiiRockRollOver){
				_baby.anim("SMASH_RIGHT");
			}else if(_currentCraft==_kawaiiWellRollOver){
				_baby.anim("WATER_RIGHT");
			}else if(_currentCraft==_kawaiiBuildRollOver){
				//_baby.anim("BUILD_RIGHT");
			}
		}
		//------ On Progress Complete ------------------------------------
		public function onProgressComplete():void {
			Fx.DisappearingText(new Point(_baby.x,_baby.y),"-"+1+" energy",0xFBF94D,null,4);
			var energyBar:MovieClip = _gInterface.profilBar.graphic.energyStatut.bar;
			var tf:TextField = _gInterface.profilBar.graphic.energyTF;
			tf.text= String(parseInt(tf.text)-1);
			TweenLite.to(energyBar,0.8,{x:Math.max(-energyBar.width,energyBar.x-1)});
			_baby.anim("STAND_RIGHT_DOWN");
			_kawaiiProgressBar.visible = false;
			_kawaiiCraftBar.visible = false;
			if(_currentCraft == _kawaiiTreeRollOver){
				_game.createLootDrop(["StarIcon"]);
			}else if(_currentCraft == _kawaiiRockRollOver){
				_game.createLootDrop(["StarIcon"]);
			}else if(_currentCraft == _kawaiiWellRollOver){
				_game.createLootDrop(["StarIcon"]);
			}else if(_currentCraft == _kawaiiBuildRollOver){
				_game.createLootDrop(["StarIcon"]);
			}
			_currentCraft = null;
			_mouseManager.mouseTargets = null;
		}
		//------ Set Player ------------------------------------
		public function set player($playerComponent:PlayerComponent):void {
			_baby = $playerComponent;
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}