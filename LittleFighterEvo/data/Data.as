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
	
	public class Data{
		public static var GAME_PARAM:Object 				= new Object;
		public static var LOCAL_LANG:String 				= "eng";//fr, eng
		public static const OBJECT_KIND_CHARACTER:int 		= 0; // (Bandit)
		public static const OBJECT_KIND_WEAPON:int 			= 1; // which can be used to slam enemies (Baseball Bat)
		public static const OBJECT_KIND_HEAVY_WEAPON:int 	= 2; // which can be thrown to knock down enemies, it slows down you movement speed (Stone)
		public static const OBJECT_KIND_SPECIAL_MOVE:int 	= 3; // of a character (Fire Ball)
		public static const OBJECT_KIND_THROWN_WEAPON:int	= 4; // which can be thrown to hurt an enemy (Baseball)
		public static const OBJECT_KIND_DATA_FILE:int 		= 5; // which contains "special data" (criminal.dat)
		public static const OBJECT_KIND_BOTTLE:int 			= 6; // which can be drunk (Beer) 
		
		public static const ITR_KIND_ATTACK:int 			= 0; //NORMAL HIT
		public static const ITR_CATCH_DANCE:int 			= 1; // Catch (Dance of Pain) 
		public static const ITR_KIND_PICK_WEAPON:int 		= 2; // Pick Weapon 
		public static const ITR_KIND_CATCH_BODY:int 		= 3; // Catch (bdy) 
		public static const ITR_KIND_FALLING:int 			= 4; // Falling 
		public static const ITR_KIND_WEAPON_STRENGTH:int 	= 5; // Weapon Strength 
		public static const ITR_KIND_SUPER_PUNCH:int 		= 6; // Super Punch
		public static const ITR_KIND_HEAL_BALL:int 			= 7; // Heal Ball
		public static const ITR_KIND_REFLECTIVE_SHIELD:int 	= 8; // Reflective Shield
		public static const ITR_KIND_SONATA_DEATH:int 		= 9; // Sonata of Death
		public static const ITR_KIND_SONATA_DEATH2:int 		= 10; // Sonata of Death 2
		public static const ITR_KIND_3D_OBJECT:int 			= 14; // 3D Objects Ccan't pass through
		public static const ITR_KIND_WHIRLWIND:int 			= 15; // Whirlwind 
		public static const ITR_KIND_WHIRLWIND2:int 		= 16; // Whirlwind 2
		
		public static const EFFECT_BLOOD:int 		= 0;
		public static const EFFECT_FIRE:int 		= 0;
		public static const EFFECT_ICE:int 			= 0;
		public static const EFFECT_POISONOUS:int 	= 0;
		public static const EFFECT_DIZZY:int 		= 0;
		public static const EFFECT_PETRIFIED:int 	= 0;
		public static var OBJECT:Object;
		public static var BACKGROUND:Object;
		public static var OTHERS:Object;
	}
}