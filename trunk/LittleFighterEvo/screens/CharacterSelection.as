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
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.text.TextColorType;
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
		private var _music:List = null;
		private var _lang:Object = null;
		private var _focusTextField1:TextField;
		private var _focusTextField2:TextField;
		private var _focusTextFieldComputer:TextField;
		private var _focusTextColor:uint =0xACB8DC;
		
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
			_lang= MultiLang.data[Data.LOCAL_LANG].CharacterSelection;
			_teamPlayer1 = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_teamPlayer2 = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_teamComputer = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_difficulty = new List(_lang.easy,_lang.normal,_lang.hard);
			_background = new List("Forest");
			_music = new List("stage1","stage2");
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
				playerTF.text = _lang.join;
				imageSliderComponent = _sliderList[i]
				if(!imageSliderComponent){
					_initSlider(i,195+(i%4)*153,55+211*Math.floor(i/4));
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
					var focusTextField:String = "_focusTextFieldComputer" 
					var imageSliderComponent:ImageSliderComponent=_sliderList[index];
					target = "_stepComputer";
				}else{
					index = $evt.keyCode == KeyConfig.Player1.A?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					focusTextField = "_focusTextField"+(index+1);
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
				}
				if(_fightMenu && _fightMenu.visible){
					index= _fightMenu.graphic.focusClip.currentFrame;
					if(index==1)			_onFightBt(null);
					else if(index==2)		_onResetRandomBt(null);
					else if(index==3)		_onResetAllBt(null);
					else if(index==6)		_onQuitBt(null);
				}else if(step==INIT){
					if(_chronoList){
						_cancelCounter();
					}	
					if(_computerComponent){
						_computerComponent.visible = false;
						(_computerComponent.graphic.c0TF as TextField).textColor = 0xFFFFFF;
						(_computerComponent.graphic.c7TF as TextField).textColor = 0xFFFFFF;
						if(_stepPlayer1 == NB_COMPUTER_SELECTION){
							_stepPlayer1=WAITING_NEW_PLAYER;
						}if(_stepPlayer2 == NB_COMPUTER_SELECTION){
							_stepPlayer2=WAITING_NEW_PLAYER;
						}
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
							_focusTextFieldComputer.textColor = 0xFFFFFF
							teamTF = _menuComponent.graphic["team"+(_computerSliderPosition)+"TF"];
							teamTF.textColor=0xFFFFFF;
							fighterTF = _menuComponent.graphic["fighter"+(_computerSliderPosition+1)+"TF"];
							fighterTF.textColor=_focusTextColor;
							_focusTextFieldComputer = fighterTF;
						}else{
							if(_focusTextField1)_focusTextField1.textColor=0xFFFFFF;
							_focusTextField1 = null;
							if(_focusTextField2)_focusTextField2.textColor=0xFFFFFF;
							_focusTextField2 = null;
							if(_focusTextFieldComputer)_focusTextFieldComputer.textColor=0xFFFFFF;
							_focusTextFieldComputer = null;
							_showFightMenu();
							return ;
						}
					}else{
						this[target+(index+1)]=WAITING_NEW_PLAYER;
						if(this[focusTextField])this[focusTextField].textColor = 0xFFFFFF
						this[focusTextField] = null;
					} 
					if(index==0 && (_stepPlayer2==INIT || _stepPlayer2==WAITING_NEW_PLAYER) || index==1 && (_stepPlayer1==INIT || _stepPlayer1==WAITING_NEW_PLAYER)){
						startCounter();
					}
				}else if(step==NB_COMPUTER_SELECTION){
					if(target=="_stepComputer") _stepComputer=COMPUTER_SELECTION
					else this[target+(index+1)]=COMPUTER_SELECTION;
					_computerComponent.visible = false;
					_nbComputer = _computerComponent.currentFrame-1;
					if(_nbComputer ==0){
						if(this[focusTextField])	this[focusTextField].textColor = 0xFFFFFF;
						this[focusTextField] = null;
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
					focusTextField = "_focusTextFieldComputer" 
				}else{
					index = $evt.keyCode == KeyConfig.Player1.J?0:1;
					step = this["_stepPlayer"+(index+1)];
					team = this["_teamPlayer"+(index+1)];
					imageSliderComponent=_sliderList[index];
					target = "_stepPlayer";
					focusTextField = "_focusTextField"+(index+1);
				}
				if(_stepPlayer1==INIT && _stepPlayer2==INIT){
					_onQuitBt(null);
				}
				if(step==PLAYER_SELECTION){
					if(target=="_stepComputer"){
						_stepComputer=1;
						if(_computerSliderPosition+1-_nbPlayer==1){
							for (var i:int = index; i<index+_nbComputer;i++)
								_deleteComputer(i);
							if(_stepPlayer2==COMPUTER_SELECTION)
								_stepPlayer2 = WAITING_NEW_PLAYER;
							else if(_stepPlayer1==COMPUTER_SELECTION)
								_stepPlayer1 = WAITING_NEW_PLAYER;
							_randomList = new ArrayPlus();
							onChronoComplete(null);
						}else{
							_computerSliderPosition--;
							_resetComputer(index);
							var teamTF:TextField = _menuComponent.graphic["team"+(_computerSliderPosition+1)+"TF"]
							teamTF.text = "";
							fighterTF = _menuComponent.graphic["fighter"+(_computerSliderPosition+1)+"TF"];
							fighterTF.textColor = 0xFFFFFF
							fighterTF = _menuComponent.graphic["fighter"+(_computerSliderPosition+1)+"TF"];
							fighterTF.textColor = _focusTextColor
							this[focusTextField] = fighterTF;
						} 
					}else{
						imageSliderComponent.goto(0);
						var playerTF:TextField = _menuComponent.graphic["player"+(index+1)+"TF"];
						var fighterTF:TextField = _menuComponent.graphic["fighter"+(index+1)+"TF"];
						playerTF.text=_lang.join;
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
					fighterTF = _menuComponent.graphic["fighter"+(index+1)+"TF"];
					fighterTF.textColor = _focusTextColor;
					this[focusTextField] = fighterTF;
				}else if(step==WAITING_NEW_PLAYER){
					teamTF = _menuComponent.graphic["team"+(index+1)+"TF"];
					teamTF.textColor = _focusTextColor;
					this[focusTextField] = teamTF;
					this[target+(index+1)]=TEAM_SELECTION;
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
				}else if(_fightMenu && _fightMenu.visible){
					index= _fightMenu.graphic.focusClip.currentFrame;
					if(index==4){
						_difficulty.prev();
						_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
					}else if(index==5){
						_background.prev();
						_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
					}else{
						_music.prev();
						_fightMenu.graphic.musicTF.text = _music.currentItem;
					}
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
				}else if(_fightMenu && _fightMenu.visible){
					index= _fightMenu.graphic.focusClip.currentFrame;
					if(index==4){
						_difficulty.next();
						_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
					}else if(index==5){
						_background.next();
						_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
					}else{
						_music.prev();
						_fightMenu.graphic.musicTF.text = _music.currentItem;
					}
				}
			}else if(_fightMenu && _fightMenu.visible){
				if($evt.keyCode == KeyCode.DOWN || $evt.keyCode == KeyConfig.Player1.DOWN || $evt.keyCode == KeyConfig.Player2.DOWN ){
					_fightMenu.graphic.focusClip.nextFrame();
				}else if($evt.keyCode == KeyCode.UP || $evt.keyCode == KeyConfig.Player1.UP || $evt.keyCode == KeyConfig.Player2.UP ){
					_fightMenu.graphic.focusClip.prevFrame();
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
			if(index==1){
				var focusTextField:String = "_focusTextField1";
			}else if(index==2){
				focusTextField = "_focusTextField2";
			}else{
				focusTextField = "_focusTextFieldComputer";
			}
			if(playerTF.text!=_lang.computer){
				playerTF.text = index.toString();
				playerTF.autoSize = TextFieldAutoSize.CENTER;
			}
			if(this[focusTextField] && this[focusTextField]!=fighterTF){
				this[focusTextField].textColor=0xFFFFFF;
			}
			if(position==1){
				fighterTF.text = _lang.random;
			}else if(position>1){
				fighterTF.text = _nestImageObject[position-2].name;
			}
			fighterTF.textColor=_focusTextColor;
			this[focusTextField] = fighterTF;
			fighterTF.autoSize = TextFieldAutoSize.CENTER;
		}
		//------ Select Team ------------------------------------
		public function selectTeam($position:Number):void {
			var index:int = $position + 1;
			if(_menuComponent.graphic["player"+index+"TF"].text==_lang.computer)
				var team:List = _teamComputer;
			else{
				team = this["_teamPlayer"+index];
			}
			if(index==1){
				var focusTextField:String = "_focusTextField1";
			}else if(index==2){
				focusTextField = "_focusTextField2";
			}else{
				focusTextField = "_focusTextFieldComputer";
			}
			var teamTF:TextField = _menuComponent.graphic["team"+index+"TF"];
			if(this[focusTextField] && this[focusTextField]!=teamTF){
				this[focusTextField].textColor=0xFFFFFF;
			}
			teamTF.text = team.currentItem;
			teamTF.autoSize = TextFieldAutoSize.CENTER;
			teamTF.textColor=_focusTextColor;
			this[focusTextField] = teamTF;
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
					chrono.moveTo(207+150*(i%4),95 + 205 *Math.floor(i/4));
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
			_computerComponent.graphic.nbComputersTF.text = _lang.nbComputersTF;
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
			if(_focusTextField1)_focusTextField1.textColor=0xFFFFFF;
			_focusTextField1 = null;
			if(_focusTextField2)_focusTextField2.textColor=0xFFFFFF;
			_focusTextField2 = null;
			if(_focusTextFieldComputer)_focusTextFieldComputer.textColor=0xFFFFFF;
			_focusTextFieldComputer = null;
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
			if(_focusTextField1)_focusTextField1.textColor=0xFFFFFF;
			_focusTextField1 = null;
			if(_focusTextField2)_focusTextField2.textColor=0xFFFFFF;
			_focusTextField2 = null;
			if(_focusTextFieldComputer)_focusTextFieldComputer.textColor=0xFFFFFF;
			_focusTextFieldComputer = null;
		}
		//------ Reset Computers ------------------------------------
		private function _resetComputers():void {
			var start:int = _stepPlayer1>=WAITING_NEW_PLAYER && _stepPlayer2>=WAITING_NEW_PLAYER?2:1;
			_nbComputer = _computerComponent.currentFrame-1;
			for (var i:int=start;i<start+_nbComputer;i++){
				_resetComputer(i);
			}
			var fighterTF:TextField = _menuComponent.graphic["fighter"+(start+1)+"TF"];
			fighterTF.textColor=_focusTextColor;
			_focusTextFieldComputer = fighterTF;
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
			playerTF.text= _lang.computer;
			fighterTF = _menuComponent.graphic["fighter"+($index+1)+"TF"];
			fighterTF.text=_lang.random;
			fighterTF.textColor = 0xFFFFFF;
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
				playerTF.text = _lang.join;
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
				_fightMenu.setButton(_fightMenu.graphic.fightBt, {onMouseClick:_onFightBt},"fightBt");
				_fightMenu.setButton(_fightMenu.graphic.resetRandomBt, {onMouseClick:_onResetRandomBt},"resetRandomBt");
				_fightMenu.setButton(_fightMenu.graphic.resetAllBt, {onMouseClick:_onResetAllBt},"resetAllBt");
				_fightMenu.setButton(_fightMenu.graphic.difficultyBt, {onMouseClick:_onDifficultyBt},"difficultyBt");
				_fightMenu.setButton(_fightMenu.graphic.backgroundBt, {onMouseClick:_onBackgroundBt},"backgroundBt");
				_fightMenu.setButton(_fightMenu.graphic.quitBt, {onMouseClick:_onQuitBt},"quitBt");
				_fightMenu.moveTo(0,10);
			}
			_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
			_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
			_fightMenu.graphic.musicTF.text = _music.currentItem;
			_fightMenu.graphic.changeMusicTF.text = _lang.changeMusicTF;
			_upateButtonTF(_fightMenu.graphic.fightBt, _lang.fightBt);
			_upateButtonTF(_fightMenu.graphic.resetRandomBt, _lang.resetRandomBt);
			_upateButtonTF(_fightMenu.graphic.resetAllBt, _lang.resetAllBt);
			_upateButtonTF(_fightMenu.graphic.difficultyBt, _lang.difficultyBt);
			_upateButtonTF(_fightMenu.graphic.backgroundBt, _lang.backgroundBt);
			_upateButtonTF(_fightMenu.graphic.quitBt, _lang.quitBt);
		}
		//------ On Fight Bt Click ------------------------------------
		private function _onFightBt($mousePad:MousePad):void {
			Framework.Focus();
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
		private function _onResetRandomBt($mousePad:MousePad):void {
			Framework.Focus();
			_resetRandom();
			if(_focusTextField1)_focusTextField1.textColor=0xFFFFFF;
			_focusTextField1 = null;
			if(_focusTextField2)_focusTextField2.textColor=0xFFFFFF;
			_focusTextField2 = null;
			if(_focusTextFieldComputer)_focusTextFieldComputer.textColor=0xFFFFFF;
			_focusTextFieldComputer = null;
		}
		//------ On Reset All Bt Click ------------------------------------
		private function _onResetAllBt($mousePad:MousePad):void {
			Framework.Focus();
			_resetAll();
		}
		//------ On Difficulty Bt Click ------------------------------------
		private function _onDifficultyBt($mousePad:MousePad):void {
			Framework.Focus();
			_difficulty.next();
			_fightMenu.graphic.difficultyTF.text  = _difficulty.currentItem;
		}
		//------ On Background Bt Click ------------------------------------
		private function _onBackgroundBt($mousePad:MousePad):void {
			Framework.Focus();
			_background.next();
			_fightMenu.graphic.backgroundTF.text  = _background.currentItem;
		}
		//------ On Quit Bt Click ------------------------------------
		private function _onQuitBt($mousePad:MousePad):void {
			Framework.Focus();
			_menuComponent.gotoAndStop(2);
			_finiteStateMachine.goToPreviousState();
		}
		//------ Update Lang ------------------------------------
		private function _upateLang():void {
			_lang= MultiLang.data[Data.LOCAL_LANG].CharacterSelection;
			_teamPlayer1 = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_teamPlayer2 = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_teamComputer = new List(_lang.independent,_lang.team1,_lang.team2,_lang.team3,_lang.team4);
			_difficulty = new List(_lang.easy,_lang.normal,_lang.hard);
			TextField(_menuComponent.graphic.characterSelectionTF).htmlText = _lang.characterSelectionTF;
			TextField(_menuComponent.graphic.playerField1TF).htmlText = _lang.playerFieldTF;
			TextField(_menuComponent.graphic.playerField2TF).htmlText = _lang.playerFieldTF;
			TextField(_menuComponent.graphic.fighterField1TF).htmlText = _lang.fighterFieldTF;
			TextField(_menuComponent.graphic.fighterField2TF).htmlText = _lang.fighterFieldTF;
			TextField(_menuComponent.graphic.teamField1TF).htmlText = _lang.teamFieldTF;
			TextField(_menuComponent.graphic.teamField2TF).htmlText = _lang.teamFieldTF;
		}
		//------ Update Lang ------------------------------------
		private function _upateButtonTF($button:SimpleButton, $text:String):void {
			TextField($button.upState).text=$text;
			TextField($button.overState).text=$text;
			TextField($button.downState).text=$text;
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
			}
			_initSliders();
			_upateLang();
		}
		//------ Exit ------------------------------------
		public override function exit($previousState:State):void {
			_reset();
		}
	}
}