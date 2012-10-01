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
package data{
	import com.adobe.serialization.json.JSON;
	
	public class Data{
		public static const OBJECT_KIND_CHARACTER:int 		= 0; // (Bandit)
		public static const OBJECT_KIND_WEAPON:int 			= 1; // which can be used to slam enemies (Baseball Bat)
		public static const OBJECT_KIND_HEAVY_WEAPON:int 	= 2; // which can be thrown to knock down enemies, it slows down you movement speed (Stone)
		public static const OBJECT_KIND_PROJECTILE:int 		= 3; // of a character (Projectile)
		public static const OBJECT_KIND_THROWN_WEAPON:int	= 4; // which can be thrown to hurt an enemy (Baseball)
		
		public static const OBJECT:Object =
			{
				'1':{
					'name': 'Player','kind':0,'data':'data/Player.txt',
					'graphics':['assets/MS.png']
					}
			}
		public static const BACKGROUND:Object =
			{
				'bg':{
					'path':'assets/MSbg.png'
				}
			}
		public static const OTHER:Object =
			{
				'chrono':{
					'path':'assets/chrono.png'
				},
				'score':{
					'path':'assets/score.png'
				},
				'rpgText':{
					'path':'assets/rpgText.swf'
				},
				'statutBar':{
					'path':'assets/statutBar.swf'
				},
				'gameOverScreen':{
					'path':'assets/gameOverScreen.swf'
				}
			}
	}
}