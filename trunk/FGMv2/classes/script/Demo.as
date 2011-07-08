package script{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.add.architecture.component.*;
	import framework.core.architecture.component.*;
	import framework.core.architecture.entity.*;
	
	/**
	 * Test
	 */
	public class Demo {
		
		public function Demo() {
			//EntityFactory.createBgColor("BgColor", 0x000055, 0.2);
			//EntityFactory.createBgGradientColor("BgGradientColor", GradientType.LINEAR, [0x0000FF,0xFFFFFF], [1,1], [0,255]);
			//EntityFactory.createScrollingBitmap("ScrollingBitmap","../assets/framework/game/background/bladesquad/nuage.jpg", 0, 30, new Point(1,0));
			//EntityFactory.createSystemInfo("SystemInfo",0,0);
			//EntityFactory.createTime("Time",100, 5, 0, 15);
			//EntityFactory.createGamePad("GamePad", 10,450);
			EntityFactory.create2DPlayer("2DPlayer", "../FGM.png", 90, 300, new Point(2,2),false, true,true,true);
			
			//EntityFactory.create2DPlayer("2DPlayer", "../assets/framework/game/charset/ms/MS.png", 90, 300, new Point(2,2),false, true,true,true);
			//EntityFactory.createCursor("Cursor", "../assets/cursor.swf");
		}
	}
}