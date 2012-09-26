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
package script.game.kawaiiIsland.event{
	import flash.events.Event;
	
	/**
	 * Preloader Event
	 */
	public class PreloaderEvent extends Event{
		
		public static const PRELOADER_INIT:String = "Init Loading";
		public static const PRELOADER_LOADING_COMPLETE:String = "Loading Complete";
		public static const PRELOADER_ASSETS_LOADING_COMPLETE:String = "Assets Loading Complete";
		
		public function PreloaderEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event {
			return new PreloaderEvent( type, bubbles, cancelable );
		}
		
		public override function toString():String {
			return formatToString( "PreloaderEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}