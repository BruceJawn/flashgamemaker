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
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.add.screen{
	import flash.display.*;
	import utils.clip.*;
	/**
	* Screen Class
	* @ purpose: Interface Screen description.
	*/
	public class Screen extends Sprite {

		protected var _name:String;
		protected var _clip:MovieClip=null;
		
		public function Screen(name:String,clip:MovieClip) {
			initVar(name,clip);
			Clip.Center(clip);
			addChild(clip);
		}

		//------ Init Var ------------------------------------
		private function initVar(name:String, clip:MovieClip):void {
			_name=name;
			_clip=clip;
		}
		//------ Get Name ------------------------------------
		public function getName():String {
			return _name;
		}
		//------ ToString ------------------------------------
		public function ToString():void {
			trace(_name,_clip);
		}
	}
}