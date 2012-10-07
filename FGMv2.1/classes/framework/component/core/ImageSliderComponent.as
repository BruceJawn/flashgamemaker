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

package framework.component.core{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import framework.Framework;
	import framework.entity.*;
	
	/**
	* Image Slider Class
	* @ purpose: 
	*/
	public class ImageSliderComponent extends GraphicComponent {
		private var _list:Array = null;
		private var _bitmap:Bitmap = null;
		private var _bitmapData:BitmapData = null;
		
		public function ImageSliderComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_bitmapData = new BitmapData(100,100,true,0);
			_bitmap=new Bitmap(_bitmapData);
			Framework.AddChild(_bitmap);
		}
		//------ Init Slider ------------------------------------
		public function init($images:Array):void {
			_list = $images;
			_refresh();
		}
		//------ Add Image ------------------------------------
		public function addImage($image:Bitmap):void {
			if(!_list) _list = new Array;
			_list.push($image);
			_refresh();
		}
		//------ Refresh ------------------------------------
		private function _refresh():void {
			if(!_list || _list.length==0)	return;
			var graphic:Bitmap = _list[0];
			if(_bitmapData) _bitmapData.dispose();
			_bitmapData = new BitmapData(graphic.width,graphic.height,true,0);
			_bitmapData.copyPixels(graphic.bitmapData,graphic.bitmapData.rect,new Point);
			_bitmap.bitmapData = _bitmapData;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
	}
}