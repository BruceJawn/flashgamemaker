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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.bitmap.BitmapCell;
	import utils.bitmap.BitmapSet;
	import utils.bitmap.BitmapGraph;
	import utils.keyboard.KeyPad;
	
	
	/**
	* BitmapAnimComponent Class
	*/
	public class BitmapAnimComponent extends Component {
		
		public function BitmapAnimComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("bitmapAnim");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "bitmapAnim") {
				updateComponent($component);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("graphic") && $component.graphic is Bitmap) {
				if($component.hasOwnProperty("bitmapSet") && $component.bitmapSet){
					if($component.hasOwnProperty("keyPad") && $component.keyPad){
						updateGraph($component)
						updateFrame($component);
					}
				}
			}
		}//------ Update Graph------------------------------------
		protected function updateGraph($component:Component):void {
			var charSet:BitmapSet = $component.bitmapSet;
			var graph:BitmapGraph = charSet.graph;
			var keyPad:KeyPad = $component.keyPad as KeyPad;
			if(keyPad.right.isDown){
				graph.anim("RIGHT");
			}else if(keyPad.left.isDown){
				graph.anim("LEFT");
			}else if(keyPad.up.isDown){
				graph.anim("UP");
			}else if(keyPad.down.isDown){
				graph.anim("DOWN");
			}
		}
		//------ Update Component------------------------------------
		protected function updateFrame($component:Component):void {
			var charSet:BitmapSet = $component.bitmapSet;
			var position:BitmapCell = charSet.position;
			var source:Bitmap = charSet.bitmap;
			var myBitmapData:BitmapData=new BitmapData(position.width,position.height,true,0);
			myBitmapData.copyPixels(source.bitmapData, new Rectangle(position.x, position.y,position.width,position.height), new Point(0, 0),null,null,true);
			if($component.graphic.bitmapData)	$component.graphic.bitmapData.dispose();//Free memory
			$component.graphic.bitmapData=myBitmapData;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}