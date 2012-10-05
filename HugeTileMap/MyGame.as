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
package{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.*;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.transform.BasicTransform;
	import utils.ui.LayoutUtil;
	
	/**
	 * Bunny Mark test
	 * http://blog.iainlobb.com/2011/02/bunnymark-compiled-from-actionscript-to.html
	 */
	public class MyGame {
		private var _entityManager:IEntityManager = null;
		private var _graphicManager:IGraphicManager = null;
		
		public function MyGame() {
			_initVar();
			_initComponent();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager = EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			var entity:IEntity=_entityManager.createEntity("HugeTileMap");
			var graphicManager:IGraphicManager = GraphicManager.getInstance();
			var callBack:Object = {onComplete:_onTileSetLoaded, onCompleteParams:"HugeTileMap"};
			graphicManager.loadGraphic(Framework.root+"assets/kawaiiTileSet.png", callBack);
		}
		//------ On Tile Set Loaded -------------------------------
		private function _onTileSetLoaded($graphic:DisplayObject, $entityName:String =null):void{
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			//BasicTransform.SetRectMask(bitmapRenderComponent,10,20,Framework.width-20,Framework.height-40);
			var tileMapComponent:TileMapComponent=_entityManager.addComponentFromName($entityName,"TileMapComponent","myTileMapComponent") as TileMapComponent;
			tileMapComponent.initMap(1,1000,500, 2);
			var tileSet:Bitmap = $graphic as Bitmap;
			var bitmapData:BitmapData = BitmapTo.BitmapToBitmapData(tileSet);
			tileMapComponent.addTileLayer("1,498*10,1,499000*1,1,498*10,1",bitmapData,60,40,10,null,new IsoPoint(12,28,1));
			/*var position:Point = LayoutUtil.GetAlignPosition(tileMapComponent,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(tileMapComponent.x,tileMapComponent.y+60));
			if(tileMapComponent.height>Framework.height){	
				position.y+=(tileMapComponent.height-Framework.height)/2;
			}*/
			tileMapComponent.y+=30;
			//bitmapRenderComponent.setScrollArea(new Rectangle(0,0,tileMapComponent.x+tileMapComponent.maxWidth,tileMapComponent.y+tileMapComponent.maxHeight));
			mouseInput.start();
			//var tileMapEditorComponent:TileMapEditorComponent=entityManager.addComponentFromName($entityName,"TileMapEditorComponent","myTileMapEditorComponent", {tileMapComponent:tileMapComponent}) as TileMapEditorComponent;
			
			var systemInfoComponent:SystemInfoComponent=_entityManager.addComponentFromName($entityName,"SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
			systemInfoComponent.moveTo(5,5);
		}
	}
}