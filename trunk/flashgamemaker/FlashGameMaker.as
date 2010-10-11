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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A full copy of the license is available at http://www.gnu.org/licenses/fdl-1.3-standalone.html.
GNU General Public License v3
*
*/

package {
	import framework.Framework;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	
	/**
	* Main Class of the document.
	* <p>Instanciate the core framework.</p>
	* @see framework.Framework
	*/
	public class FlashGameMaker extends Sprite {

		public static var STAGE:Stage=null;
		public static var WIDTH:Number=400;
		public static var HEIGHT:Number=345;
		
		public function FlashGameMaker() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		// Flash Develop Compatibility
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			Security.allowInsecureDomain("*");
			STAGE=this.stage;
			var framework:Framework = new Framework();
		}
	}
}