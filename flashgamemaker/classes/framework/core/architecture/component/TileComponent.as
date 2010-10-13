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
	
	import flash.display.*;
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	/**
	* Tile Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TileComponent extends GraphicComponent {

		//Tile properties
		public var _tileName:String =null;
		public var _layer:int =0;
		public var _ztile:int =0;
		public var _ytile:int =0;
		public var _xtile:int =0;
		public var _tileHigh:int = 0;
		public var _tileHeight:int = 0;
		public var _tileWidth:int = 0;
		public var _tileFrame:int = 0;
		public var _textureName:String = null;
		public var _X:int = 0;
		public var _Y:int = 0;
		public var _walkable:int = 0;
		public var _slopes:int = 0;
		public var _ladder:int = 0;
		public var _slide:int = 0;
		public var _bounce:int = 0;
		public var _teleportation:int = 0;
		public var _elevation:int = 0;
		
		public function TileComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
				createTile();
		}
		//------ Create Tile ------------------------------------
		public function createTile():void {
			if(_tileName==null){
				 _tileName="tile_"+_layer+"_"+_ztile+"_"+_ytile+"_"+_xtile;
				if (_tileFrame!=0) {
					var x:int=(_tileFrame-1)% _X;
					var y:int=Math.floor((_tileFrame-1)/(_X));
					var bitmap:Bitmap=getGraphic(_textureName) as Bitmap;
					var myBitmapData:BitmapData=new BitmapData(_tileWidth,_tileHeight+_tileHigh,true,0);
					myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * _tileWidth, y * _tileHeight,_tileWidth,_tileHeight), new Point(0, 0),null,null,true);
					var graphic:Bitmap=new Bitmap(myBitmapData);
					setGraphic(_tileName,graphic);
				}
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}