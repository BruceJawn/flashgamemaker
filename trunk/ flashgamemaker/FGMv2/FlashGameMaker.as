﻿/*
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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A full copy of the license is available at http://www.gnu.org/licenses/fdl-1.3-standalone.html.
    GNU General Public License v3
*
*/

package {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import framework.Framework;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	* Main Class of the document.
	* <p>Instanciate the core framework.</p>
	* @see framework.Framework
	*/
	[SWF(width=800, height=600, backgroundColor=0xFFFFFF, frameRate=30)]
	public class FlashGameMaker extends Sprite {

		private static var CLIP:Sprite=null;
		private static var STAGE:Stage=null;
		private static var NUM_CHILDREN:Number=0;
		private static var WIDTH:Number = 400;
		private static var HEIGHT:Number = 345;
		
		public function FlashGameMaker() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		// Flash Develop Compatibility
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			Security.allowInsecureDomain("*");
			CLIP=this;
			STAGE=this.stage;
			WIDTH=STAGE.stageWidth;
			HEIGHT=STAGE.stageHeight;
			var framework:Framework = new Framework();
		}
		//------ Add Child  ------------------------------------
		public static function AddChild($displayObject:DisplayObject, $container:DisplayObjectContainer=null, $layer:int = 0):DisplayObject {
			if (!$container) {
				$container = STAGE;
			}
			NUM_CHILDREN++;
			return $container.addChildAt($displayObject, $layer);
		}
		//------ Add Child  ------------------------------------
		public static function RemoveChild($displayObject:DisplayObject, $container:DisplayObjectContainer=null):DisplayObject {
			if (!$container) {
				$container = CLIP;
			}
			if ($container.contains($displayObject)) {	
				NUM_CHILDREN--;
				return $container.removeChild($displayObject);
			}
			return null;
		}
		//------ Focus  ------------------------------------
		public static function Focus():void {
			FlashGameMaker.STAGE.focus=FlashGameMaker.STAGE;
		}
		//------ Get Clip  ------------------------------------
		public static function get clip():Sprite {
			return CLIP;
		}
		//------ Get Width ------------------------------------
		public static function get width():Number {
			return WIDTH;
		}
		//------ Get Height  ------------------------------------
		public static function get height():Number {
			return HEIGHT;
		}
		//------ Get Num Children  ------------------------------------
		public static function get numChildren():Number {
			return NUM_CHILDREN;
		}
	}
}