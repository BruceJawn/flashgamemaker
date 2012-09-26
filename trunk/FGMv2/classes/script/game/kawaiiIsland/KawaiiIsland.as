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
	import com.adobe.serialization.json.JSON;
	
	import flash.display.MovieClip;
	
	import framework.entity.EntityManager;
	import framework.entity.IEntity;
	import framework.entity.IEntityManager;
	
	import script.game.kawaiiIsland.event.GInterfaceEvent;
	import script.game.kawaiiIsland.event.PreloaderEvent;
	import script.game.kawaiiIsland.event.UInterfaceEvent;
	
	import utils.connections.Connection;
	import utils.connections.FacebookConnection;
	import utils.stuv.Params;

	/**
	 * Main Class of the KawaiiIsland Game
	 */
	public class KawaiiIsland{
		private var _preloader:Preloader=null;		//Preloader
		private var _cInterface:CInterface=null;	//Customization Interface
		private var _gInterface:GInterface=null;	//Game Interface
		private var _game:Game=null;				//Game
		private var _connection:FacebookConnection = null;
		
		public function KawaiiIsland(){
			initVar();
			//initConnection();
			initPreloader();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			var entityManager:IEntityManager=EntityManager.getInstance();
			var entity:IEntity=entityManager.createEntity("KawaiiIsland");
		}
		//------ Init Connection ------------------------------------
		private function initConnection():void {
			_connection = FacebookConnection.getInstance();
			//_connection.sendJS("displaymessage");
		}
		//------ Init Preloader ------------------------------------
		private function initPreloader():void {
			_preloader = new Preloader();
			_preloader.addEventListener(PreloaderEvent.PRELOADER_LOADING_COMPLETE, onLoadingComplete);
			_preloader.addEventListener(PreloaderEvent.PRELOADER_ASSETS_LOADING_COMPLETE, onAssetsLoadingComplete);
		}
		//------ On Loading Complete ------------------------------------
		private function onLoadingComplete($evt:PreloaderEvent):void {
			trace("Loading Successfull. Init assets loading on background...")
		}
		//------ On Asset Loading Complete ------------------------------------
		private function onAssetsLoadingComplete($evt:PreloaderEvent):void {
			_cInterface = new CInterface();
			_cInterface.addEventListener(UInterfaceEvent.UINTERFACE_CUSTO_COMPLETE, onCustomizationComplete);
			trace("Assets Loading Complete")
		}
		//------ on Customization Complete ------------------------------------
		private function onCustomizationComplete($evt:UInterfaceEvent):void {
			trace("Customization Complete");
			_gInterface = new GInterface();
			_gInterface.addEventListener(GInterfaceEvent.GINTERFACE_COMPLETE, onGameInterfaceComplete);
		}
		//------ On Game Interface Complete ------------------------------------
		private function onGameInterfaceComplete($evt:GInterfaceEvent):void {
			_game = new Game(_gInterface);
			trace("Start Game")
		}
	}
}