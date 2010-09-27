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
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;
	import utils.convert.*;

	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;

	/**
	* TileMap Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TileMapComponent extends GraphicComponent {

		private var _ressourceManager:IRessourceManager=null;
		private var _mapXml:XML=null;
		private var _mapName:String=null;
		private var _mapTexture:String=null;
		public var _mapLayer:Array=null;
		//Render properties
		public var _tileMap_width:int=0;
		public var _tileMap_height:int=0;
		public var _tileMap_high:int=0;


		public function TileMapComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_mapLayer = new Array();
		}
		//------ Load Map ------------------------------------
		public function loadMap(path:String, mapName:String):void {
			_mapName=mapName;
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			_ressourceManager.loadXml(path,mapName);
		}
		//------ On Xml Loading Successfull ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			_mapXml=_ressourceManager.getXml(_mapName);
			serializeXml();
			loadGraphicsFromPath(_mapTexture, "TileMap");
		}
		//------ Serialize Xml ------------------------------------
		private function serializeXml():void {
			_tileMap_width=_mapXml.@mapWidth;
			_tileMap_height=_mapXml.@mapHeight;
			_tileMap_high=_mapXml.@mapHigh;
			_mapTexture=_mapXml.MapTexture.path;
			for each (var layer:XML in _mapXml.MapTexture.layer) {
				var tab:Array=StringTo.Tab(layer.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
				var texture:String=layer.@texture;
				var tileHigh:int=layer.@tileHigh;
				var tileHeight:int=layer.@tileHeight;
				var tileWidth:int=layer.@tileWidth;
				var X:int=layer.@X;
				var Y:int=layer.@Y;
				_mapLayer.push({tileTable: tab,texture:texture,tileHigh:tileHigh,tileHeight:tileHeight,tileWidth:tileWidth,X:X,Y:Y});
			}
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			buildMap();
		}
		//------- Build Map -------------------------------
		private function buildMap():void {
			for (var k:int=0; k<_tileMap_high; k++) {
				for (var j:int=0; j<_tileMap_height; ++j) {
					for (var i:int=0; i<_tileMap_width; ++i) {
						createTile(k,j,i);
					}
				}
			}
		}
		//------ Create Tile ------------------------------------
		private function createTile(k:int, j:int, i:int):void {
			var tileName:String="tile_"+k+"_"+j+"_"+i;
			createEntity(tileName);
			var textureName:String=_mapLayer[0].texture;
			var tileHigh:int=_mapLayer[0].tileHigh;
			var tileHeight:int=_mapLayer[0].tileHeight;
			var tileWidth:int=_mapLayer[0].tileWidth;
			var tileFrame:int=_mapLayer[0].tileTable[k][j][i];
			if (tileFrame!=0) {
				var X:int=_mapLayer[0].X;
				var Y:int=_mapLayer[0].Y;
				var x:int=(tileFrame-1)% X;
				var y:int=Math.floor((tileFrame-1)/(X));
				var bitmap:Bitmap=getGraphic(textureName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(tileWidth,tileHeight+tileHigh,true,0);
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tileWidth, y * tileHeight,tileWidth,tileHeight + tileHigh), new Point(0, 0),null,null,true);
				var graphic:Bitmap=new Bitmap(myBitmapData);
				var tileGraphic:GraphicComponent=addComponent(tileName,"GraphicComponent");
				tileGraphic.setGraphic("tileName",graphic);
				var isoPosition:Point = screenToIso(tileToScreen(k,j,i,tileHigh,tileHeight,tileWidth));
				isoPosition.x+=_tileMap_width*(tileWidth/2-1); //Offset
				tileGraphic._spatial_position=isoPosition;
			}
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen(k:int, j:int, i:int,tileHigh:int,tileHeight:int,tileWidth:int):Point {
			var point:Point = new Point();
			point.x=i*tileWidth/2;
			point.y=j*tileWidth/2;
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso(point:Point):Point {
			var isoPoint:Point = new Point();
			isoPoint.x = (point.x-point.y);
			isoPoint.y = (point.x+point.y)/2; //-point.z
			return isoPoint;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}