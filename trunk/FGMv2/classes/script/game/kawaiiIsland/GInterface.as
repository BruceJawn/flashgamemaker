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
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import script.game.kawaiiIsland.event.GInterfaceEvent;
	
	import utils.fx.Fx;
	import utils.mouse.MousePad;
	import utils.ui.LayoutUtil;

	/**
	 * Game Interface
	 */
	public class GInterface extends EventDispatcher{
		
		private var _entityManager:IEntityManager=null;
		private var _mouseManager:IMouseManager = null;
		private var _gController:GController = null;
		private var _game:Game = null;
			
		public var systemInfo:SystemInfoComponent = null;
		public var statusBar:GraphicComponent = null;
		public var profilBar:GraphicComponent = null;
		public var friendsBar:GraphicComponent = null;
		public var menuTab:GraphicComponent = null;
		public var settings:GraphicComponent = null;
		public var collection:GraphicComponent = null;
		public var build:GraphicComponent = null;
		public var market:GraphicComponent = null;
		public var inventory:GraphicComponent = null;
		public var map:GraphicComponent = null;
		public var friendsList:Array = null;
		
		public function GInterface(){
			initVar();
			initComponent();
			setController();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_gController = new GController(this);
		}
		//------ Set Controller ------------------------------------
		private function setController():void {
			_gController.currentBtMenu = friendsBar;
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			setTimeout(onInterfaceComplete,200);
			//Profil
			var statusBarGrahic:DisplayObject = new KawaiiStatusBar;
			profilBar=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiProfilBar") as GraphicComponent;
			profilBar.graphic = new KawaiiProfilBar;
			var offset:Number = (FlashGameMaker.width - profilBar.graphic.width - statusBarGrahic.width) /2
			LayoutUtil.Align(profilBar,LayoutUtil.ALIGN_TOP_LEFT,null,null,new Point(offset-10,5));
			//profilBar.registerPropertyReference("mouseInput",{onMouseRollOver:_gController.onProfilRollOver, onMouseRollOut:_gController.onProfilRollOut,onMouseClick:_gController.onProfilClick});
			profilBar.moveToFront();
			//Status
			statusBar=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiStatusBar") as GraphicComponent;
			statusBar.graphic = statusBarGrahic;
			statusBar.moveTo(profilBar.x+profilBar.graphic.width+30, profilBar.y+10);
			target = statusBar.graphic;
			//statusBar.setButton(target.feedStatut,{onMouseRollOver:_gController.onStatutRollOver, onMouseRollOut:_gController.onStatutRollOut,onMouseClick:_gController.onStatutClick});
			//statusBar.setButton(target.cleanStatut,{onMouseRollOver:_gController.onStatutRollOver, onMouseRollOut:_gController.onStatutRollOut,onMouseClick:_gController.onStatutClick});
			//statusBar.setButton(target.amuseStatut,{onMouseRollOver:_gController.onStatutRollOver, onMouseRollOut:_gController.onStatutRollOut,onMouseClick:_gController.onStatutClick});
			_gController.updateProfil();
			//Friends
			friendsBar=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiFriendsBar") as GraphicComponent;
			friendsBar.graphic = new KawaiiFriendsBar;
			LayoutUtil.Align(friendsBar,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(0.4,-16));
			friendsList = new Array();
			var friendsGraphicList:Array = new Array();
			var addFriendElement:GraphicComponent;
			for (var i:int = 0; i<5; i++){
				addFriendElement=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","addFriendElement_"+i) as GraphicComponent;
				addFriendElement.graphic = new KawaiiAddFriendElement;
				friendsBar.componentChildren.push(addFriendElement);
				LayoutUtil.Align(addFriendElement,LayoutUtil.ALIGN_CENTER_LEFT,friendsBar.graphic.bg,null,new Point(5,20));
				friendsList.push(addFriendElement);
				friendsGraphicList.push(addFriendElement.graphic);
			}
			var friendElement:GraphicComponent;
			for (i = 5; i<8; i++){
				friendElement=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","friendElement_"+i) as GraphicComponent;
				friendElement.graphic = new KawaiiFriendElement;
				friendsBar.componentChildren.push(friendElement);
				LayoutUtil.Align(friendElement,LayoutUtil.ALIGN_CENTER_LEFT,friendsBar.graphic.bg,null,new Point(5,20));
				friendsList.push(friendElement);
				friendsGraphicList.push(friendElement.graphic);
			}
			LayoutUtil.DistributeH(friendsGraphicList,friendsBar,15,new Point(0,-50));
			for (i = 0; i<5; i++){
				var target:* = friendsList[i].graphic;
				var button:GraphicComponent = friendsList[i].setButton(target.addBt,{onMouseClick:_gController.onAddFriendBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut} ,"addFriendBt_"+i);
				friendsBar.componentChildren.push(button);
			}
			//Inventory
			inventory=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiInventory") as GraphicComponent;
			inventory.graphic = new KawaiiInventory;
			LayoutUtil.Align(inventory,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(0.4,150));
			target = inventory.graphic;
			inventory.setButton(target.closeBt,{onMouseClick:_gController.onInventoryBtClick}, "closeBt2");
			inventory.visible = false;
			//Build
			build=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiBuild") as GraphicComponent;
			build.graphic = new KawaiiBuild;
			LayoutUtil.Align(build,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(0.4,150));
			target = build.graphic;
			build.setButton(target.closeBt,{onMouseClick:_gController.onBuildBtClick}, "closeBt3");
			build.visible = false;
			//MenuTab
			menuTab=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiMenuTab") as GraphicComponent;
			menuTab.graphic = new KawaiiMenuBar;
			LayoutUtil.Align(menuTab,LayoutUtil.ALIGN_BOTTOM_RIGHT,null,null,new Point(0,-5));
			target = menuTab.graphic;
			menuTab.setButton(target.collectionBt,{onMouseClick:_gController.onCollectionBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut}, "Collection");
			menuTab.setButton(target.marketBt,{onMouseClick:_gController.onMarketBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut}, "Market" );
			menuTab.setButton(target.mapBt,{onMouseClick:_gController.onMapBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut}, "Map" );
			menuTab.setButton(target.inventoryBt,{onMouseClick:_gController.onInventoryBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut}, "Inventory" );
			menuTab.setButton(target.buildBt,{onMouseClick:_gController.onBuildBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut}, "Build" );
			menuTab.setButton(target.settingsBt,{onMouseClick:_gController.onSettingsBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut} , "Settings");
			//Settings
			settings=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiSettings") as GraphicComponent;
			settings.graphic = new KawaiiSettingsOption;
			LayoutUtil.Align(settings,LayoutUtil.ALIGN_TOP_RIGHT,menuTab.graphic,null,new Point(0,-100));
			target = settings.graphic.clip;
			//settings.setButtonAtFrame(11,target.fullScreenBt,{onMouseClick:_gController.onfullScreenBtClick,onMouseRollOver:_gController.onBtRollOver,onMouseRollOut:_gController.onBtRollOut} );
			settings.visible = false;
			//Collection
			collection=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiCollection") as GraphicComponent;
			collection.graphic = new KawaiiCollection;
			LayoutUtil.Align(collection,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(0,0));
			target = collection.graphic;
			collection.setButton(target.closeBt,{onMouseClick:_gController.onCloseBtClick});
			Fx.ShowModal(collection.graphic/*,0xFFFFFF*/);
			collection.visible = false;
			//Market
			market=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiMarket") as GraphicComponent;
			market.graphic = new KawaiiMarket;
			LayoutUtil.Align(market,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(0,0));
			target = market.graphic;
			market.setButton(target.closeBt,{onMouseClick:_gController.onMarketBtClick}, "closeBt4");
			Fx.ShowModal(market.graphic/*,0xFFFFFF*/);
			market.visible = false;
			//Map
			map=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiMap") as GraphicComponent;
			map.graphic = new KawaiiMap;
			LayoutUtil.Align(map,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(0,0));
			target = map.graphic;
			map.setButton(target.closeBt,{onMouseClick:_gController.onMapBtClick}, "closeBt5");
			Fx.ShowModal(map.graphic,0xFFFFFF);
			map.visible = false;
			//SystemInfo
			systemInfo = _entityManager.getComponent("KawaiiIsland","mySystemInfoComponent") as SystemInfoComponent;
			LayoutUtil.Align(systemInfo,LayoutUtil.ALIGN_TOP_LEFT,friendsBar.graphic,LayoutUtil.ALIGN_BOTTOM_LEFT,new Point(10,-2));
		}
		//------- Layout -------------------------------
		public function layout():void {
			var offset:Number = (FlashGameMaker.width - profilBar.graphic.width - statusBar.graphic.width) /2;
			var position:Point = LayoutUtil.GetAlignPosition(profilBar,LayoutUtil.ALIGN_TOP_LEFT,null,null,new Point(offset-10,5));
			profilBar.moveTo(position.x,position.y);
			statusBar.moveTo(profilBar.x+profilBar.graphic.width+30, profilBar.y+10);
			if(FlashGameMaker.stage.displayState == StageDisplayState.FULL_SCREEN){
				offset = (FlashGameMaker.width - (settings.x+settings.graphic.width-friendsBar.x)) /2;
				position = LayoutUtil.GetAlignPosition(friendsBar,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(0,-16));
				friendsBar.moveTo(friendsBar.x+offset,position.y);
				position = LayoutUtil.GetAlignPosition(menuTab,LayoutUtil.ALIGN_BOTTOM_RIGHT,null,null,new Point(0,-5));
				menuTab.moveTo(menuTab.x+offset,position.y);
				position = LayoutUtil.GetAlignPosition(settings,LayoutUtil.ALIGN_TOP_RIGHT,menuTab.graphic,null,new Point(0,-100));
				settings.moveTo(settings.x+offset,position.y);
				for each (var friendElement:GraphicComponent in friendsList){
					position = LayoutUtil.GetAlignPosition(friendElement,LayoutUtil.ALIGN_CENTER_LEFT,friendsBar.graphic.bg,null,new Point(0,20));
					friendElement.moveTo(friendElement.x+offset,position.y);
				}
				position = LayoutUtil.GetAlignPosition(systemInfo,LayoutUtil.ALIGN_TOP_LEFT,friendsBar.graphic,LayoutUtil.ALIGN_BOTTOM_LEFT,new Point(10,-2));
				systemInfo.moveTo(systemInfo.x+offset,position.y);
			}else{
				position = LayoutUtil.GetAlignPosition(friendsBar,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(0,-16));
				friendsBar.moveTo(position.x,position.y);
				position = LayoutUtil.GetAlignPosition(menuTab,LayoutUtil.ALIGN_BOTTOM_RIGHT,null,null,new Point(0,-5));
				menuTab.moveTo(position.x,position.y);
				position = LayoutUtil.GetAlignPosition(settings,LayoutUtil.ALIGN_TOP_RIGHT,menuTab.graphic,null,new Point(0,-100));
				settings.moveTo(position.x,position.y);
				for each (friendElement in friendsList){
					position = LayoutUtil.GetAlignPosition(friendElement,LayoutUtil.ALIGN_CENTER_LEFT,friendsBar.graphic.bg,null,new Point(0,20));
					friendElement.moveTo(position.x,position.y);
				}
				position = LayoutUtil.GetAlignPosition(systemInfo,LayoutUtil.ALIGN_TOP_LEFT,friendsBar.graphic,LayoutUtil.ALIGN_BOTTOM_LEFT,new Point(10,-2));
				systemInfo.moveTo(position.x,position.y);
			}
		}
		//------- inInterfaceComplete -------------------------------
		public function onInterfaceComplete():void {
			dispatchEvent(new GInterfaceEvent(GInterfaceEvent.GINTERFACE_COMPLETE))
		}
		//------- Get Gcontroller -------------------------------
		public function get gController():GController {
			return _gController;
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