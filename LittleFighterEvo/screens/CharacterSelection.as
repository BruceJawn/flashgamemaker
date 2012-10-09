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
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import framework.Framework;
	import framework.component.core.GraphicComponent;
	import framework.component.core.ImageSliderComponent;
	import framework.component.core.KeyboardInputComponent;
	import framework.entity.EntityManager;
	import framework.entity.IEntityManager;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	
	import utils.keyboard.KeyCode;
	import utils.richardlord.*;
	import utils.collection.List;

	/**
	 * Character Selection
	 */
	public class CharacterSelection extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent = null;
		private var _graphicManager:IGraphicManager = null;
		private var _sliderList:Array = null;
		private var _position:int = 0;
		private var _nestImageObject:Array=null;
		private var _team:List = null;
		private var _characterSelected:Boolean = false;
		
		public function CharacterSelection(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_sliderList = new Array();
			_nestImageObject = new Array();
			_team = ["independent","team1","team2","team3","team4"]
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyInput:KeyboardInputComponent=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
		}
		//------ Init Slider ------------------------------------
		private function _initSliders():void {
			for(var i:int=0;i<4;i++){
				_initSlider(i,155+i*153,174);
				_initSlider(i+4,155+i*153,375);
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
			}else if($evt.keyCode == KeyCode.I){
				var imageSliderComponent:ImageSliderComponent=_sliderList[_position];
				if(imageSliderComponent.position==0){
					imageSliderComponent.next([0]);
				}else if(imageSliderComponent.position==1){
					imageSliderComponent.random([0,1]);
					selectCharacter(imageSliderComponent.position - 2);
					_characterSelected = true;
					selectTeam();
				}else if(imageSliderComponent.position>1){
					selectCharacter(imageSliderComponent.position - 2);
					_characterSelected = true;
					selectTeam();
				}
			}else if($evt.keyCode == KeyCode.LEFT){
				imageSliderComponent=_sliderList[_position];
				if(imageSliderComponent.position>0 && !_characterSelected){
					imageSliderComponent.prev([0]);
					selectCharacter(imageSliderComponent.position-2);
				}else if (_characterSelected) {
					_team.prev();
					selectTeam();
				}
			}else if($evt.keyCode == KeyCode.RIGHT){
				imageSliderComponent=_sliderList[_position];
				if(imageSliderComponent.position>0 && !_characterSelected){
					imageSliderComponent.next([0]);
					selectCharacter(imageSliderComponent.position-2);
				}else if (_characterSelected) {
					_team.next();
					selectTeam();
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
		public function selectTeam($position:Number):void {
			var index:int = _position + 1;
			var teamTF:TextField = _menuComponent.graphic["team"+index+"Txt"];
			teamTF.text = _team.currentNode as String;
			teamTF.autoSize = TextFieldAutoSize.CENTER;
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