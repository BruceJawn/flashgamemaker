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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import framework.core.architecture.entity.*;
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;
	
	import utils.adobe.Export;
	import utils.iso.IsoPoint;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class GraphicComponent extends SimpleGraphicComponent {

		protected var graphicManager:IGraphicManager=null;
		protected var _graphic:*=null;
		protected var _path:String;
		
		public function GraphicComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			graphicManager = GraphicManager.getInstance();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphic($path:String):void {
			var callBack:Object = {onInit:onGraphicLoadingInit, onProgress:onGraphicLoadingProgress, onComplete:onGraphicLoadingComplete};
			graphicManager.loadGraphic($path, callBack);
			_path = $path;
		}
		//------ On Graphic Loading Init ------------------------------------
		protected function onGraphicLoadingInit():void {
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected function onGraphicLoadingProgress( $evt:ProgressEvent ):void {
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_graphic = $graphic;
			FlashGameMaker.AddChild($graphic,this);
		}
		//------ Create JPG ------------------------------------
		public function exportToJPG(fileName:String="image", quality:Number=90):void {
			Export.ExportJPG(this,fileName,quality);
		}
		//------ Get graphic ------------------------------------
		public function get graphic():* {
			return _graphic
		}
		//------ Set graphic ------------------------------------
		public function set graphic($graphic:*):void {
			_graphic = $graphic;
		}
		//------ Clone  ------------------------------------
		override public function clone($name:String="clone"):Component {
			var clone:GraphicComponent = _entity.entityManager.addComponentFromName(entityName,"GraphicComponent",$name) as GraphicComponent;
			clone.loadGraphic(_path);
			return clone;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}