﻿/*
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
package utils.adobe{

	import flash.external.ExternalInterface;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.net.*;

	public class Export {

		public static function ExportJPG(clip:DisplayObject, fileName:String, quality:Number=90) {
			var jpgSource:BitmapData=new BitmapData(clip.width,clip.height);
			jpgSource.draw(clip);
			var jpgEncoder:JPGEncoder=new JPGEncoder(quality);
			var jpgStream:ByteArray=jpgEncoder.encode(jpgSource);
			var header:URLRequestHeader=new URLRequestHeader("Content-type","application/octet-stream");
			//Make sure to use the correct path to jpg_encoder_download.php
			try {
				var domain:String=ExternalInterface.call("window.location.href.toString");
				domain=domain.substring(0,domain.lastIndexOf("/",domain.length-1)+1);
				var jpgURLRequest:URLRequest=new URLRequest(domain+"/php/jpg_encoder_download.php?name="+fileName+".jpg");
				jpgURLRequest.requestHeaders.push(header);
				jpgURLRequest.method=URLRequestMethod.POST;
				jpgURLRequest.data=jpgStream;
				var jpgURLLoader:URLLoader = new URLLoader();
				navigateToURL(jpgURLRequest, "_blank");
			} catch (e:Error) {
				trace(e);
			}
		}
	}
}