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
	
	import fl.controls.Slider;
	
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
	
	import utils.collection.ArrayPlus;
	import utils.collection.List;
	import utils.keyboard.KeyCode;
	import utils.mouse.MousePad;
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
		private var _nestImageObject:Array=null;
		private var _teamPlayer1:List = null;
		private var _teamPlayer2:List = null;
		private var _teamComputer:List = null;
		private var _stepPlayer1:int = 0;
		private var _stepPlayer2:int = 0;
		private var _stepComputer:int = 1;
		private var _computerSliderPosition:int=0;
		private var _chronoList:Array = null;
		private var _nbPlayer:int=0;
		private var _nbComputer:int=0;
		private var _fightMenu:GraphicComponent = null;
		private var _randomList:ArrayPlus = null;
		private var _difficulty:List = null;
		private var _background:List = null;
		
		public function CharacterSelection(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
			_sliderList = new Array();
			_nestImageObject = new Array();
			_randomList = new ArrayPlus();
			_teamPlayer1 = new List("independent","team1","team2","team3","team4");
			_teamPlayer2 = new List("independent","team1","team2","team3","team4");
			_teamComputer = new List("independent","team1","team2","team3","team4");
			_difficulty = new List("Easy","Normal","Difficult");
			_background = new List("Forest");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyInput:KeyboardInputComponent=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
		}
		//------ Init Slider ------------------------------------
		private function _initSliders():void {
			var playerTF:TextField = _menuComponent.graphic["player"+i+"TF"];
			var imageSliderComponent:ImageSliderComponent;
			for(var i:int=0;i<8;i++){
				playerTF = _menuComponent.graphic["player"+(i+1)+"TF"]
				playerTF.autoSize = TextFieldAutoSize.CENTER;
				playerTF.text = "join";
				imageSliderComponent = _sliderList[i]
				if(!imageSliderComponent){
					_initSlider(i,155+(i%4)*153,174+211*Math.floor(i/4));
				}else{
					imageSliderComponent.visible=true;
					imageSliderComponent.reset();
				}
			}
		}
		//------ Init Slider ------------------------------------
		private function _initSlider($id:int, $x:Number, $y:Number):void {
			var imageSliderComponent:ImageSliderComponent=_entityManager.addComponentFromName("LittleFighterEvo","ImageSliderComponent","mySliderComponent_"+$id) as ImageSliderComponent;
			imageSliderComponent.loop = true;
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
			if(_finiteStateMachine.currentState!=this)	return;
			var target:String;
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop(2);
				_finiteStateMachine.goToPreviousState();
				return;
			}else if($evt.keyCode == KeyConfig.Player1.A || $evt.keyCode == KeyConfig.Player2.A){
				if(_stepPlayer1==COMPUTER_SELECTION || _stepPlayer2==COMPUTER_SELECTION){
					var index:int = _computerSliderPosition;
					var step:int = _stepComputer;
					var team:List = _teamComputer;
					var imageSliderComponent:ImageSliderComponent=_sliderList[index];
					target = "_stepComputer";
				}else{
					index = $evt.keyCode == KeyConfig.Player1.A?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
				}
				if(step==INIT){
					if(_chronoList){
						_cancelCounter();
					}	
					if(imageSliderComponent.position==0){
						imageSliderComponent.next([0]);
						selectCharacter(index);
						if(target=="_stepComputer") _stepComputer=PLAYER_SELECTION
						else this[target+(index+1)]=PLAYER_SELECTION;
					}
				}else if(step==PLAYER_SELECTION){
					if(imageSliderComponent.position==1){
						imageSliderComponent.random([0,1]);
						_randomList.uniquePush(index);
						selectCharacter(index);
						selectTeam(index);
					}else if(imageSliderComponent.position>1){
						selectCharacter(index);
						selectTeam(index);
					}
					if(target=="_stepComputer")_stepComputer=TEAM_SELECTION;
					else this[target+(index+1)]= TEAM_SELECTION;
				}else if(step==TEAM_SELECTION){
					if(target=="_stepComputer"){
						_stepComputer=WAITING_NEW_PLAYER;
						if(_computerSliderPosition+1-_nbPlayer<_nbComputer){
							_computerSliderPosition++;
							_stepComputer = 1;
							_teamComputer.goto(0);
						}else{
							_showFightMenu();
							return ;
						}
					}else this[target+(index+1)]=WAITING_NEW_PLAYER;
					if(index==0 && (_stepPlayer2==INIT || _stepPlayer2==WAITING_NEW_PLAYER) || index==1 && (_stepPlayer1==INIT || _stepPlayer1==WAITING_NEW_PLAYER)){
						startCounter();
					}
				}else if(step==NB_COMPUTER_SELECTION){
					if(target=="_stepComputer") _stepComputer=COMPUTER_SELECTION
					else this[target+(index+1)]=COMPUTER_SELECTION;
					_computerComponent.visible = false;
					_nbComputer = _computerComponent.currentFrame-1;
					if(_nbComputer ==0){
						_showFightMenu();
						return ;
					}
					_resetComputers();
				}
			}else if($evt.keyCode == KeyConfig.Player1.J || $evt.keyCode == KeyConfig.Player2.J){
				if(_stepPlayer1==COMPUTER_SELECTION || _stepPlayer2==COMPUTER_SELECTION){
					index = _computerSliderPosition;
					step = _stepComputer;
					team = _teamComputer;
					imageSliderComponent=_sliderList[index];
					target = "_stepComputer";
				}else{
					index = $evt.keyCode == KeyConfig.Player1.J?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
				}
				if(_stepPlayer1==INIT && _stepPlayer2==INIT){
					onQuitBt(null);
				}
				if(step==PLAYER_SELECTION){
					if(target=="_stepComputer"){
						_stepComputer=1;
						if(_computerSliderPosition+1-_nbPlayer==1){
							_deleteComputer(index);
							if(_stepPlayer2==COMPUTER_SELECTION)
								_stepPlayer2 = WAITING_NEW_PLAYER;
							else if(_stepPlayer1==COMPUTER_SELECTION)
								_stepPlayer1 = WAITING_NEW_PLAYER;
							onChronoComplete(null);
						}else{
							_computerSliderPosition--;
							_resetComputer(index);
							var teamTF:TextField = _menuComponent.graphic["team"+(_computerSliderPosition+1)+"TF"]
							teamTF.text = "";
						} 
					}else{
						imageSliderComponent.goto(0);
						var playerTF:TextField = _menuComponent.graphic["player"+index+1+"TF"];
						var fighterTF:TextField = _menuComponent.graphic["fighter"+index+1+"TF"];
						playerTF.text="join";
						fighterTF.text="";
						this[target+(index+1)]=INIT;	
						}
				}else if(step==TEAM_SELECTION){
					if(target=="_stepComputer"){
						_stepComputer=PLAYER_SELECTION;
					}else{
						this[target+(index+1)]=PLAYER_SELECTION;
					}
					teamTF = _menuComponent.graphic["team"+(index+1)+"TF"]
					teamTF.text = "";
				}else if(step==NB_COMPUTER_SELECTION){
					//if(target=="_stepComputer") _stepComputer=COMPUTER_SELECTION
					//else this[target+(index+1)]=COMPUTER_SELECTION;
				}
			}else if($evt.keyCode == KeyConfig.Player1.LEFT || $evt.keyCode == KeyConfig.Player2.LEFT){
				if(_stepPlayer1==COMPUTER_SELECTION || _stepPlayer2==COMPUTER_SELECTION){
					index = _computerSliderPosition;
					step = _stepComputer;
					team = _teamComputer;
					imageSliderComponent=_sliderList[index];
					target = "_stepComputer";
				}else{
					index = $evt.keyCode == KeyConfig.Player1.LEFT?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
				}
				if(step==PLAYER_SELECTION){
					if(imageSliderComponent.position>0){
						imageSliderComponent.prev([0]);
						selectCharacter(index);
					}
				}else if(step==TEAM_SELECTION){
					team.prev();
					selectTeam(index);
				}else if(step==NB_COMPUTER_SELECTION){
					if(!(_computerComponent.currentFrame==2 && (_stepPlayer1<WAITING_NEW_PLAYER || _stepPlayer2<WAITING_NEW_PLAYER))){
						_computerComponent.prevFrame();
					}
				}else if(step==COMPUTER_SELECTION){
				}
			}else if($evt.keyCode == KeyConfig.Player1.RIGHT || $evt.keyCode == KeyConfig.Player2.RIGHT){
				if(_stepPlayer1==COMPUTER_SELECTION || _stepPlayer2==COMPUTER_SELECTION){
					index = _computerSliderPosition;
					step = _stepComputer;
					team = _teamComputer;
					imageSliderComponent=_sliderList[index];
					target = "_stepComputer";
				}else{
					index = $evt.keyCode == KeyConfig.Player1.RIGHT?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
				}
				if(step==PLAYER_SELECTION){
					if(imageSliderComponent.position>0){
						imageSliderComponent.next([0]);
						selectCharacter(index);
					}
				}else if(step==TEAM_SELECTION){
					team.next();
					selectTeam(index);
				}else if(step==NB_COMPUTER_SELECTION){
					if(!(_computerComponent.currentFrame==7 && _stepPlayer1>=WAITING_NEW_PLAYER && _stepPlayer2>=WAITING_NEW_PLAYER)){
						_computerComponent.nextFrame();
					}
				}else if(step==COMPUTER_SELECTION){
					
				}
			}
		}
		//------ Select Character ------------------------------------
		public function selectCharacter($index:Number):void {
			var index:int = $index+1;
			var playerTF:TextField = _menuComponent.graphic["player"+index+"TF"];
			var fighterTF:TextField = _menuComponent.graphic["fighter"+index+"TF"];
			var teamTF:TextField = _menuComponent.graphic["team"+index+"TF"];
			var imageSliderComponent:ImageSliderComponent=_sliderList[$index];
			var position:int = imageSliderComponent.position;
			if(playerTF.text!="Computer"){
				playerTF.text = index.toString();
				playerTF.autoSize = TextFieldAutoSize.CENTER;
			}
			if(position==1){
				fighterTF.text = "Random";
			}else if(position>1){
				fighterTF.text = _nestImageObject[position-2].name;
			}
			teamTF = _menuComponent.graphic["team"+($index+1)+"TF"]
			teamTF.text = "";
			fighterTF.autoSize = TextFieldAutoSize.CENTER;
		}
		//------ Select Team ------------------------------------
		public function selectTeam($position:Number):void {
			var index:int = $position + 1;
			if(_menuComponent.graphic["player"+index+"TF"].text=="Computer")
				var team:List = _teamComputer;
			else{
				team = this["_teamPlayer"+index];
			}
			var teamTF:TextField = _menuComponent.graphic["team"+index+"TF"];
			teamTF.text = team.currentItem;
			teamTF.autoSize = TextFieldAutoSize.CENTER;
		}
		//------ Start Counter ------------------------------------
		public function startCounter():void {
			if(!_chronoList){
				_chronoList = new Array();
				var timerComponent:TimerComponent=_entityManager.addComponentFromName("LittleFighterEvo","TimerComponent","myTimerComponent") as TimerComponent;
				var chrono:ChronoComponent;
				var playerTF:TextField;
				_nbPlayer = _stepPlayer1==WAITING_NEW_PLAYER && _stepPlayer2==WAITING_NEW_PLAYER?2:1;
				_computerSliderPosition = _nbPlayer;
				for (var i:int=_computerSliderPosition;i<_sliderList.length;i++){
					_sliderList[i].visible = false;
					playerTF = _menuComponent.graphic["player"+(i+1)+"TF"];
					playerTF.text= "-"
					if(i==_computerSliderPosition){
						chrono=_entityManager.addComponentFromName("LittleFighterEvo","ChronoComponent","myChronoComponent_"+i,{onChronoComplete:onChronoComplete}) as ChronoComponent;
					}else{
						chrono=_entityManager.addComponentFromName("LittleFighterEvo","ChronoComponent","myChronoComponent_"+i) as ChronoComponent;
					}
					chrono.setFormat("Arial",40,0xFFFFFF);
					chrono.moveTo(167+150*(i%4),215 + 205 *Math.floor(i/4));
					_chronoList.push(chrono);
					chrono.start(2, 1000);
				}
			}
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete($chronoComponent:ChronoComponent):void {
			if(_finiteStateMachine.currentState!=this)	return;
			if(!_computerComponent){
				_computerComponent = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myComputers") as GraphicComponent;
				_computerComponent.graphic = new ComputersUI as MovieClip;
				LayoutUtil.Align(_computerComponent,LayoutUtil.ALIGN_CENTER_CENTER);
			}else{
				_computerComponent.visible = true;
				_computerComponent.gotoAndStop(1);
			}
			_stopCounter();
			if(_stepPlayer1!=WAITING_NEW_PLAYER || _stepPlayer2!=WAITING_NEW_PLAYER){
				(_computerComponent.graphic.c0TF as TextField).textColor = 0x666666;
				_computerComponent.nextFrame();
			}else{
				(_computerComponent.graphic.c7TF as TextField).textColor = 0x666666;
			}
			if(_stepPlayer1 == WAITING_NEW_PLAYER){
				_stepPlayer1=NB_COMPUTER_SELECTION;
			}if(_stepPlayer2 == WAITING_NEW_PLAYER){
				_stepPlayer2=NB_COMPUTER_SELECTION;
			}
		}
		//------ StopCounter ------------------------------------
		private  function _stopCounter():void {
			for each(var c:ChronoComponent in _chronoList){
				c.visible = false;
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
			}
			_initSliders();
		}
		//------ Reset ------------------------------------
		private  function _reset():void {
			_stopCounter();
			_teamPlayer1.goto(0);
			_teamPlayer2.goto(0);
			_teamComputer.goto(0);
			_stepPlayer1 = 0;
			_stepPlayer2 = 0;
			_stepComputer = 1;
			_computerSliderPosition=0;
			for each(var slider:ImageSliderComponent in _sliderList){
				slider.visible=false;
			}
			_resetCounter();
			_randomList = new ArrayPlus();
			_difficulty.goto(0);
			_background.goto(0);
			if(_fightMenu)	_fightMenu.visible=false;
			if(_computerComponent){ 
				_computerComponent.visible = false;
				(_computerComponent.graphic.c0TF as TextField).textColor = 0xFFFFFF;
				(_computerComponent.graphic.c7TF as TextField).textColor = 0xFFFFFF;
			}
		}
		//------ Reset All------------------------------------
		private  function _resetAll():void {
			_teamPlayer1.goto(0);
			_teamPlayer2.goto(0);
			_teamComputer.goto(0);
			_stepPlayer1 = 0;
			_stepPlayer2 = 0;
			_stepComputer = 1;
			_computerSliderPosition=0;
			_fightMenu.visible=false;
			_resetSliders();
			_resetCounter();
			_randomList = new ArrayPlus();
		}
		//------ Reset Computers ------------------------------------
		private function _resetComputers():void {
			var start:int = _stepPlayer1>=WAITING_NEW_PLAYER && _stepPlayer2>=WAITING_NEW_PLAYER?2:1;
			_nbComputer = _computerComponent.currentFrame-1;
			for (var i:int=start;i<start+_nbComputer;i++){
				_resetComputer(i);
			}
		}
		//------ Reset Computer ------------------------------------
		private function _resetComputer($index:int):void {
			var imageSliderComponent:ImageSliderComponent;
			var playerTF:TextField 
			var fighterTF:TextField;
			var teamTF:TextField;
			imageSliderComponent=_sliderList[$index];
			imageSliderComponent.goto(1);
			imageSliderComponent.visible = true;
			playerTF = _menuComponent.graphic["player"+($index+1)+"TF"];
			playerTF.text= "Computer";
			fighterTF = _menuComponent.graphic["fighter"+($index+1)+"TF"];
			fighterTF.text="Random";
			teamTF = _menuComponent.graphic["team"+($index+1)+"TF"]
			teamTF.text = "";
		}
		//------ Reset Computer ------------------------------------
		private function _deleteComputer($index:int):void {
			var imageSliderComponent:ImageSliderComponent;
			var playerTF:TextField 
			var fighterTF:TextField;
			var teamTF:TextField;
			imageSliderComponent=_sliderList[$index];
			imageSliderComponent.visible = false;
			playerTF = _menuComponent.graphic["player"+($index+1)+"TF"];
			playerTF.text= "-";
			fighterTF = _menuComponent.graphic["fighter"+($index+1)+"TF"];
			fighterTF.text="";
			teamTF = _menuComponent.graphic["team"+($index+1)+"TF"]
			teamTF.text = "";
		}
		//------ Reset Sliders------------------------------------
		private  function _resetSliders():void {
			var playerTF:TextField=null;
			var fighterTF:TextField=null;
			var teamTF:TextField=null;
			var imageSliderComponent:ImageSliderComponent;
			for(var i:int=0;i<8;i++){
				playerTF = _menuComponent.graphic["player"+(i+1)+"TF"]
				playerTF.autoSize = TextFieldAutoSize.CENTER;
				playerTF.text = "join";
				fighterTF = _menuComponent.graphic["fighter"+(i+1)+"TF"]
				fighterTF.text = "";
				teamTF = _menuComponent.graphic["team"+(i+1)+"TF"]
				teamTF.text = "";
				imageSliderComponent = _sliderList[i]
				imageSliderComponent.visible=true;
				imageSliderComponent.reset();
			}
		}
		//------ Reset Counter------------------------------------
		private  function _resetCounter():void {
			for each(var c:ChronoComponent in _chronoList){
				c.destroy();
			}
			_chronoList = null;
		}
		//------ Cancel Counter------------------------------------
		private  function _cancelCounter():void {
			_resetCounter();
			for each(var imageSliderComponent:ImageSliderComponent in _sliderList){
				imageSliderComponent.visible = true;
			}
		}
		
		//------ Reset Random------------------------------------
		private  function _resetRandom():void {
			var imageSliderComponent:ImageSliderComponent;
			for each(var index:int in _randomList){
				imageSliderComponent = _sliderList[index]
				imageSliderComponent.random([0,1]);
				selectCharacter(index);
			}
		}
		//------ Show Fight Menu ------------------------------------
		private  function _showFightMenu():void {
			if(_fightMenu)	_fightMenu.visible=true;
			else{
				_fightMenu = _entityManager.addComponentFromName("LittleFighterEvo","GraphicComponent","myFightMenu") as GraphicComponent;
				_fightMenu.graphic = new FightUI as MovieClip;
				_fightMenu.setButton(_fightMenu.graphic.fightBt, {onMouseClick:onFightBt},"fightBt");
				_fightMenu.setButton(_fightMenu.graphic.resetRandomBt, {onMouseClick:onResetRandomBt},"resetRandomBt");
				_fightMenu.setButton(_fightMenu.graphic.resetAllBt, {onMouseClick:onResetAllBt},"resetAllBt");
				_fightMenu.setButton(_fightMenu.graphic.difficultyBt, {onMouseClick:onDifficultyBt},"difficultyBt");
				_fightMenu.setButton(_fightMenu.graphic.backgroundBt, {onMouseClick:onBackgroundBt},"backgroundBt");
				_fightMenu.setButton(_fightMenu.graphic.quitBt, {onMouseClick:onQuitBt},"quitBt");
				_fightMenu.moveTo(0,100);
				_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
				_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
			}
		}
		//------ On Fight Bt Click ------------------------------------
		private function onFightBt($mousePad:MousePad):void {
			var list:Array = new Array();
			var imageSliderComponent:ImageSliderComponent;
			var teamTF:TextField=null;	
			var playerTF:TextField=null;	
			for (var index:int=0;index<_nbComputer+_nbPlayer;index++){
				imageSliderComponent = _sliderList[index];
				teamTF =  _menuComponent.graphic["team"+(index+1)+"TF"];
				playerTF =  _menuComponent.graphic["player"+(index+1)+"TF"];
				list.push([imageSliderComponent.position-1 ,playerTF.text, teamTF.text]);
			}
			Data.GAME_PARAM.players = list;
			Data.GAME_PARAM.difficulty =_difficulty.currentItem;
			Data.GAME_PARAM.background = _background.currentItem;
			_menuComponent.gotoAndStop(5);
			_finiteStateMachine.goToNextState();
		}
		//------ On Reset Random Bt Click ------------------------------------
		private function onResetRandomBt($mousePad:MousePad):void {
			_resetRandom();
		}
		//------ On Reset All Bt Click ------------------------------------
		private function onResetAllBt($mousePad:MousePad):void {
			_resetAll();
		}
		//------ On Difficulty Bt Click ------------------------------------
		private function onDifficultyBt($mousePad:MousePad):void {
			_difficulty.next();
			_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
		}
		//------ On Background Bt Click ------------------------------------
		private function onBackgroundBt($mousePad:MousePad):void {
			_background.next();
			_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
		}
		//------ On Quit Bt Click ------------------------------------
		private function onQuitBt($mousePad:MousePad):void {
			_menuComponent.gotoAndStop(2);
			_finiteStateMachine.goToPreviousState();
		}
		//------ Exit ------------------------------------
		public override function exit($previousState:State):void {
			_reset();
		}
	}
}