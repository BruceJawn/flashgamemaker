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
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import framework.component.add.RPGTextComponent;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapTo;
	import utils.fx.Fx;
	import utils.iso.IsoPoint;
	import utils.mouse.MousePad;
	import utils.movieclip.Clip;
	import utils.text.StyleManager;
	import utils.tile.TileMap;
	import utils.transform.BasicTransform;
	import utils.ui.LayoutUtil;
	import utils.ui.Tooltip;

	/**
	 * Game
	 */
	public class Game{
		
		private var _entityManager:IEntityManager=null;
		private var _mouseManager:IMouseManager = null;
		private var _graphicManager:IGraphicManager = null;
		private var _tileMapComponent:TileMapComponent=null;
		private var _baby:PlayerComponent=null;
		private var _babyMenu:GraphicComponent = null;
		private var _feedBt:GraphicComponent=null;
		private var _cleanBt:GraphicComponent=null;
		private var _amuseBt:GraphicComponent=null;
		private var _url:String;
		private var _data:Data = null;	
		private var _gInterface:GInterface = null;
		private var _gController:GController = null;
		private var _aController:AController = null;
		private var _bitmapRenderComponent:BitmapRenderComponent = null;
		private var _isTweening:Boolean = false;
		private var _destination:Point = null;
		private var _fullscreen:Boolean = false;
		private var _tuto1:GraphicComponent = null;
		private var _house:AnimationComponent = null;
		private var _eraseClip:Sprite = null;
		
		public function Game($gInterface:GInterface){
			initVar($gInterface);
			initComponent();
			initAnimation();
			initTileMap();
			//initWeather();
			initDecor();
			initPlayer();
			initBabyMenu();
			//initIntro();
			//initTutorial();
		}
		//------ Init Var ------------------------------------
		private function initVar($gInterface:GInterface):void {
			_gInterface = $gInterface;
			_gController = _gInterface.gController;
			_gInterface.setGame(this);
			_gController.setGame(this);
			_entityManager=EntityManager.getInstance();
			_mouseManager = MouseManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			FlashGameMaker.stage.scaleMode="noScale";
			FlashGameMaker.stage.align = "TL";
			_url = FlashGameMaker.loaderInfo.url;
			_url = _url.substr(0, _url.lastIndexOf("/"));
			_url = _url.substr(0, _url.lastIndexOf("/"))+"/assets/";
			_data = Data.getInstance();
		}
		//------ Init Animation ------------------------------------
		private function initAnimation():void {
			_aController = new AController(this,_gInterface);
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			_bitmapRenderComponent=_entityManager.addComponentFromName("KawaiiIsland","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			BasicTransform.SetRectMask(_bitmapRenderComponent,0,0,FlashGameMaker.width,FlashGameMaker.height-120);
			//_bitmapRenderComponent.scrollEnabled = false;
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("KawaiiIsland","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var spatialMoveComponent:SpatialMoveComponent=_entityManager.addComponentFromName("KawaiiIsland","SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var mouseMoveComponent:MouseMoveComponent=_entityManager.addComponentFromName("KawaiiIsland","MouseMoveComponent","myMouseMoveComponent") as MouseMoveComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("KawaiiIsland","TimerComponent","myTimerComponent", {delay:1000}) as TimerComponent;
		}
		//------ Init TileMap ------------------------------------
		private function initTileMap():void {
			_tileMapComponent=_entityManager.addComponentFromName("KawaiiIsland","TileMapComponent","myTileMapComponent") as TileMapComponent;
			_tileMapComponent.initMap(1,40,15,TileMap.IsoRect);
			var tileSet:Bitmap = _graphicManager.getGraphic(_url+"kawaiiTileSet.png");
			var addTileSet:Bitmap = _graphicManager.getGraphic(_url+"kawaiiAddTileSet.png");
			var bitmapData:BitmapData = BitmapTo.BitmapToBitmapData(tileSet);
			_tileMapComponent.addTileLayer("1000*2",bitmapData,120,60,10,null,new IsoPoint(10,38,1),null);
			bitmapData = BitmapTo.BitmapToBitmapData(addTileSet);
			_tileMapComponent.addTileLayer("100*0,100*1,800*0",bitmapData,60,40,10,null,new IsoPoint(16,16,1),null);
			_tileMapComponent.moveTo(-60,-220);
			//_tileMapComponent.pauseScroll = true;
			_tileMapComponent.pauseBlit = true;
		}
		//------ Init Player ------------------------------------
		private function initPlayer():void {
			var source:MovieClip = _graphicManager.getGraphic(_url+"bebeClip.swf");
			customBaby(source);
		}//------ On Custom Baby Complete  ------------------------------------
		public function  onCustomBabyComplete($source:MovieClip):void {
			_baby=_entityManager.addComponentFromName("KawaiiIsland","PlayerComponent","mybaby") as PlayerComponent;
			_baby.autoScroll = false;
			if(_tileMapComponent)	_tileMapComponent.componentChildren.push(_baby);
			_baby.bitmapSet = _baby.createSwf($source,true,false);
			_baby.registerPropertyReference("bitmapRender");
			_baby.registerPropertyReference("bitmapAnim",{callback:_baby.onAnim});
			_baby.registerPropertyReference("mouseInput",{capture:true, onMouseClick:onBabyClick, onMouseUp:onBabyMouseUp,onMouseRollOver:onBabyRollOver, onMouseRollOut:onBabyRollOut});
			LayoutUtil.Align(_baby,LayoutUtil.ALIGN_CENTER_CENTER, null, null, new Point(-150,-100));
			_baby.moveTo(_baby.x,_baby.y,1);
			var graph:BitmapGraph = _baby.bitmapSet.graph;
			for each(var bitmapAnim:BitmapAnim in _baby.bitmapSet.graph.animations){
				bitmapAnim.nextPose = null;
			}
			//_baby.callback.onMouseStopMoving = onBabyStopMoving;
			_aController.player = _baby;
		}
		//------ On Baby Click  ------------------------------------
		public function  onBabyClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
			if(!_babyMenu) return;
			if(target == _baby && _babyMenu.visible==false){
				_baby.graphic.filters =[]
				Tooltip.RemoveTooltip();
				_babyMenu.show();
				_tileMapComponent.pauseScroll = true;
				var position:Point = LayoutUtil.GetAlignPosition(_babyMenu,LayoutUtil.ALIGN_BOTTOM_CENTER, _baby.graphic,LayoutUtil.ALIGN_TOP_CENTER, new Point(_baby.x-20,_baby.y-20),false,true,true);
				_babyMenu.moveTo(position.x,position.y);
			}else if(target == _baby && _babyMenu.visible==true && !_mouseManager.drag){
				_babyMenu.hide();
				_tileMapComponent.pauseScroll = false;
			}else if(target == _baby && _babyMenu.visible==true && _mouseManager.drag){
				var targetBt:GraphicComponent = _mouseManager.drag.parent.parent as GraphicComponent;
				var statut:MovieClip;
				if(targetBt==_feedBt){
					statut = _gInterface.statusBar.graphic.feedStatut.progressBar.bar;
					TweenLite.to(statut,1,{x:Math.min(0,statut.x+80)});
					_gInterface.statusBar.graphic.feedStatut.feedTF.text = String(Math.round((statut.width+statut.x)*100/statut.width));
					startDragTween();
					_babyMenu.hide();
					createLootDrop();
				}else if(targetBt==_cleanBt){
					statut = _gInterface.statusBar.graphic.cleanStatut.progressBar.bar;
					TweenLite.to(statut,1,{x:Math.min(0,statut.x+80)});
					_gInterface.statusBar.graphic.cleanStatut.cleanTF.text = String(Math.round((statut.width+statut.x)*100/statut.width));
					Fx.RemoveBubbles(_babyMenu.graphic);
					startDragTween();
					_babyMenu.hide();
					createLootDrop();
				}else if(targetBt==_amuseBt){
					statut = _gInterface.statusBar.graphic.amuseStatut.progressBar.bar;
					TweenLite.to(statut,1,{x:Math.min(0,statut.x+80)});
					_gInterface.statusBar.graphic.amuseStatut.amuseTF.text =String(Math.round((statut.width+statut.x)*100/statut.width));
					startDragTween();
					_babyMenu.hide();
					createLootDrop();
				}
				targetBt.disable();
			}else if(target != _baby && _babyMenu && _babyMenu.visible==true && _mouseManager.drag){
				checkDrag(_mouseManager.drag);
			}
		}
		//------ On Mouse Up  ------------------------------------
		public function  onBabyMouseUp($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(target==null && !_isTweening && !_mouseManager.drag && target!=_baby && (target!=_babyMenu || !_babyMenu) && (!_babyMenu || _babyMenu.componentChildren.indexOf(target)==-1)){
				if(_babyMenu && _babyMenu.visible){
					_babyMenu.hide();
				}	
				if(_mouseManager.clicked!=_baby && $mousePad.clickDuration<140  && FlashGameMaker.clip.mouseY<455){
					_destination = new Point($mousePad.mouseEvent.stageX-_baby.graphic.width/2-_baby.x,$mousePad.mouseEvent.stageY-_baby.graphic.height/2-_baby.y);
					_baby.onMouseUp($mousePad);
					//_tileMapComponent.pauseScroll = true;
				}
			}
		}
		//------ On Baby Stop Mouving  ------------------------------------
		public function  onBabyStopMoving():void {
			//_tileMapComponent.pauseScroll = false;
			//_tileMapComponent.scrollTo(_destination);
		}
		//------ On Baby RoollOver  ------------------------------------
		public function  onBabyRollOver($mousePad:MousePad):void {
			if(_babyMenu && _babyMenu.visible==false){
				_baby.graphic.filters = StyleManager.RedHalo;
				var textField:TextField = new TextField();
				textField.text = "Click to feed, clean or amuse";
				textField.setTextFormat(StyleManager.ToolTip);
				textField.autoSize = "center";
				var tooltip:MovieClip = Tooltip.CreateTooltip(textField,0xBCF32C,1,StyleManager.GreenStroke);
				LayoutUtil.Align(tooltip,LayoutUtil.ALIGN_BOTTOM_CENTER, _baby.graphic,LayoutUtil.ALIGN_TOP_CENTER, new Point(_baby.x,_baby.y));
			}else if(_babyMenu && _babyMenu.visible==true){
			}
		}
		//------ On Baby RoollOut  ------------------------------------
		public function  onBabyRollOut($mousePad:MousePad):void {
			_baby.graphic.filters =[]
			Tooltip.RemoveTooltip();
		}
		//------ Custom Baby ------------------------------------
		private function customBaby($source:MovieClip):void {
			Clip.ChangeClipsFrame($source,[{target:["Head","hair"],frame:_data.player.hairType},{target:["Bassin"],frame:_data.player.hairType},{target:["Gloves"],frame:_data.player.hairType},{target:["Shoes"],frame:_data.player.shoesType}], onClipChangeComplete );
		}
		//------ On Clip Change Complete ------------------------------------
		private function onClipChangeComplete($source:MovieClip):void {
			var colors:Array = new Array;
			colors.push({color:_data.player.skinColor,target:"skin"});
			colors.push({color:_data.player.hairColor,target:"cheveux"});
			colors.push({color:_data.player.nappyColor,target:"nappy"});
			colors.push({color:_data.player.glovesColor,target:"gloves"});
			colors.push({color:_data.player.shoesColor,target:"shoes"});
			Clip.ChangeClipColor($source,colors);
			onCustomBabyComplete($source);
		}
		//------ Init Baby Menu ------------------------------------
		private function initBabyMenu():void {
			_babyMenu=_entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiBabyMenu") as GraphicComponent;
			_babyMenu.graphic = new KawaiiBabyMenu;
			var target:MovieClip =  _babyMenu.graphic;
			_feedBt	 = _babyMenu.setButton(target.feedBt, {onMouseClick:onFeedBtClick,onMouseRollOver:onBtRollOver,onMouseRollOut:onBtRollOut});
			_cleanBt = _babyMenu.setButton(target.cleanBt, {onMouseClick:onCleanBtClick,onMouseRollOver:onBtRollOver,onMouseRollOut:onBtRollOut});
			_amuseBt = _babyMenu.setButton(target.amuseBt, {onMouseClick:onAmuseBtClick,onMouseRollOver:onBtRollOver,onMouseRollOut:onBtRollOut});
			_babyMenu.hide();
		}
		//------ On Feed Bt Click  ------------------------------------
		public function  onFeedBtClick($mousePad:MousePad):void {
			var target:MovieClip = _babyMenu.graphic.feedBt.icon;
			checkDrag(target);
		}
		//------ On Clean Bt Click  ------------------------------------
		public function  onCleanBtClick($mousePad:MousePad):void {
			var target:MovieClip = _babyMenu.graphic.cleanBt.icon;
			Fx.AddBubbles(_babyMenu.graphic, new Point(70,70));
			checkDrag(target);
		}
		//------ On Amuse Bt Click  ------------------------------------
		public function  onAmuseBtClick($mousePad:MousePad):void {
			var target:MovieClip = _babyMenu.graphic.amuseBt.icon;
			checkDrag(target);
		}
		//------ Check Drag  ------------------------------------
		public function  checkDrag($target:MovieClip):void {
			if(_isTweening) return;
			if(_mouseManager.drag && _mouseManager.drag!=$target){
				startDragTween();
				$target.startDrag(true);
				GraphicComponent($target.parent.parent).moveToFront();
				_mouseManager.drag = $target;
			}else if(_mouseManager.drag && _mouseManager.drag==$target){
				startDragTween();
			}else if(!_mouseManager.drag){
				$target.startDrag(true);
				var targetBt:GraphicComponent = $target.parent.parent as GraphicComponent;
				targetBt.moveToFront();
				_mouseManager.drag = $target;
			}
		}
		public function  startDragTween():void {
			_mouseManager.drag.stopDrag();
			_isTweening = true;
			Fx.RemoveBubbles(_babyMenu.graphic);
			TweenLite.to(_mouseManager.drag,1,{x:_mouseManager.dragInitialPosition.x,y:_mouseManager.dragInitialPosition.y, onComplete:onCompleteDrag, onCompleteParams:[_mouseManager.drag.parent]});
			_mouseManager.drag = null;
		}	
		//------ On Complete Drag  ------------------------------------
		public function  onCompleteDrag($target:MovieClip):void {
			_isTweening = false;
			Fx.ButtonOut($target);
			_gController.updateProfil();
		}
		//------ On Close Bt Click  ------------------------------------
		public function  onCloseBtClick($mousePad:MousePad):void {
			_babyMenu.hide();
		}
		//------ Init Intro ------------------------------------
		private function initIntro():void {
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponentFromName("KawaiiIsland","RPGTextComponent","myRPGTextComponent") as RPGTextComponent;
			rpgTextComponent.graphic = _graphicManager.getGraphic(_url+"rpgText.swf");
			var sequences:Array = [{title:"Title1", content:"Content1", icon:null, delay:5000},{title:"Title2", content:"Content2", icon:null, delay:5000}];
			rpgTextComponent.setSequences(sequences);
			var position:Point = LayoutUtil.GetAlignPosition(rpgTextComponent,LayoutUtil.ALIGN_TOP_RIGHT, null, null, new Point(-20,60));
			rpgTextComponent.moveTo(position.x,position.y);
		}
		//------ Init Decor ------------------------------------
		private function initDecor():void {
			//House
			_house=_entityManager.addComponentFromName("KawaiiIsland","AnimationComponent","myHouse") as AnimationComponent;
			_house.graphic = _graphicManager.getGraphic(_url+"kawaiiHouse.swf"); ;
			_house.moveTo(500,120,1);
			_house.autoScroll = false;
			_house.autoAnim = false;
			_house.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onBuildRollOver, onMouseRollOut:_aController.onBuildRollOut, onMouseClick:_aController.onBuildClick});
			_tileMapComponent.componentChildren.push(_house);
			//Tree
			var tree:AnimationComponent=_entityManager.addComponentFromName("KawaiiIsland","AnimationComponent","myTree") as AnimationComponent;
			tree.graphic =  _graphicManager.getGraphic(_url+"kawaiiTree.swf");;
			var position:Point = LayoutUtil.GetAlignPosition(tree,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(0,0));
			tree.moveTo(position.x,position.y,1);
			tree.autoScroll = false;
			tree.autoAnim = false;
			_tileMapComponent.componentChildren.push(tree);
			tree.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onTreeRollOver, onMouseRollOut:_aController.onTreeRollOut, onMouseClick:_aController.onTreeClick});
			var clone:AnimationComponent;
			for (var i:Number=0; i<15; i++){
				clone=tree.clone() as AnimationComponent;
				clone.moveTo(Math.random()*1000,Math.random()*750,1);
				clone.autoScroll = false;
				clone.autoAnim = false;
				clone.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onTreeRollOver, onMouseRollOut:_aController.onTreeRollOut, onMouseClick:_aController.onTreeClick});
				_tileMapComponent.componentChildren.push(clone);
			}
			//Rock
			var rock:AnimationComponent=_entityManager.addComponentFromName("KawaiiIsland","AnimationComponent","myRock") as AnimationComponent;
			rock.graphic = _graphicManager.getGraphic(_url+"kawaiiRock.swf");
			position = LayoutUtil.GetAlignPosition(rock,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(60,20));
			rock.moveTo(position.x,position.y,1);
			rock.autoScroll = false;
			rock.autoAnim = false;
			_tileMapComponent.componentChildren.push(rock);
			rock.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onRockRollOver, onMouseRollOut:_aController.onRockRollOut, onMouseClick:_aController.onRockClick});
			for (i=0; i<5; i++){
				clone=rock.clone() as AnimationComponent;
				clone.moveTo(Math.random()*1000,Math.random()*750,1);
				clone.autoScroll = false;
				clone.autoAnim = false;
				clone.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onRockRollOver, onMouseRollOut:_aController.onRockRollOut, onMouseClick:_aController.onRockClick});
				_tileMapComponent.componentChildren.push(clone);
			}
			//Well
			var well:AnimationComponent=_entityManager.addComponentFromName("KawaiiIsland","AnimationComponent","myWell") as AnimationComponent;
			well.graphic = _graphicManager.getGraphic(_url+"kawaiiWell.swf");
			position = LayoutUtil.GetAlignPosition(well,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(-60,-60));
			well.moveTo(position.x,position.y,1);
			well.autoScroll = false;
			well.autoAnim = false;
			well.registerPropertyReference("mouseInput",{onMouseRollOver:_aController.onWellRollOver, onMouseRollOut:_aController.onWellRollOut, onMouseClick:_aController.onWellClick});
			_tileMapComponent.componentChildren.push(well);
		}
		//------ Init Decor ------------------------------------
		private function initWeather():void {
//			var snowComponent:SnowComponent=_entityManager.addComponentFromName("KawaiiIsland","SnowComponent","mySnowComponent") as SnowComponent;
//			snowComponent.autoScroll = false;
			var dayAndNightComponent:DayAndNightComponent=_entityManager.addComponentFromName("KawaiiIsland","DayAndNightComponent","myDayAndNightComponent") as DayAndNightComponent;
			dayAndNightComponent.setTarget(_bitmapRenderComponent as DisplayObject);
//			Fx.Night(_bitmapRenderComponent as DisplayObject, 300);
		}
		//------ On Bt MouseEvent ------------------------------------
		public function onBtRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(!_mouseManager.drag)	Fx.ButtonOver(target.graphic);
		}
		public function onBtRollOut($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			if(!_mouseManager.drag && !_isTweening)	Fx.ButtonOut(target.graphic);
		}
		//------ On FullScreen  ------------------------------------
		public function  onFullScreen():void {
			BasicTransform.SetRectMask(_bitmapRenderComponent,0,0,FlashGameMaker.width,FlashGameMaker.height-120);
			_tileMapComponent.addVisibilityX(8);
			_tileMapComponent.addVisibilityY(12);
			_fullscreen =true;
		}
		//------ On NormalScreen  ------------------------------------
		public function  onNormalScreen():void {
			if(_fullscreen){
				BasicTransform.SetRectMask(_bitmapRenderComponent,0,0,FlashGameMaker.width,FlashGameMaker.height-120);
				//_tileMapComponent.removeVisibilityX(8);
				//_tileMapComponent.removeVisibilityY(12);
				_fullscreen = false;
			}
		}
		//------ createLootDrop  ------------------------------------
		public function  createLootDrop($loot:Array = null):void {
			var speed:Number =200;
			var num:int = 2 + int(Math.random()*3);
			var list:Array = ["StarIcon","StarIcon","KawaiiIcon","KawaiiIcon","KawaiiIcon","EnergyIcon"];
			if($loot){
				list = list.concat($loot);
				num+=$loot.length;
			}
			var graphicComponent:GraphicComponent;
			var x:int,y:int;
			var dx:int,dy:int;
			var duration:Number;
			var distance:Number;
			for (var i:int=0;i<num;i++){
				graphicComponent = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent") as GraphicComponent;
				var index:int = int(Math.random()*list.length);
				var classRef:Class=getDefinitionByName(String(list[index])) as Class;
				var graphic:MovieClip = new classRef;
				graphicComponent.graphic = graphic;
				graphic.filters =[new GlowFilter(0xFFFFFF,1,2,2,6,2,true)];
				graphicComponent.autoScroll = false;
				_tileMapComponent.componentChildren.push(graphicComponent);
				x = _baby.x + _baby.graphic.width/2 ;
				y = _baby.y + _baby.graphic.height/2;
				dx = x + int(Math.random()*50 -50) - 1 | 1; 
				dy = y-130+int(Math.random()*50);
				graphicComponent.moveTo(x,y,1);
				distance = Point.distance(new Point(x,y),new Point(dx,dy));
				duration= distance/speed;
				TweenLite.to(graphicComponent,duration,{x:dx,y:dy,ease:Expo.easeOut, onComplete:onLootUp,onCompleteParams:[graphicComponent]});
			}
		}
		//------ OnLootUp  ------------------------------------
		public function  onLootUp($graphicComponent:GraphicComponent):void {
			var x:Number = $graphicComponent.x -40 + int(Math.random()*80) - 1 | 1; 
			var y:Number = $graphicComponent.y + 120 + int(Math.random()*20);
			TweenLite.to($graphicComponent,0.6,{x:x,y:y,ease:Linear.easeIn, onComplete:onLootDown,onCompleteParams:[$graphicComponent]});
		}
		//------ OnLootUp  ------------------------------------
		public function  onLootDown($graphicComponent:GraphicComponent):void {
			$graphicComponent.registerPropertyReference("mouseInput",{onMouseRollOver:onLootRollOver});
			$graphicComponent.registerPropertyReference("timer",{delay:2000, callback:onLootRollOver, params:[null,$graphicComponent]});
		}
		//------ On Loot RollOver  ------------------------------------
		public function  onLootRollOver($mousePad:MousePad=null, $target:GraphicComponent=null):void {
			var speed:Number = 300;
			if($target){
				var target:GraphicComponent = $target;
			}else{
				target = _mouseManager.rollOver as GraphicComponent;
			}
			var num:Number = 5+int(Math.random()*6);
			var type:String = getQualifiedClassName(target.graphic);
			if(type=="EnergyIcon"){
				var destination:MovieClip = _gInterface.profilBar.graphic.energyIcon;
				Fx.DisappearingText(new Point(target.x,target.y),"+"+num+" energy",0xFBF94D,null,4);
			}else if(type=="StarIcon"){
				destination = _gInterface.profilBar.graphic.starIcon;
				Fx.DisappearingText(new Point(target.x,target.y),"+"+num+" xp",0x003399,null,4);
			}else if(type=="KawaiiIcon"){
				destination = _gInterface.profilBar.graphic.kawaiiIcon;
				Fx.DisappearingText(new Point(target.x,target.y),"+"+num+" kawaii",0xFBF94D,null,4);
			}
			var x:Number = destination.x + _gInterface.profilBar.x;
			var y:Number = destination.y + _gInterface.profilBar.y;
			var distance:Number = Point.distance(new Point(target.x,target.y),new Point(x,y));
			var duration:Number = distance/speed;
			TweenLite.to(target,duration,{x:x,y:y,onComplete:onLootComplete,onCompleteParams:[target,num]});
		}
		//------ On Loot Complete  ------------------------------------
		public function  onLootComplete($graphicComponent:GraphicComponent,$num:int):void {
			var type:String = getQualifiedClassName($graphicComponent.graphic);
			
			$graphicComponent.destroy();
			var target:MovieClip;
			var tf:TextField;
			if(type=="EnergyIcon"){
				target = _gInterface.profilBar.graphic.energyStatut.bar;
				tf = _gInterface.profilBar.graphic.energyTF;
				
			}else if(type=="StarIcon"){
				target = _gInterface.profilBar.graphic.xpStatut.bar;
				tf = _gInterface.profilBar.graphic.xpTF;
			}else if(type=="KawaiiIcon"){
				tf = _gInterface.profilBar.graphic.kawaiiTF;
			}
			tf.text= String(parseInt(tf.text)+$num);
			if(target)	TweenLite.to(target,0.8,{x:Math.min(0,target.x+$num)});
		}
		//------ Init Tutorial  ------------------------------------
		public function  initTutorial():void{
			_tuto1 = _entityManager.addComponentFromName("KawaiiIsland","GraphicComponent","kawaiiTuto1") as GraphicComponent;
			_tuto1.graphic = new KawaiiTuto1;
			var okayBt:GraphicComponent= _tuto1.setButton(_tuto1.graphic.okayBt, {onMouseClick:onTutoOkayBtClick,onMouseRollOver:onBtRollOver,onMouseRollOut:onBtRollOut});
			okayBt.setAsMouseTarget();
			var modal:Sprite = Fx.ShowModal(_tuto1.graphic);
			modal.blendMode = BlendMode.LAYER;
			_eraseClip = new Sprite;
			_eraseClip.graphics.beginFill(0xFFFFFF);
			_eraseClip.graphics.drawCircle(650,230,160);
			_eraseClip.graphics.endFill();
			_eraseClip.blendMode = BlendMode.ERASE;
			modal.addChild(_eraseClip);
			_tuto1.graphic.alpha=okayBt.graphic.alpha=0;
			TweenLite.to(_tuto1.graphic,0.4,{delay:3,alpha:1});
			TweenLite.to(okayBt.graphic,0.4,{delay:3,alpha:1});
		}
		//------ On Tuto OkayBt Click  ------------------------------------
		public function  onTutoOkayBtClick($mousePad:MousePad):void {
			if(_tuto1.graphic.currentFrame==1){
				_tuto1.graphic.nextFrame();
				_house.graphic.nextFrame();
				_eraseClip.visible = false;
			}else{
				_tuto1.destroy();
				Fx.HideModal();
				_tuto1.clearMouseTargets();
			}
		}
		//------ Get Baby  ------------------------------------
		public function  get baby():PlayerComponent {
			return _baby;
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace();
		}
	}
}