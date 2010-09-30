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

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;
	
	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.display.*;
	
	/**
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class PlayerComponent extends GraphicComponent {

		private var _ressourceManager:IRessourceManager=null;
		protected var _playerXml:XML=null;
		protected var _playerName:String=null;
		protected var _playerTexture:String=null;
		protected var _playerHeight:Number;
		protected var _playerWidth:Number;
		
		public function PlayerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_render_layerId = 1;
		}
		//------ Load Player ------------------------------------
		public function loadPlayer(path:String, playerName:String):void {
			_playerName=playerName;
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			_ressourceManager.loadXml(path,playerName);
		}
		//------ On Xml Loading Successfull ------------------------------------
		protected function onXmlLoadingSuccessful(evt:Event):void {
			_playerXml=_ressourceManager.getXml(_playerName);
			if(_playerXml!=null){
				var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
				dispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
				serializeXml();
				loadGraphic(_playerTexture, _playerName);
			}
		}
		//------ Serialize Xml ------------------------------------
		private function serializeXml():void {
			_playerTexture=_playerXml.children().path;
			_playerWidth=_playerXml.children().@playerWidth;
			_playerHeight=_playerXml.children().@playerHeight;
		}
		//------ Create Player ------------------------------------
		protected function createPlayer():void {
			
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			if(getGraphic(_playerName)!=null){
				var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
				dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
				dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
				createPlayer();
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}