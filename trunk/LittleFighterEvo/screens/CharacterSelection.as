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
package screens{
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import framework.Framework;
	import framework.component.core.ChronoComponent;
	import framework.component.core.GraphicComponent;
	import framework.component.core.ImageSliderComponent;
	import framework.component.core.KeyboardInputComponent;
	import framework.component.core.TimerComponent;
	import framework.entity.EntityManager;
	import framework.entity.IEntityManager;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	
	import utils.collection.List;
	import utils.keyboard.KeyCode;
	import utils.richardlord.*;
	import utils.ui.LayoutUtil;

	/**
	 * Character Selection
	 */
	public class CharacterSelection extends State implements IState{
		private const INIT:int 					= 0;
		private const PLAYER_SELECTION:int 		= 1;
		private const TEAM_SELECTION:int 		= 2;
		private const WAITING_NEW_PLAYER:int 	= 3;
		private const NB_COMPUTER_SELECTION:int = 4;
		private const COMPUTER_SELECTION:int 	= 5;
		private const FIGHT_MENU:int 			= 6;
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent = null;
		private var _graphicManager:IGraphicManager = null;
		private var _computerComponent:GraphicComponent = null;
		private var _sliderList:Array = null;
		private var _position:int = 0;
		private var _nestImageObject:Array=null;
		private var _team:List = null;
		private var _step:int = 0;
		private var _chronoList:Array = null;
		
		public function CharacterSelection(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_sliderList = new Array();
			_nestImageObject = new Array();
			_team = new List("independent","team1","team2","team3","team4");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyInput:KeyboardInputComponent=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
		}
		//------ Init Slider ------------------------------------
		private function _initSliders():void {
			var playerTF:TextField = _menuComponent.graphic["player"+i+"Txt"];
			for(var i:int=0;i<8;i++){
				playerTF = _menuComponent.graphic["player"+(i+1)+"Txt"]
				playerTF.autoSize = TextFieldAutoSize.CENTER;
				playerTF.text = "join";
				_initSlider(i,155+(i%4)*153,174+211*Math.floor(i/4));
			}
		}
		//------ Init Slider ------------------------------------
		private function _initSlider($id:int, $x:Number, $y:Number):void {
			var imageSliderComponent:ImageSliderComponent=_entityManager.addComponentFromName("LittleFighterEvo","ImageSliderComponent","mySliderComponent_"+$id) as ImageSliderComponent;
			var list:Array = new Array();
			var graphic:Bitmap;
			graphic = _graphicManager.getGraphic(Framework.root+Data.OTHERS.pressAttackToJoin);
			list.push(graphic);
			graphic = _graphicManager.getGraphic(Framework.root+Data.OTHERS.random);
			list.push(graphic);
			var i:int=0;
			for each(var object:Object in Data.OBJECT){
				if(object.hasOwnProperty("face")){
					graphic = _graphicManager.getGraphic(Framework.root+object.face);
					list.push(graphic);
					if(!_nestImageObject[i]){
						_nestImageObject[i] = object;
						i++;
					}
				}
			}
			imageSliderComponent.init(list);
			imageSliderComponent.moveTo($x,$y);
			_sliderList.push(imageSliderComponent);
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop("MENU");
			}else if($evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A){
				var index:int = $evt.keyCode == KeyConfig.Player1.A?0:1;
				var imageSliderComponent:ImageSliderComponent=_sliderList[index];
				if(_step==INIT){
					if(imageSliderComponent.position==0){
						imageSliderComponent.next([0]);
						selectCharacter(index);
						_step=PLAYER_SELECTION;
					}
				}else if(_step==PLAYER_SELECTION){
					if(imageSliderComponent.position==1){
						imageSliderComponent.random([0,1]);
						selectCharacter(index);
						selectTeam();
					}else if(imageSliderComponent.position>1){
						selectCharacter(index);
						selectTeam();
					}
					_step=TEAM_SELECTION;
				}else if(_step==TEAM_SELECTION){
					startCounter();
					_step=WAITING_NEW_PLAYER;
				}else if(_step==NB_COMPUTER_SELECTION){
					_computerComponent.visible = false;
					_step=COMPUTER_SELECTION;
				}else if(_step==COMPUTER_SELECTION){
					_step=FIGHT_MENU;
				}
			}else if($evt.keyCode == KeyCode.O){
				if(_step==WAITING_NEW_PLAYER){
					_step=TEAM_SELECTION;
				}
			}else if($evt.keyCode == KeyCode.LEFT){
				imageSliderComponent=_sliderList[_position];
				if(_step==PLAYER_SELECTION){
					if(imageSliderComponent.position>0){
						imageSliderComponent.prev([0]);
						selectCharacter(index);
					}
				}else if(_step==TEAM_SELECTION){
					_team.prev();
					selectTeam();
				}else if(_step==NB_COMPUTER_SELECTION){
					_computerComponent.prevFrame();
				}else if(_step==COMPUTER_SELECTION){
				}
			}else if($evt.keyCode == KeyCode.RIGHT){
				imageSliderComponent=_sliderList[index];
				if(_step==PLAYER_SELECTION){
					if(imageSliderComponent.position>0){
						imageSliderComponent.next([0]);
						selectCharacter(index);
					}
				}else if(_step==TEAM_SELECTION){
					_team.next();
					selectTeam();
				}else if(_step==NB_COMPUTER_SELECTION){
					_computerComponent.nextFrame();
				}else if(_step==COMPUTER_SELECTION){
				}
			}
		}
		//------ Select Character ------------------------------------
		public function selectCharacter($position:Number):void {
			var index:int = _position+1;
			var playerTF:TextField = _menuComponent.graphic["player"+index+"Txt"];
			playerTF.text = index.toString();
			playerTF.autoSize = TextFieldAutoSize.CENTER;
			var fighterTF:TextField = _menuComponent.graphic["fighter"+index+"Txt"];
			if($position==-1){
				fighterTF.text = "Random";
			}else{
				fighterTF.text = _nestImageObject[$position].name;
			}
			fighterTF.autoSize = TextFieldAutoSize.CENTER;
		}
		//------ Select Team ------------------------------------
		public function selectTeam():void {
			var index:int = _position + 1;
			var teamTF:TextField = _menuComponent.graphic["team"+index+"Txt"];
			teamTF.text = _team.currentItem;
			teamTF.autoSize = TextFieldAutoSize.CENTER;
		}
		//------ Start Counter ------------------------------------
		public function startCounter():void {
			_position++;
			if(!_chronoList){
				_chronoList = new Array();
				var timerComponent:TimerComponent=_entityManager.addComponentFromName("LittleFighterEvo","TimerComponent","myTimerComponent") as TimerComponent;
				var chrono:ChronoComponent;
				for (var i:int=_position;i<_sliderList.length;i++){
					_sliderList[i].visible = false;
					chrono=_entityManager.addComponentFromName("LittleFighterEvo","ChronoComponent","myChronoComponent_"+i,{onChronoComplete:onChronoComplete}) as ChronoComponent;
					chrono.setFormat("Arial",40,0xFFFFFF);
					chrono.moveTo(167+150*(i%4),215 + 205 *Math.floor(i/4));
					_chronoList.push(chrono);
					chrono.start(9, 1000);
				}
			}else{
				for each(var c:ChronoComponent in _chronoList){
					c.reset(9);
					c.visible = true;
				}
			}
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete($chronoComponent:ChronoComponent):void {
			if(!_computerComponent){
				_computerComponent = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myComputers") as GraphicComponent;
				_computerComponent.graphic = new ComputersUI as MovieClip;
				LayoutUtil.Align(_computerComponent,LayoutUtil.ALIGN_CENTER_CENTER);
			}else{
				_computerComponent.visible = true;
			}
			_step=NB_COMPUTER_SELECTION;
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
				_initSliders();
			}
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
		}
	}
}