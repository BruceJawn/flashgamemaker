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
			var entity:IEntity=_entityManager.createEntity("Entity");
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName("Entity","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("Entity","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("Entity","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var systemInfoComponent:SystemInfoComponent=_entityManager.addComponentFromName("Entity","SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
			systemInfoComponent.moveTo(5,5);
		}
		
	}
}