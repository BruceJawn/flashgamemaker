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

package framework.core.system{

	import flash.events.Event;
	
	/**
	* GameEvent Class
	* @ purpose: GameEvent.
	*/
	public class GameEvent extends Event {
		public static const XML_SUCCESS:String = "Xml loading successful";
		public static const XML_FAIL:String = "Xml loading fail";
		public static const SWF_SUCCESS:String = "Swf loading successful";
		public static const SWF_PROGRESS:String = "Swf loading progress";
		public static const SWF_FAIL:String = "Swf loading fail";
		public static const COMPLETE:String = "Complete";
		public static const NAVIGATION_CHANGE:String = "Navigation Change";
		public static const MUTE:String = "Mute";
		public static const START_ENGINE:String = "Start Engine";

		public function GameEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}

		public override function clone():Event {
			return new GameEvent( type, bubbles, cancelable );
		}

		public override function toString():String {
			return formatToString( "GameEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}