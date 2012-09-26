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
package script.game.littleFighterEvo.data{
	import com.adobe.serialization.json.JSON;
	
	public class Data{
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
		public static const OBJECT:Object =
			{
				'1':{
					'name': 'Davis','kind':0,'data':'../classes/script/game/littleFighterEvo/data/Davis.txt',
					'graphics':['../assets/LittleFighterEvo/davis_0.png','../assets/LittleFighterEvo/davis_1.png','../assets/LittleFighterEvo/davis_2.png']
					}/*,
				'2':{
					'name': 'Henry','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Henry.txt',
					'graphics':['../assets/LittleFighterEvo/henry_0.png','../assets/LittleFighterEvo/henry_1.png','../assets/LittleFighterEvo/henry_2.png']
				},
				'3':{
					'name': 'Woody','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Woody.txt',
					'graphics':['../assets/LittleFighterEvo/woody_0.png','../assets/LittleFighterEvo/woody_1.png','../assets/LittleFighterEvo/woody_2.png']
				},
				'4':{
					'name': 'Dennis','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Dennis.txt',
					'graphics':['../assets/LittleFighterEvo/dennis_0.png','../assets/LittleFighterEvo/dennis_1.png','../assets/LittleFighterEvo/dennis_2.png']
				},
				'5':{
					'name': 'Freeze','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Freeze.txt',
					'graphics':['../assets/LittleFighterEvo/freeze_0.png','../assets/LittleFighterEvo/freeze_1.png','../assets/LittleFighterEvo/freeze_2.png']
				},
				'6':{
					'name': 'Firen','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Firen.txt',
					'graphics':['../assets/LittleFighterEvo/firen_0.png','../assets/LittleFighterEvo/firen_1.png','../assets/LittleFighterEvo/firen_2.png']
				},
				'7':{
					'name': 'Louis','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Louis.txt',
					'graphics':['../assets/LittleFighterEvo/louis_0.png','../assets/LittleFighterEvo/louis_1.png','../assets/LittleFighterEvo/louis_2.png']
				},
				'8':{
					'name': 'Rudolf','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Rudolf.txt',
					'graphics':['../assets/LittleFighterEvo/rudolf_0.png','../assets/LittleFighterEvo/rudolf_1.png','../assets/LittleFighterEvo/rudolf_2.png']
				},
				'9':{
					'name': 'John','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/John.txt',
					'graphics':['../assets/LittleFighterEvo/john_0.png','../assets/LittleFighterEvo/john_1.png','../assets/LittleFighterEvo/john_2.png']
				},
				'10':{
					'name': 'Deep','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Deep.txt',
					'graphics':['../assets/LittleFighterEvo/deep_0.png','../assets/LittleFighterEvo/deep_1.png','../assets/LittleFighterEvo/deep_2.png']
				},
				'11':{
					'name': 'Bandit','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Bandit.txt',
					'graphics':['../assets/LittleFighterEvo/bandit_0.png','../assets/LittleFighterEvo/bandit_1.png']
				},
				'12':{
					'name': 'Hunter','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Hunter.txt',
					'graphics':['../assets/LittleFighterEvo/hunter_0.png','../assets/LittleFighterEvo/hunter_1.png']
				},
				'13':{
					'name': 'Jack','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Jack.txt',
					'graphics':['../assets/LittleFighterEvo/jack_0.png','../assets/LittleFighterEvo/jack_1.png']
				},
				'14':{
					'name': 'Mark','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Mark.txt',
					'graphics':['../assets/LittleFighterEvo/mark_0.png','../assets/LittleFighterEvo/mark_1.png']
				},
				'15':{
					'name': 'Sorcerer','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Sorcerer.txt',
					'graphics':['../assets/LittleFighterEvo/sorcerer_0.png','../assets/LittleFighterEvo/sorcerer_1.png']
				},
				'16':{
					'name': 'Monk','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Monk.txt',
					'graphics':['../assets/LittleFighterEvo/monk_0.png','../assets/LittleFighterEvo/monk_1.png']
				},
				'17':{
					'name': 'Jan','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Jan.txt',
					'graphics':['../assets/LittleFighterEvo/jan_0.png','../assets/LittleFighterEvo/jan_1.png','../assets/LittleFighterEvo/jan_2.png']
				},
				'18':{
					'name': 'Knight','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Knight.txt',
					'graphics':['../assets/LittleFighterEvo/knight_0.png','../assets/LittleFighterEvo/knight_1.png','../assets/LittleFighterEvo/knight_2.png']
				},
				'19':{
					'name': 'Justin','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Justin.txt',
					'graphics':['../assets/LittleFighterEvo/justin_0.png','../assets/LittleFighterEvo/justin_1.png']
				},
				'20':{
					'name': 'Bat','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Bat.txt',
					'graphics':['../assets/LittleFighterEvo/bat_0.png','../assets/LittleFighterEvo/bat_1.png','../assets/LittleFighterEvo/bat_2.png']
				},
				'21':{
					'name': 'LouisEx','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/LouisEx.txt',
					'graphics':['../assets/LittleFighterEvo/louisEX_0.png','../assets/LittleFighterEvo/louisEX_1.png','../assets/LittleFighterEvo/louisEX_2.png']
				},
				'22':{
					'name': 'Firzen','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Firzen.txt',
					'graphics':['../assets/LittleFighterEvo/firzen_0.png','../assets/LittleFighterEvo/firzen_1.png','../assets/LittleFighterEvo/firzen_2.png']
				},
				'23':{
					'name': 'Julian','kind':0, 'data':'../classes/script/game/littleFighterEvo/data/Julian.txt',
					'graphics':['../assets/LittleFighterEvo/julian_0.png','../assets/LittleFighterEvo/julian_1.png','../assets/LittleFighterEvo/julian_2.png']
				}*/,
				'207':{
					'name': 'Davis_ball',
					'data':'../classes/script/game/littleFighterEvo/data/Davis_ball.txt',
					'graphics':['../assets/LittleFighterEvo/davis_ball.png'],
					'kind':3
				},
				'100':{
					'name': 'Stick',
					'data':'../classes/script/game/littleFighterEvo/data/Stick.txt',
					'graphics':['../assets/LittleFighterEvo/weapon0.png'],
					'kind':1
				}/*,
				'101':{
					'name': 'Hoe',
					'data':'../classes/script/game/littleFighterEvo/data/Hoe.txt',
					'graphics':['../assets/LittleFighterEvo/weapon2.png'],
					'kind':1
				},
				'120':{
					'name': 'Knife',
					'data':'../classes/script/game/littleFighterEvo/data/Knife.txt',
					'graphics':['../assets/LittleFighterEvo/weapon4.png'],
					'kind':1
				}*/,'121':{
					'name': 'BaseBall',
					'data':'../classes/script/game/littleFighterEvo/data/Baseball.txt',
					'graphics':['../assets/LittleFighterEvo/weapon5.png'],
					'kind':4
				},'151':{
					'name': 'WoodenBox',
					'data':'../classes/script/game/littleFighterEvo/data/Wooden_box.txt',
					'graphics':['../assets/LittleFighterEvo/weapon3.png'],
					'kind':2
				}
			}
		public static const BACKGROUND:Object =
			{
				'0':{
					'name': 'btf1',
					'path':'../assets/LittleFighterEvo/btf1.png',
					'kind':2
				},
				'1':{
					'name': 'forests',
					'path':['../assets/LittleFighterEvo/forests.png'],
					'kind':2
				},
				'2':{
					'name': 'forestm1',
					'path':['../assets/LittleFighterEvo/forestm1.png'],
					'kind':2
				},
				'3':{
					'name': 'forestm2',
					'path':['../assets/LittleFighterEvo/forestm2.png'],
					'kind':2
				},
				'4':{
					'name': 'forestm3',
					'path':['../assets/LittleFighterEvo/forestm3.png'],
					'kind':2
				},
				'5':{
					'name': 'forestm4',
					'path':['../assets/LittleFighterEvo/forestm4.png'],
					'kind':2
				}
			}
	}
}