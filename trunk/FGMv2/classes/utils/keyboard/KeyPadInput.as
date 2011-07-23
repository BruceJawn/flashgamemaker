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
package utils.keyboard{
	public class KeyPadInput{
		public var isDown:Boolean;
		public var isPressed:Boolean;
		public var isReleased:Boolean;
		public var doubleClick:Boolean;
		public var shift:Boolean;
		public var ctrl:Boolean;
		public var downTicks:Number;
		public var upTicks:Number;
		public var mappedKeys:Array = new Array;
		
		public function KeyPadInput($isDown:Boolean=false,$isPressed:Boolean=false, $isReleased:Boolean=false,$doubleClick:Boolean=false, $shift:Boolean=false,$ctrl:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1,$mappedKeys:Array=null){
			initVar($isDown,$isPressed,$isReleased,$doubleClick,$shift,$ctrl,$downTicks,$upTicks,$mappedKeys);
		}
		//------ Init Var ------------------------------------
		public function initVar($isDown:Boolean=false,$isPressed:Boolean=false,$isReleased:Boolean=false,$doubleClick:Boolean=false, $shift:Boolean=false,$ctrl:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1,$mappedKeys:Array=null):void{
			isDown 		= $isDown;
			isPressed	= $isPressed;
			isReleased	= $isReleased;
			doubleClick	= $doubleClick;
			shift		= $shift;
			ctrl		= $ctrl;
			downTicks	= $downTicks;
			upTicks		= $upTicks;
			if($mappedKeys)	mappedKeys	= $mappedKeys;
		}
		
	}
}