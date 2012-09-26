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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import script.game.kawaiiIsland.event.PreloaderEvent;
	
	import utils.stuv.Platform;
	import utils.transform.BasicTransform;

	public class Preloader extends EventDispatcher{
		
		private var _entityManager:IEntityManager=null;
		private var _preloaderComponent:PreloaderComponent;
		
		// Preloader load the main swf (FlashGameMaker.swf) and preload assets
		public function Preloader(){
			initVar();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var url:String = FlashGameMaker.loaderInfo.url;
			url = url.substr(0, url.lastIndexOf("/"));
			url = url.substr(0, url.lastIndexOf("/"))+"/assets/";
			var renderComponent:RenderComponent = _entityManager.addComponentFromName("KawaiiIsland","RenderComponent","myRenderComponent") as RenderComponent;
			var assetsToLoad:Array = [url+"cursor.swf",url+"kawaiiTileSet.png",url+"tileSet.png",url+"kawaiiAddTileSet.png",url+"bebeClip.swf",url+"rpgText.swf",url+"kawaiiTree.swf",url+"kawaiiRock.swf",url+"kawaiiWell.swf",url+"kawaiiHouse.swf"]
			_preloaderComponent = _entityManager.addComponentFromName("KawaiiIsland","PreloaderComponent","myPreloaderComponent", {graphic:new KawaiiPreloader,onLoadingComplete:onLoadingComplete ,onAssetsLoadingComplete:onAssetsLoadingComplete, assetsToLoad:assetsToLoad}) as PreloaderComponent;
		}
		//------ On Loading Complete ------------------------------------
		private function onLoadingComplete():void {
			_preloaderComponent.destroy();
		}
		//------ On Asset Loading Complete ------------------------------------
		private function onAssetsLoadingComplete():void {
			dispatchEvent(new PreloaderEvent(PreloaderEvent.PRELOADER_ASSETS_LOADING_COMPLETE));
		}
	}
}