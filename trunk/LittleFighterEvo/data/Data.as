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
		public static const OBJECT:Object =
			{
				'1':{
					'name': 'Davis','kind':0,'data':'data/Davis.txt',
					'graphics':['assets/davis_0.png','assets/davis_1.png','assets/davis_2.png'],
					'face':'assets/davis_f.png'	,'small':'assets/davis_s.png'	
				},
				'2':{
					'name': 'Henry','kind':0, 'data':'data/Henry.txt',
					'graphics':['assets/henry_0.png','assets/henry_1.png','assets/henry_2.png'],
					'face':'assets/henry_f.png','small':'assets/henry_s.png'
				},
				'3':{
					'name': 'Woody','kind':0, 'data':'data/Woody.txt',
					'graphics':['assets/woody_0.png','assets/woody_1.png','assets/woody_2.png'],
					'face':'assets/woody_f.png','small':'assets/woody_s.png'
				},
				'4':{
					'name': 'Dennis','kind':0, 'data':'data/Dennis.txt',
					'graphics':['assets/dennis_0.png','assets/dennis_1.png','assets/dennis_2.png'],
					'face':'assets/dennis_f.png','small':'assets/dennis_s.png'
				},
				'5':{
					'name': 'Freeze','kind':0, 'data':'data/Freeze.txt',
					'graphics':['assets/freeze_0.png','assets/freeze_1.png','assets/freeze_2.png'],
					'face':'assets/freeze_f.png','small':'assets/freeze_s.png'
				},
				'6':{
					'name': 'Firen','kind':0, 'data':'data/Firen.txt',
					'graphics':['assets/firen_0.png','assets/firen_1.png','assets/firen_2.png'],
					'face':'assets/firen_f.png','small':'assets/firen_s.png'
				}/*,
				'7':{
					'name': 'Louis','kind':0, 'data':'data/Louis.txt',
					'graphics':['assets/louis_0.png','assets/louis_1.png','assets/louis_2.png'],
					'face':'assets/louis_f.png','small':'assets/louis_s.png'
				},
				'8':{
					'name': 'Rudolf','kind':0, 'data':'data/Rudolf.txt',
					'graphics':['assets/rudolf_0.png','assets/rudolf_1.png','assets/rudolf_2.png'],
					'face':'assets/rudolf_f.png','small':'assets/rudolf_s.png'
				},
				'9':{
					'name': 'John','kind':0, 'data':'data/John.txt',
					'graphics':['assets/john_0.png','assets/john_1.png','assets/john_2.png'],
					'face':'assets/john_f.png','small':'assets/john_s.png'
				},
				'10':{
					'name': 'Deep','kind':0, 'data':'data/Deep.txt',
					'graphics':['assets/deep_0.png','assets/deep_1.png','assets/deep_2.png'],
					'face':'assets/deep_f.png','small':'assets/deep_s.png'
				},
				'11':{
					'name': 'Justin','kind':0, 'data':'data/Justin.txt',
					'graphics':['assets/justin_0.png','assets/justin_1.png'],
					'face':'assets/justin_f.png','small':'assets/justin_s.png'
				},
				'12':{
					'name': 'Bat','kind':0, 'data':'data/Bat.txt',
					'graphics':['assets/bat_0.png','assets/bat_1.png','assets/bat_2.png'],
					'face':'assets/bat_f.png','small':'assets/bat_s.png'
				},
				'13':{
					'name': 'Bandit','kind':0, 'data':'data/Bandit.txt',
					'graphics':['assets/bandit_0.png','assets/bandit_1.png']
				},
				'14':{
					'name': 'Hunter','kind':0, 'data':'data/Hunter.txt',
					'graphics':['assets/hunter_0.png','assets/hunter_1.png']
				},
				'15':{
					'name': 'Jack','kind':0, 'data':'data/Jack.txt',
					'graphics':['assets/jack_0.png','assets/jack_1.png']
				},
				'16':{
					'name': 'Mark','kind':0, 'data':'data/Mark.txt',
					'graphics':['assets/mark_0.png','assets/mark_1.png']
				},
				'17':{
					'name': 'Sorcerer','kind':0, 'data':'data/Sorcerer.txt',
					'graphics':['assets/sorcerer_0.png','assets/sorcerer_1.png']
				},
				'18':{
					'name': 'Monk','kind':0, 'data':'data/Monk.txt',
					'graphics':['assets/monk_0.png','assets/monk_1.png']
				},
				'19':{
					'name': 'Jan','kind':0, 'data':'data/Jan.txt',
					'graphics':['assets/jan_0.png','assets/jan_1.png','assets/jan_2.png']
				},
				'20':{
					'name': 'Knight','kind':0, 'data':'data/Knight.txt',
					'graphics':['assets/knight_0.png','assets/knight_1.png','assets/knight_2.png']
				},
				'21':{
					'name': 'LouisEx','kind':0, 'data':'data/LouisEx.txt',
					'graphics':['assets/louisEX_0.png','assets/louisEX_1.png','assets/louisEX_2.png']
				},
				'22':{
					'name': 'Firzen','kind':0, 'data':'data/Firzen.txt',
					'graphics':['assets/firzen_0.png','assets/firzen_1.png','assets/firzen_2.png']
				},
				'23':{
					'name': 'Julian','kind':0, 'data':'data/Julian.txt',
					'graphics':['assets/julian_0.png','assets/julian_1.png','assets/julian_2.png'],
					'face':'assets/julian_f.png'
				}*/,
				'207':{
					'name': 'Davis_ball',
					'data':'data/Davis_ball.txt',
					'graphics':['assets/davis_ball.png'],
					'kind':3
				},
				'210':{
					'name': 'Firen_ball',
					'data':'data/Firen_ball.txt',
					'graphics':['assets/Firen_ball.png'],
					'kind':3
				},
				'100':{
					'name': 'Stick',
					'data':'data/Stick.txt',
					'graphics':['assets/weapon0.png'],
					'kind':1
				}/*,
				'101':{
					'name': 'Hoe',
					'data':'data/Hoe.txt',
					'graphics':['assets/weapon2.png'],
					'kind':1
				},
				'120':{
					'name': 'Knife',
					'data':'data/Knife.txt',
					'graphics':['assets/weapon4.png'],
					'kind':1
				}*/,'121':{
					'name': 'BaseBall',
					'data':'data/Baseball.txt',
					'graphics':['assets/weapon5.png'],
					'kind':4
				},'151':{
					'name': 'WoodenBox',
					'data':'data/Wooden_box.txt',
					'graphics':['assets/weapon3.png'],
					'kind':2
				}
			}
		public static const BACKGROUND:Object =
			{
				'0':{
					'name': 'btf1',
					'path':'assets/btf1.png',
					'kind':2
				},
				'1':{
					'name': 'forests',
					'path':['assets/forests.png'],
					'kind':2
				},
				'2':{
					'name': 'forestm1',
					'path':['assets/forestm1.png'],
					'kind':2
				},
				'3':{
					'name': 'forestm2',
					'path':['assets/forestm2.png'],
					'kind':2
				},
				'4':{
					'name': 'forestm3',
					'path':['assets/forestm3.png'],
					'kind':2
				},
				'5':{
					'name': 'forestm4',
					'path':['assets/forestm4.png'],
					'kind':2
				}
			}
		public static const OTHERS:Object = {
			'multilang':'data/Multilang.txt',
			'keyConfig':'data/keyConfig.txt',
			'random':'assets/random.jpg',
			'pressAttackToJoin':'assets/pressAttackToJoin.jpg',
			'main_mp3':'assets/main.mp3',
			'stage1_mp3':'assets/stage1.mp3',
			'stage2_mp3':'assets/stage2.mp3'
		}
	}
}