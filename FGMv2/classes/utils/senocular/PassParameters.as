/* From Senocular 
*/
package utils.senocular{
	import flash.events.Event; 
	
	public class PassParameters{
	
		public static function AddArguments (method:Function, additionalArguments:Array):Function{
			return function($event:Event=null):void{
				if($event){	
					method.apply(null, [$event].concat(additionalArguments));
				}else{ 
					method.apply(null, additionalArguments);
				}
			}
		}
		//Example
		/*var aNum:int = 5;
		mc.addEventListener(MouseEvent.CLICK, PassParameters.AddArguments(onMouseEvent, [aNum]));
		private function onMouseEvent(e:Event,a:int):void{
			trace(a);
		} */
	}
}