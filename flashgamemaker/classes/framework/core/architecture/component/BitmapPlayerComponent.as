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
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class BitmapPlayerComponent extends PlayerComponent {

		private var _source:Bitmap = null;
		private var _bitmap:Bitmap = null;
		
		public function BitmapPlayerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("keyboardMove",_componentName);
			//setPropertyReference("serverMove",_componentName);
		}
		//------ Create Player ------------------------------------
		protected override function createPlayer():void {
			if(getGraphic(_playerName)!=null){
				_source=getGraphic(_playerName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(_playerWidth,_playerHeight,true,0);
				myBitmapData.copyPixels(_source.bitmapData, new Rectangle(0, 0,_playerWidth,_playerHeight), new Point(0, 0),null,null,true);
				_bitmap=new Bitmap(myBitmapData);
				setGraphic(_playerName,_bitmap);
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
				swapFrame();
		}
		//----- Swap Frame -----------------------------------
		public function swapFrame():void {
			if(_bitmap!=null && _graphic_oldFrame!= _graphic_frame){
				_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect, 0);
				var x:int=(_graphic_frame-1)% (_graphic_numFrame*_graphic_numFrame);
				var y:int=Math.floor((_graphic_frame-1)/(_graphic_numFrame*_graphic_numFrame));
				_bitmap.bitmapData.lock();
				_bitmap.bitmapData.copyPixels(_source.bitmapData, new Rectangle(x*_playerWidth,y*_playerHeight,_playerWidth,_playerHeight), new Point(0,0),null,null,true);
				_bitmap.bitmapData.unlock();
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}