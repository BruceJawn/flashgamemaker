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
	import com.greensock.easing.Bounce;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.fx.Fx;
	import utils.mouse.MousePad;
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;
	import utils.ui.Tooltip;

	/**
	 * Game Controller
	 */
	public class GController{
		
		private var _entityManager:IEntityManager=null;
		private var _mouseManager:IMouseManager = null;
		private var _gInterface:GInterface = null;
		private var _game:Game = null;
		private var _statutClick:GraphicComponent = null;
		public var currentBtMenu:GraphicComponent = null;
		
		public function GController($gInterface:GInterface){
			initVar($gInterface);
		}
		//------ Init Var ------------------------------------
		private function initVar($gInterface:GInterface):void {
			_mouseManager = MouseManager.getInstance();
			_gInterface = $gInterface;
			FlashGameMaker.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onLoseFocus,false,0,true);
		}
		//------ On Profile RoollOver Event ------------------------------------
		public function  onProfilRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(target.graphic.currentFrame==1){
				var textField:TextField = new TextField();
				textField.text = "Click for more details";
				textField.setTextFormat(StyleManager.ToolTip);
				textField.autoSize = "center";
				var tooltip:MovieClip = Tooltip.CreateTooltip(textField,0xBCF32C,1,StyleManager.GreenStroke);
				 LayoutUtil.Align(tooltip,LayoutUtil.ALIGN_TOP_RIGHT, _gInterface.profilBar.graphic,LayoutUtil.ALIGN_BOTTOM_RIGHT, new Point(0,0));
				}
		}
		public function  onProfilRollOut($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
		}
		public function  onProfilClick($mousePad:MousePad):void {
			onStatutClick($mousePad);
		}
		//------ On Statut Mouse Event ------------------------------------
		public function  onStatutClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			if(_statutClick && _statutClick!=target){
				_statutClick.graphic.gotoAndStop(1);
			}else if(_statutClick && _statutClick==target){
				_statutClick.graphic.gotoAndStop(1);
				_statutClick = null;
				_gInterface.statusBar.clearMouseTargets();
				return;
			}
			Tooltip.RemoveTooltip();
			target.graphic.play();
			_statutClick = target;
			_gInterface.statusBar.setAsMouseTarget();
			_gInterface.profilBar.addToMouseTarget(_gInterface.profilBar);
		}
		public function  onStatutRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(target.graphic.currentFrame==1){
				var textField:TextField = new TextField();
				textField.text = "Click for more details";
				textField.setTextFormat(StyleManager.ToolTip);
				textField.autoSize = "center";
				var tooltip:MovieClip = Tooltip.CreateTooltip(textField,0xBCF32C,1,StyleManager.GreenStroke);
				LayoutUtil.Align(tooltip,LayoutUtil.ALIGN_TOP_RIGHT, target.graphic,LayoutUtil.ALIGN_BOTTOM_RIGHT, new Point(0,0));
			}
		}
		public function  onStatutRollOut($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
		}
		//------ On Bt MouseEvent ------------------------------------
		public function onBtRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			Fx.ButtonOver(target.graphic);
			var textField:TextField = new TextField();
			textField.text = target.componentName;
			textField.setTextFormat(StyleManager.ToolTip);
			textField.autoSize = "center";
			Tooltip.CreateTooltip(textField,0xBCF32C,1,StyleManager.GreenStroke,target.graphic);
		}
		public function onBtRollOut($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			Fx.ButtonOut(target.graphic);
			Tooltip.RemoveTooltip();
		}
		//------ On Build Bt Click ------------------------------------
		public function  onBuildBtClick($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
			var target:* = _gInterface.build.graphic;
			if(!_gInterface.build.visible){
				_gInterface.build.visible = true;
				tweenTo(currentBtMenu,0.5,{y:150, onComplete:onMenuTweenComplete, onCompleteParams:[currentBtMenu]});
				tweenTo(_gInterface.build,0.5,{y:-150, delay:0.1});
				currentBtMenu = _gInterface.build;
			}else{
				tweenTo(_gInterface.friendsBar,0.5,{y:0, delay:0.1});
				tweenTo(_gInterface.build,0.5,{y:0, onComplete:onMenuTweenComplete, onCompleteParams:[_gInterface.build]});
				currentBtMenu = _gInterface.friendsBar;
			}
		}
		//------ On Collection Bt Click ------------------------------------
		public function  onCollectionBtClick($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
			var target:* = _gInterface.collection.graphic;
			_gInterface.collection.visible = !_gInterface.collection.visible;
			if(_gInterface.collection.visible){
				_gInterface.collection.setAsMouseTarget();
			}else{
				_gInterface.collection.clearMouseTargets();
			}
		}
		//------ On Inventory Bt Click ------------------------------------
		public function  onInventoryBtClick($mousePad:MousePad=null):void {
			Tooltip.RemoveTooltip();
			var target:* = _gInterface.collection.graphic;
			if(!_gInterface.inventory.visible){
				_gInterface.inventory.visible = true;
				tweenTo(currentBtMenu,0.5,{y:150, onComplete:onMenuTweenComplete, onCompleteParams:[currentBtMenu]});
				tweenTo(_gInterface.inventory,0.5,{y:-150, delay:0.1});
				currentBtMenu = _gInterface.inventory;
			}else{
				tweenTo(_gInterface.friendsBar,0.5,{y:0, delay:0.1});
				tweenTo(_gInterface.inventory,0.5,{y:0, onComplete:onMenuTweenComplete, onCompleteParams:[_gInterface.inventory]});
				currentBtMenu = _gInterface.friendsBar;
			}
		}
		//------ On Market Bt Click ------------------------------------
		public function  onMarketBtClick($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
			var target:* = _gInterface.market.graphic;
			_gInterface.market.visible = !_gInterface.market.visible;
			if(_gInterface.market.visible){
				_gInterface.market.setAsMouseTarget();
				//tweenTo(_gInterface.market,0.5,{alpha:1, scaleX:1.2,scaleY:1.2,ease:Bounce});
				
			}else{
				_gInterface.market.clearMouseTargets();
			}
		}
		//------ On Map Bt Click ------------------------------------
		public function  onMapBtClick($mousePad:MousePad):void {
			Tooltip.RemoveTooltip();
			var target:* = _gInterface.map.graphic;
			_gInterface.map.visible = !_gInterface.map.visible;
			if(_gInterface.map.visible){
				_gInterface.map.setAsMouseTarget();
				
			}else{
				_gInterface.map.clearMouseTargets();
			}
		}
		//------ Tween To ------------------------------------
		public function  tweenTo($component:GraphicComponent, $duration:Number, $param:Object):void {
			TweenLite.to($component.graphic,$duration,$param);
			for each(var component:GraphicComponent in $component.componentChildren){
				TweenLite.to(component.graphic,$duration,$param);
			}
		}
		//------ Tween From ------------------------------------
		public function  tweenFrom($component:GraphicComponent, $duration:Number, $param:Object):void {
			TweenLite.from($component.graphic,$duration,$param);
			for each(var component:GraphicComponent in $component.componentChildren){
				TweenLite.from(component.graphic,$duration,$param);
			}
		}
		//------ On Inventory Tween Complete ------------------------------------
		public function  onMenuTweenComplete($target:GraphicComponent):void {
			if($target != _gInterface.friendsBar){
				$target.visible = false;
			}
		}
		//------ On Build Tween Complete ------------------------------------
		public function  onBuildTweenComplete():void {
			_gInterface.build.visible = false;
		}
		//------ On Settings Bt Click ------------------------------------
		public function  onSettingsBtClick($mousePad:MousePad):void {
			_gInterface.settings.visible = !_gInterface.settings.visible;
			_gInterface.settings.graphic.clip.gotoAndPlay(1);
		}
		//------ Update Profil------------------------------------
		public function updateProfil():void {
			var feedStatut:MovieClip = _gInterface.statusBar.graphic.feedStatut.progressBar.bar;
			var feedRatio:Number = Math.round(feedStatut.x+feedStatut.width)/feedStatut.width*100;
			var cleanStatut:MovieClip = _gInterface.statusBar.graphic.cleanStatut.progressBar.bar;
			var cleanRatio:Number = Math.round(cleanStatut.x+cleanStatut.width)/cleanStatut.width*100;
			var amuseStatut:MovieClip = _gInterface.statusBar.graphic.amuseStatut.progressBar.bar;
			var amuseRatio:Number = Math.round(amuseStatut.x+amuseStatut.width)/amuseStatut.width*100;
			var ratio:Number = Math.round(feedRatio+cleanRatio+amuseRatio)/3;
			var profilBar:MovieClip = _gInterface.profilBar.graphic.icon;
			if(ratio<20 && profilBar.currentLabel!="SAD"){
				profilBar.gotoAndStop("SAD");
			}else if(ratio>=20 &&ratio<40 && profilBar.currentLabel!="ANGRY"){
				profilBar.gotoAndStop("ANGRY");
			}else if(ratio>=40 && ratio<60 && profilBar.currentLabel!="UNHAPPY"){
				profilBar.gotoAndStop("UNHAPPY");
			}else if(ratio>=60 && ratio<80 && profilBar.currentLabel!="MOODY"){
				profilBar.gotoAndStop("MOODY");
			}else if (ratio>=80 && profilBar.currentLabel!="HAPPY"){
				profilBar.gotoAndStop("HAPPY");
			}
		}
		//------ On FullScreen Bt Click ------------------------------------
		public function  onfullScreenBtClick($mousePad:MousePad):void {
			if(FlashGameMaker.stage.displayState == StageDisplayState.FULL_SCREEN){
				FlashGameMaker.stage.displayState = StageDisplayState.NORMAL;
				_game.onNormalScreen();
			}else{
				FlashGameMaker.stage.displayState = StageDisplayState.FULL_SCREEN;
				_game.onFullScreen();
			}
		}
		//------ On Add Friend Bt Click ------------------------------------
		public function  onAddFriendBtClick($mousePad:MousePad):void {
			trace("Add Friends");
		}
		//------ On Close Bt Click ------------------------------------
		public function  onCloseBtClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			target.componentParent.visible = false;
			target.componentParent.clearMouseTargets();
		}
		//------ onLoseFocus ------------------------------------
		private function onLoseFocus($evt:FullScreenEvent):void {
			_gInterface.layout();
			_game.onNormalScreen();
		}
		//------ Set Game ------------------------------------
		public function setGame($game:Game):void {
			_game = $game
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}