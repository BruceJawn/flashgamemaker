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
package utils.collection{

	public dynamic class List extends ArrayPlus {

		public var index:Number=0;
		public var loop:Boolean = true;
		
		public function List(...Items){
			for each(var Item:* in Items)
				this.push(Item);
		}
		
		//------ Next ------------------------------------
		public function next():void {
			if(index<length-1){
				index++;
			}else if(loop){
				index =0;
			}
		}
		//------ Prev ------------------------------------
		public function prev():void {
			if(index>0){
				index--;
			}else if(loop){
				index =length-1;
				
			}
		}
		//------ Get Current Item ------------------------------------
		public function get currentItem():* {
			return this[index];
		}
	}
}