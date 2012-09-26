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
package utils.users{
	import script.game.kawaiiIsland.data.UserInfo;

	public class User{
		
		public var id:String;
		public var firstName:String = "";		
		public var lastName:String = "";
		public var fullName:String = "";
		public var nickName:String = "";
		public var gender:uint;
		public var dateOfBirth:Date;
		public var geoip:String = "";//two char country code passed in from HTML
		public var xp:int;
		public var xpLevel:int;
		public var coins:int;
		public var credits:int;
		public var snUid:String;			// Sometimes social networks have their own String UID which we convert to an Int.  "id" is our own int, but "snUid" is the real one.
		public var thirdPartyId:String;		// ID used when we communicate with third-parties. Is required on Facebook.
		public var friends:Vector.<UserInfo> = new Vector.<UserInfo>;
		
		public function User($idT:String) {
			id = $idT;
			snUid = id;
		}
		public function setInfo( info:Object ):void {
			if (info.id)			id = info.id;
			if (id && !snUid) 		snUid = id;
			
			if (info.hz) 			snUid = info.hz;
			if (info.sn_uid) 		snUid = info.sn_uid;
			
			if (info.fn)			firstName = info.fn;
			if (info.ln)			lastName = info.ln;
			if (info.nn)			nickName = info.nn;
			
			if (info.n)				fullName = info.n;
			else					fullName = firstName + " " + lastName;
			
			if (info.cr)			credits = parseInt(info.cr);
			if (info.co)			coins = parseInt(info.co);
			if (info.xp)			xp = parseInt(info.xp);
		}
	}
}