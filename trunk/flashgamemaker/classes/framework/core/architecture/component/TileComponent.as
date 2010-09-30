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
	import utils.iso.IsoPoint;
	
	import flash.display.*;
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	/**
	* Tile Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TileComponent extends GraphicComponent {

		public function TileComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Create Tile ------------------------------------
		public function createTile(k:int, j:int, i:int,tileHigh:int, tileHeight:int,tileWidth:int,tileFrame:int, textureName:String, X:int, Y:int ):void {
			if (tileFrame!=0) {
				var tileName:String="tile_"+k+"_"+j+"_"+i;
				var x:int=(tileFrame-1)% X;
				var y:int=Math.floor((tileFrame-1)/(X));
				var bitmap:Bitmap=getGraphic(textureName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(tileWidth,tileHeight+tileHigh,true,0);
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tileWidth, y * tileHeight,tileWidth,tileHeight + tileHigh), new Point(0, 0),null,null,true);
				var graphic:Bitmap=new Bitmap(myBitmapData);
				setGraphic(tileName,graphic);
				var isoPosition:IsoPoint=screenToIso(tileToScreen(k,j,i,tileHigh,tileHeight,tileWidth));
				_spatial_position=isoPosition;
			}
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen(k:int, j:int, i:int,tileHigh:int,tileHeight:int,tileWidth:int):IsoPoint {
			var point:IsoPoint = new IsoPoint();
			point.x=i*tileWidth/2;
			point.y=j*tileWidth/2;
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso(point:IsoPoint):IsoPoint {
			var isoPoint:IsoPoint = new IsoPoint();
			isoPoint.x = (point.x-point.y);
			isoPoint.y = (point.x+point.y)/2 - point.z;
			return isoPoint;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}