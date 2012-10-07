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

	/**
	 * Character Selection
	 */
	public class CharacterSelection extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent = null;
		private var _graphicManager:IGraphicManager = null;
		
		public function CharacterSelection(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var keyInput:KeyboardInputComponent=_entityManager.getComponent("LittleFighterEvo","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
			_menuComponent=_entityManager.getComponent("LittleFighterEvo","myMenu") as GraphicComponent;
		}
		//------ Init Slider ------------------------------------
		private function initSlider():void {
			var imageSliderComponent:ImageSliderComponent=_entityManager.addComponentFromName("LittleFighterEvo","ImageSliderComponent","mySliderComponent") as ImageSliderComponent;
			var list:Array = new Array();
			var graphic:Bitmap;
			for each(var object:Object in Data.OBJECT){
				if(object.hasOwnProperty("face")){
					graphic = _graphicManager.getGraphic(Framework.root+object.face);
					list.push(graphic);
				}
			}
			imageSliderComponent.init(list);
			imageSliderComponent.moveTo(150,400);
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if($evt.keyCode == KeyCode.ESC){
				_menuComponent.gotoAndStop("MENU");
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			if(!_entityManager){
				initVar();
				initComponent();
				initSlider();
			}
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
		}
	}
}