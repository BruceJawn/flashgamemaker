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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.entity.*;
	
	import utils.time.Time;
	
	/**
	* Chrono Class
	* @ purpose: 
	*/
	public class ScoreComponent extends GraphicComponent {
		private var _source:Bitmap=null;
		private var _bitmap:Bitmap=null;
		private var _bitmapData:BitmapData=null;
		
		private var _score:TextField=null;
		private var _score_count:Number=1;
		private var _score_digit:Number=6;
		
		public function ScoreComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_score = new TextField();
			setFormat("Arial",30,0xFF0000);
			updateText();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------Set Format -------------------------------------
		private function setFormat(font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null):void {
			var textFormat:TextFormat=new TextFormat(font,size,color,bold,italic,underline,url,target,align);
			_score.defaultTextFormat=textFormat;
			_score.autoSize="center";
			_score.selectable=false;
		}
		//------ Restart Chrono ------------------------------------
		public function restart():void {
			_score_count = 0;
		}
		//------ Set graphic ------------------------------------
		public override function set graphic($graphic:*):void {
			createScore($graphic as Bitmap);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function =null):void {
			createScore($graphic as Bitmap);
			if($callback is Function)	$callback();
		}
		//------ Create Score ------------------------------------
		private function createScore($graphic:Bitmap=null):void {
			if(contains(_score))	removeChild(_score);
			if(_bitmapData)			_bitmapData.dispose();
			if($graphic)			_source = $graphic;	
			_bitmapData = new BitmapData(_source.width/10*_score_digit,_source.height); // We suppose that the graphic is a line of 10 digits (0,1,2,3,4,5,6,7,8,9);
			_bitmap = new Bitmap(_bitmapData);
			if(!contains(_bitmap))	addChild(_bitmap);
			actualizeScore();
		}
		//------ Get Time ------------------------------------
		private function updateText():void {
			_score.text=_score_count.toString();
		}
		//------ Actualize Score ------------------------------------
		public function actualizeScore():void {
			if(_bitmapData!=null){
				_bitmapData.lock();
				_bitmapData.fillRect(_bitmapData.rect,0);
				var count:String = _score_count.toString();
				for (var i:int=0;i<_score_digit;i++){
					var X:int = Number(count.substr(count.length-i-1,1));
					
					if(i>=count.length){
						X=0;
					}
					_bitmapData.copyPixels(_source.bitmapData, new Rectangle(X*_source.width/10,0,_source.width/10 ,_source.height), new Point((_score_digit-i-1)*_source.width/10, 0),null,null,true);
				}
				_bitmapData.unlock();
			}
		}
	}
}