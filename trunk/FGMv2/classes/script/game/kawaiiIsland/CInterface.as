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
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import script.game.kawaiiIsland.event.UInterfaceEvent;
	
	import utils.fx.Fx;
	import utils.mouse.MousePad;
	import utils.ui.LayoutUtil;

	/**
	 * User Interface
	 */
	public class CInterface extends EventDispatcher{
		
		private var _entityManager:IEntityManager=null;
		private var _mouseManager:IMouseManager = null;
		private var _cController:CController = null
	
		public var kawaiiBg:GraphicComponent = null;
		public var kawaiiDialogue:GraphicComponent= null;
		public var kawaiiGender:GraphicComponent= null;
		public var kawaiiAppearance:GraphicComponent= null;
		public var kawaiiSkinCusto:GraphicComponent= null;
		public var kawaiiNappyCusto:GraphicComponent= null;
		public var kawaiiHairCusto:GraphicComponent= null;
		public var kawaiiGlovesCusto:GraphicComponent= null;
		public var kawaiiShoesCusto:GraphicComponent= null;
		public var kawaiiColorCusto:GraphicComponent= null;
		public var kawaiiPersonality:GraphicComponent= null;
		public var kawaiiWarningPopup:GraphicComponent= null;
		public var nextBt:GraphicComponent = null;
		public var prevBt:GraphicComponent = null;
		public var finishBt:GraphicComponent = null;
		private var _url:String;
		private var _graphicManager:IGraphicManager = null;
		
		
		public function CInterface(){
			initVar();
			initComponent();
			_cController.initInterfaceVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_cController = new CController(this);
			_graphicManager = GraphicManager.getInstance();
			_url = FlashGameMaker.loaderInfo.url;
			_url = _url.substr(0, _url.lastIndexOf("/"));
			_url = _url.substr(0, _url.lastIndexOf("/"))+"/assets/";
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName("KawaiiIsland","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			//Interface
			kawaiiBg=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiBg") as GraphicComponent;
			kawaiiBg.graphic = new KawaiiInterfaceBg;
			kawaiiDialogue=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiDialogue") as GraphicComponent;
			kawaiiDialogue.graphic = new KawaiiInterfaceDialogue1;
			LayoutUtil.Align(kawaiiDialogue,LayoutUtil.ALIGN_CENTER_CENTER,kawaiiBg.graphic);
			//Gender 
			kawaiiGender=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiGender") as GraphicComponent;
			kawaiiGender.graphic = new KawaiiInterfaceGender;
			var target:* = kawaiiGender.graphic;
			target.maleClip.scaleX = target.maleClip.scaleY = target.maleClip.scaleX+0.2;
			target.maleClip.alpha = 1;
			LayoutUtil.Align(kawaiiGender,LayoutUtil.ALIGN_TOP_CENTER,kawaiiBg.graphic,null,new Point(0,95));
			kawaiiGender.setButton(target.maleClip, {onMouseClick:_cController.onKawaiiMaleClipClick/*,onMouseRollOver:_cController.onKawaiiGenderRollOver,onMouseRollOut:_cController.onKawaiiGenderRollOut*/});
			kawaiiGender.setButton(target.femaleClip, {onMouseClick:_cController.onKawaiiFemaleClipClick/*,onMouseRollOver:_cController.onKawaiiGenderRollOver,onMouseRollOut:_cController.onKawaiiGenderRollOut*/});
			//Personality 
			kawaiiPersonality=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiPersonality") as GraphicComponent;
			kawaiiPersonality.graphic = new KawaiiInterfacePersonality;
			LayoutUtil.Align(kawaiiPersonality,LayoutUtil.ALIGN_TOP_CENTER,kawaiiBg.graphic,null,new Point(0,95));
			target = kawaiiPersonality.graphic;
			kawaiiPersonality.setButtons([target.tycoonBt,target.socialiteBt,target.romanticBt,target.athleticBt,target.creativeBt,target.introvertBt,target.vilainBt,target.geekBt ], {onMouseClick:_cController.onBtClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			Fx.ButtonClicked(target.tycoonBt);
			kawaiiPersonality.hide();
			//Appearance
			kawaiiAppearance=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiAppearance") as GraphicComponent;
			kawaiiAppearance.graphic = new KawaiiInterfaceAppearance;
			target = kawaiiAppearance.graphic;
			LayoutUtil.Align(kawaiiAppearance,LayoutUtil.ALIGN_TOP_CENTER,kawaiiBg.graphic,null,new Point(0,95));
			kawaiiAppearance.setButtons([target.skinBt,target.nappyBt,target.glovesBt,target.shoesBt,target.hairBt], {onMouseClick:_cController.onAppearanceBtClick,onMouseRollOver:_cController.onAppearanceBtRollOver,onMouseRollOut:_cController.onAppearanceBtRollOut});
			kawaiiAppearance.hide();
			//Skin Custo
			kawaiiSkinCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiSkinCusto") as GraphicComponent;
			kawaiiSkinCusto.graphic = new KawaiiSkinCusto;
			target = kawaiiSkinCusto.graphic;
			LayoutUtil.Align(kawaiiSkinCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(100,30));
			var pixelColor:Array = new Array();
			for (var i:int=0; i<target.numChildren;i++){
				var pixelCase:Object = target.getChildAt(i);
				if(pixelCase is MovieClip){
					pixelColor.push(pixelCase);
				}
			}
			kawaiiSkinCusto.setButtons(pixelColor,{onMouseClick:_cController.onKawaiiCustoColorClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			kawaiiSkinCusto.hide();
			//Hair Custo
			kawaiiHairCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiHairCusto") as GraphicComponent;
			kawaiiHairCusto.graphic = new KawaiiHairCusto;
			LayoutUtil.Align(kawaiiHairCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(80,30));
			target = kawaiiHairCusto.graphic;
			kawaiiHairCusto.setButtons([target.hairBt1,target.hairBt2,target.hairBt3,target.hairBt4,target.hairBt5,target.hairBt6,target.hairBt7,target.hairBt8], {onMouseClick:_cController.onBtClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			Fx.ButtonClicked(target.hairBt1);
			kawaiiHairCusto.hide();
			//Nappy Custo
			kawaiiNappyCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiNappyCusto") as GraphicComponent;
			kawaiiNappyCusto.graphic = new KawaiiNappyCusto;
			LayoutUtil.Align(kawaiiNappyCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(80,30));
			target = kawaiiNappyCusto.graphic;
			kawaiiNappyCusto.setButtons([target.nappyBt1,target.nappyBt2,target.nappyBt3,target.nappyBt4,target.nappyBt5,target.nappyBt6,target.nappyBt7,target.nappyBt8], {onMouseClick:_cController.onBtClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			Fx.ButtonClicked(target.nappyBt1);
			kawaiiNappyCusto.hide();
			//Gloves Custo
			kawaiiGlovesCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiGlovesCusto") as GraphicComponent;
			kawaiiGlovesCusto.graphic = new KawaiiGlovesCusto;
			LayoutUtil.Align(kawaiiGlovesCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(80,30));
			target = kawaiiGlovesCusto.graphic;
			kawaiiGlovesCusto.setButtons([target.glovesBt1,target.glovesBt2,target.glovesBt3,target.glovesBt4,target.glovesBt5,target.glovesBt6,target.glovesBt7,target.glovesBt8], {onMouseClick:_cController.onBtClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			Fx.ButtonClicked(target.glovesBt1);
			kawaiiGlovesCusto.hide();
			//Shoes Custo
			kawaiiShoesCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiShoesCusto") as GraphicComponent;
			kawaiiShoesCusto.graphic = new KawaiiShoesCusto;
			LayoutUtil.Align(kawaiiShoesCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(80,30));
			target = kawaiiShoesCusto.graphic;
			kawaiiShoesCusto.setButtons([target.shoesBt1,target.shoesBt2,target.shoesBt3,target.shoesBt4,target.shoesBt5,target.shoesBt6,target.shoesBt7,target.shoesBt8], {onMouseClick:_cController.onBtClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			Fx.ButtonClicked(target.shoesBt1);
			kawaiiShoesCusto.hide();
			//Color Custo
			kawaiiColorCusto=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiColorCusto") as GraphicComponent;
			kawaiiColorCusto.graphic = new KawaiiColorCusto;
			LayoutUtil.Align(kawaiiColorCusto,LayoutUtil.ALIGN_TOP_LEFT,kawaiiAppearance.graphic,null,new Point(377,68));
			target = kawaiiColorCusto.graphic;
			pixelColor = new Array();
			for (i=0; i<target.numChildren;i++){
				pixelCase = target.getChildAt(i);
				if(pixelCase is MovieClip){
					pixelColor.push(pixelCase);
				}
			}
			kawaiiColorCusto.setButtons(pixelColor,{onMouseClick:_cController.onKawaiiCustoColorClick,onMouseRollOver:_cController.onBtRollOver,onMouseRollOut:_cController.onBtRollOut});
			kawaiiColorCusto.hide();
			//Navigation Button
			nextBt =  _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","nextBt") as GraphicComponent;
			nextBt.graphic = new KawaiiNextBt;
			nextBt.moveTo(555,330);
			nextBt.registerPropertyReference("mouseInput",{onMouseDown:_cController.onNextBtClick});
			prevBt =  _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","prevBt") as GraphicComponent;
			prevBt.graphic = new KawaiiPrevBt;
			prevBt.moveTo(195,330);
			prevBt.registerPropertyReference("mouseInput",{onMouseDown:_cController.onPrevBtClick});
			finishBt =  _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","finishBt") as GraphicComponent;
			finishBt.graphic = new KawaiiFinishBt;
			finishBt.moveTo(555,330);
			finishBt.registerPropertyReference("mouseInput",{onMouseDown:_cController.onFinishBtClick});
			_cController.checkPrevNextVisibility();
			//System Info
			var systemInfo:SystemInfoComponent = EntityFactory.CreateSystemInfo("KawaiiIsland",0,0);
			LayoutUtil.Align(systemInfo,LayoutUtil.ALIGN_TOP_RIGHT,null,null,new Point(10,10));
			//Cursor
//			var cursorComponent:CursorComponent=_entityManager.addComponentFromName("KawaiiIsland","CursorComponent","myCursorComponent") as CursorComponent;
//			cursorComponent.graphic = _graphicManager.getGraphic(_url+"cursor.swf");
//			cursorComponent.moveTo(0,0,2);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}