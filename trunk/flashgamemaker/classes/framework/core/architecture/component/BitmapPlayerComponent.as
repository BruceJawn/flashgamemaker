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
	import flash.geom.*;
	
	/**
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class BitmapPlayerComponent extends PlayerComponent {

		public function BitmapPlayerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Create Player ------------------------------------
		protected override function createPlayer():void {
				var bitmap:Bitmap=getGraphic(_playerName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(_playerWidth,_playerHeight,true,0);
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(0, 0,_playerWidth,_playerHeight), new Point(0, 0),null,null,true);
				var graphic:Bitmap=new Bitmap(myBitmapData);
				setGraphic(_playerName,graphic);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}