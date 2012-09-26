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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import framework.component.Component;
	import framework.component.core.GraphicComponent;
	import framework.entity.EntityManager;
	import framework.entity.IEntityManager;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import script.game.kawaiiIsland.data.*;
	import script.game.kawaiiIsland.event.UInterfaceEvent;
	
	import utils.fx.Fx;
	import utils.mouse.MousePad;
	import utils.movieclip.Clip;
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;
	import utils.ui.Tooltip;

	/**
	 * Customization Controller
	 */
	public class CController {
		
		private var _mouseManager:IMouseManager = null;
		private var _entityManager:IEntityManager=null;
		private var _cInterface:CInterface = null;
		private var _color:Dictionary;
		private var _currentScreen:String = null
		private var _data:Data = null;	
		private var _personalityTarget:GraphicComponent = null;
		private var _hairTarget:GraphicComponent = null;
		private var _nappyTarget:GraphicComponent = null;
		private var _glovesTarget:GraphicComponent = null;
		private var _shoesTarget:GraphicComponent = null;
		private var _currentCusto:GraphicComponent = null;
		private var _currentCustoOver:MovieClip = null;
		public var currentCustoType:MovieClip = null;
		
		public function CController($cInterface:CInterface){
			initVar($cInterface);
		}
		//------ Init Var ------------------------------------
		public function initVar($cInterface:CInterface):void {
			_cInterface = $cInterface;
			_entityManager=EntityManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_data = Data.getInstance();
			_color = new Dictionary;
			_currentScreen = "gender";
		}
		//------ Init Var ------------------------------------
		public function initInterfaceVar():void {
			_personalityTarget = _entityManager.getComponent("KawaiiIsland","tycoonBt") as GraphicComponent;
			_hairTarget = _entityManager.getComponent("KawaiiIsland","hairBt1") as GraphicComponent;
			_nappyTarget = _entityManager.getComponent("KawaiiIsland","nappyBt1") as GraphicComponent;
			_glovesTarget = _entityManager.getComponent("KawaiiIsland","glovesBt1") as GraphicComponent;
			_shoesTarget = _entityManager.getComponent("KawaiiIsland","shoesBt1") as GraphicComponent;
		}
		//------ Set Controller ------------------------------------
		private function setController():void {
			currentCusto = _cInterface.kawaiiSkinCusto;
			currentCustoType = _cInterface.kawaiiAppearance.graphic.skinBt;
			_currentCustoOver = null;
			Fx.ButtonOver(_cInterface.kawaiiAppearance.graphic.skinBt);
			_cInterface.kawaiiAppearance.graphic.skinBt.filters = StyleManager.BlackStroke;
		}
		//Navigation Button
		public function onNextBtClick($mousePad:MousePad):void {
			if(_currentScreen =="gender"){
				_cInterface.kawaiiGender.hide();
				_cInterface.kawaiiPersonality.show();
				_currentScreen = "personality";
			}else if(_currentScreen =="personality"){
				_cInterface.kawaiiPersonality.hide();
				if(_data.player.gender == Constante.MALE){	
					_cInterface.kawaiiAppearance.graphic.bebeClip.head.gotoAndStop(1);
				}else{
					_cInterface.kawaiiAppearance.graphic.bebeClip.head.gotoAndStop(2);
				}
				_cInterface.kawaiiAppearance.show();
				_cInterface.kawaiiSkinCusto.show();
				_currentScreen = "appearance";
				setController();
			}
			checkPrevNextVisibility();
		}
		public function onPrevBtClick($mousePad:MousePad):void {
			if(_currentScreen =="personality"){
				_cInterface.kawaiiPersonality.hide();
				_cInterface.kawaiiGender.show();
				_currentScreen = "gender";
			}else if(_currentScreen =="appearance"){
				Fx.ButtonOut(currentCustoType);
				currentCustoType.filters = [];
				_cInterface.kawaiiAppearance.hide();
				_currentCusto.hide();
				_cInterface.kawaiiColorCusto.hide();
				_cInterface.kawaiiPersonality.show();
				_currentScreen = "personality";
			}
			checkPrevNextVisibility();
		}
		public function checkPrevNextVisibility():void {
			if(_currentScreen=="gender"){
				_cInterface.prevBt.visible=false;
			}else{
				_cInterface.prevBt.visible=true;
			}
			if(_currentScreen=="appearance"){
				_cInterface.nextBt.visible=false;
				_cInterface.finishBt.visible=true;
			}else{
				_cInterface.nextBt.visible=true;
				_cInterface.finishBt.visible=false;
			}
		}
		public function onFinishBtClick($mousePad:MousePad):void {
			if(!_cInterface.kawaiiWarningPopup){
				_cInterface.kawaiiWarningPopup=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiWarning1") as GraphicComponent;
				_cInterface.kawaiiWarningPopup.graphic = new KawaiiInterfaceWarning;
				LayoutUtil.Aligns([_cInterface.kawaiiWarningPopup],LayoutUtil.ALIGN_CENTER_CENTER,null,null, new Point(0,-50));
				var target:* = _cInterface.kawaiiWarningPopup.graphic;
				Fx.ShowModal(target);
				_cInterface.kawaiiWarningPopup.setButton(target.yesBt, {onMouseClick:onWarning1YesClick});
				_cInterface.kawaiiWarningPopup.setButton(target.noBt, {onMouseClick:onWarning1NoClick});
				_cInterface.kawaiiWarningPopup.setAsMouseTarget();
			}
		}
		public function onWarning1YesClick($mousePad:MousePad):void {
			_cInterface.kawaiiWarningPopup.clearMouseTargets();
			Fx.HideModal();
			Component.DestroyComponents([_cInterface.kawaiiWarningPopup,_cInterface.kawaiiGender,_cInterface.kawaiiPersonality,_cInterface.kawaiiDialogue,_cInterface.kawaiiBg, _cInterface.prevBt,_cInterface.nextBt,_cInterface.finishBt]);
			_cInterface.kawaiiAppearance.hide();
			_cInterface.kawaiiSkinCusto.hide();
			_cInterface.kawaiiHairCusto.hide();
			_cInterface.kawaiiNappyCusto.hide();
			_cInterface.kawaiiGlovesCusto.hide();
			_cInterface.kawaiiShoesCusto.hide();
			_cInterface.kawaiiColorCusto.hide();
			_cInterface.dispatchEvent(new UInterfaceEvent(UInterfaceEvent.UINTERFACE_CUSTO_COMPLETE));
		
		}
		public function onWarning1NoClick($mousePad:MousePad):void {
			_cInterface.kawaiiWarningPopup.clearMouseTargets();
			Fx.HideModal();
			_cInterface.kawaiiWarningPopup.destroy();
			_cInterface.kawaiiWarningPopup = null;
		}	
		//------ On Bt MouseEvent ------------------------------------
		public function onBtRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			Fx.ButtonOver(target.graphic);
		}
		public function onBtRollOut($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			Fx.ButtonOut(target.graphic);
		}
		public function onBtClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			var clickedTarget:GraphicComponent = getClickedTarget();
			if(clickedTarget!=target){
				//Fx.ButtonOut(target.graphic);
				Fx.ButtonClicked(target.graphic);
				if(clickedTarget){	
					Fx.ButtonReleased(clickedTarget.graphic);
				}
				setClickedTarget(target);
			}
		}
		public function getClickedTarget():GraphicComponent {
			var clickedTarget:GraphicComponent;
			if(_cInterface.kawaiiPersonality.visible){
				clickedTarget = _personalityTarget
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Hair") != -1){
				clickedTarget = _hairTarget;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Nappy") != -1){
				clickedTarget = _nappyTarget;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Gloves") != -1){
				clickedTarget = _glovesTarget;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Shoes") != -1){
				clickedTarget = _shoesTarget;
			}
			return clickedTarget;
		}
		public function setClickedTarget($clickedTarget:GraphicComponent):void {
			var type:Number = Number($clickedTarget.componentName.charAt($clickedTarget.componentName.length-1));
			if(_cInterface.kawaiiPersonality.visible){
				_personalityTarget = $clickedTarget;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Hair") != -1){
				_hairTarget = $clickedTarget;
				Clip.ChangeClipFrame(_cInterface.kawaiiAppearance.graphic.bebeClip,["head","hair"],type);
				_data.player.hairType = type;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Nappy") != -1){
				_nappyTarget = $clickedTarget;
				Clip.ChangeClipFrame(_cInterface.kawaiiAppearance.graphic.bebeClip,["nappy"],type);
				_data.player.nappyType = type;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Gloves") != -1){
				_glovesTarget = $clickedTarget;
				Clip.ChangeClipFrame(_cInterface.kawaiiAppearance.graphic.bebeClip,["gloves"],type);
				_data.player.glovesType = type;
			}else if(_cInterface.kawaiiAppearance.visible && _currentCusto.componentName.lastIndexOf("Shoes") != -1){
				_shoesTarget = $clickedTarget;
				Clip.ChangeClipFrame(_cInterface.kawaiiAppearance.graphic.bebeClip,["shoes"],type);
				_data.player.shoesType = type;
			}
		}
		//------ Gender  ------------------------------------
		public function onKawaiiMaleClipClick($mousePad:MousePad):void {
			var target:* = _cInterface.kawaiiGender.graphic;
			if(target.maleClip.alpha!=1){
				//Fx.ButtonOut(target.maleClip);
				target.maleClip.scaleX = target.maleClip.scaleY = target.maleClip.scaleX+0.2;
				target.maleClip.alpha = 1;
				target.femaleClip.scaleX = target.femaleClip.scaleY = target.maleClip.scaleX-0.2;
				target.femaleClip.alpha = 0.4;
				_data.player.gender = Constante.MALE;
			}
		}
		public function onKawaiiFemaleClipClick($mousePad:MousePad):void {
			var target:* = _cInterface.kawaiiGender.graphic;
			if(target.maleClip.alpha==1){
				//Fx.ButtonOut(target.femaleClip);
				target.maleClip.scaleX = target.maleClip.scaleY = target.maleClip.scaleX-0.2;
				target.maleClip.alpha = 0.4;
				target.femaleClip.scaleX = target.femaleClip.scaleY = target.maleClip.scaleX+0.2;
				target.femaleClip.alpha = 1;
				_data.player.gender = Constante.FEMALE;
			}
		}
		public function onKawaiiGenderRollOver($mousePad:MousePad):void {
			var target:* = _cInterface.kawaiiGender.graphic;
			var rolloverTarget:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(rolloverTarget.graphic == target.maleClip && target.maleClip.alpha!=1){
				Fx.ButtonOver(target.maleClip);
			}else if(rolloverTarget.graphic == target.femaleClip && target.femaleClip.alpha!=1){
				Fx.ButtonOver(target.femaleClip);
			}
		}
		public function onKawaiiGenderRollOut($mousePad:MousePad):void {
			var target:* = _cInterface.kawaiiGender.graphic;
			var rolloverTarget:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(rolloverTarget.graphic == target.maleClip && target.maleClip.alpha!=1){
				Fx.ButtonOut(target.maleClip);
			}else if(rolloverTarget.graphic == target.femaleClip && target.femaleClip.alpha!=1){
				Fx.ButtonOut(target.femaleClip);
			}
		}
		//------ Appearance ------------------------------------
		public function onAppearanceBtRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			var textField:TextField = new TextField();
			textField.text = target.componentName;
			textField.setTextFormat(StyleManager.ToolTip);
			textField.autoSize = "center";
			Tooltip.CreateTooltip(textField,0xBCF32C,1,StyleManager.GreenStroke,target.graphic);
			if(currentCustoType!=target.graphic && _currentCustoOver!=target.graphic ){
				_currentCustoOver=target.graphic
				Fx.ButtonOver(target.graphic);
			}
		}
		public function onAppearanceBtRollOut($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			Tooltip.RemoveTooltip();
			if(currentCustoType!=target.graphic && _currentCustoOver!=null){
				_currentCustoOver=null;
				Fx.ButtonOut(target.graphic);
			}
		}
		public function onKawaiiCustoColorClick($mousePad:MousePad):void {
			var pixelColor:uint = MouseManager.MousePixelColor;
			if(_currentCusto.componentName.lastIndexOf("Skin") != -1){
				var target:String = "peau";
				_data.player.skinColor = pixelColor;
			}else if(_currentCusto.componentName.lastIndexOf("Hair") != -1){
				target = "cheveux";
				_data.player.hairColor = pixelColor;
			}else if(_currentCusto.componentName.lastIndexOf("Nappy") != -1){
				target = "couche";
				_data.player.nappyColor = pixelColor;
			}else if(_currentCusto.componentName.lastIndexOf("Gloves") != -1){
				target = "gant";
				_data.player.glovesColor = pixelColor;
			}else if(_currentCusto.componentName.lastIndexOf("Shoes") != -1){
				target = "pied";
				_data.player.shoesColor = pixelColor;
			}
			if(pixelColor!=0xFFFFFF){
				var colors:Array = [{color:pixelColor,target:target}]
				Clip.ChangeClipColor(_cInterface.kawaiiAppearance.graphic.bebeClip,colors);
				_color[target] =  pixelColor;
			}
		}
		public function onAppearanceBtClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			if(currentCustoType == target.graphic)	return;
			_currentCusto.hide();
			currentCustoType.filters = [];
			Fx.ButtonOut(currentCustoType);
			if(target.componentName.lastIndexOf("skin")!=-1 && _currentCusto!=_cInterface.kawaiiSkinCusto){
				currentCustoType = _cInterface.kawaiiAppearance.graphic.skinBt;
				_cInterface.kawaiiSkinCusto.show();
				_currentCusto = _cInterface.kawaiiSkinCusto;
			}else if(target.componentName.lastIndexOf("hair")!=-1 && _currentCusto!=_cInterface.kawaiiHairCusto){
				currentCustoType = _cInterface.kawaiiAppearance.graphic.hairBt;
				_cInterface.kawaiiHairCusto.show();
				_currentCusto = _cInterface.kawaiiHairCusto;
			}else if(target.componentName.lastIndexOf("nappy")!=-1 && _currentCusto!=_cInterface.kawaiiNappyCusto){
				currentCustoType = _cInterface.kawaiiAppearance.graphic.nappyBt;
				_cInterface.kawaiiNappyCusto.show();
				_currentCusto = _cInterface.kawaiiNappyCusto;
			}else if(target.componentName.lastIndexOf("gloves")!=-1 && _currentCusto!=_cInterface.kawaiiGlovesCusto){
				currentCustoType = _cInterface.kawaiiAppearance.graphic.glovesBt;
				_cInterface.kawaiiGlovesCusto.show();
				_currentCusto = _cInterface.kawaiiGlovesCusto;
			}else if(target.componentName.lastIndexOf("shoes")!=-1 && _currentCusto!=_cInterface.kawaiiShoesCusto){
				currentCustoType = _cInterface.kawaiiAppearance.graphic.shoesBt;
				_cInterface.kawaiiShoesCusto.show();
				_currentCusto = _cInterface.kawaiiShoesCusto;
			}
			currentCustoType.filters = StyleManager.BlackStroke;
			if(_currentCusto==_cInterface.kawaiiSkinCusto){
				_cInterface.kawaiiColorCusto.hide();
			}else if(!_cInterface.kawaiiColorCusto.visible){
				_cInterface.kawaiiColorCusto.show();
			}
		}
		//------- Set Current Custo -------------------------------
		public function set currentCusto($currentCusto:GraphicComponent):void {
			_currentCusto=$currentCusto;
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}