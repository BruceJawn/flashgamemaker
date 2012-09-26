/* From Senocular 
* http://www.kirupa.com/forum/showthread.php?223798-ActionScript-3-Tip-of-the-Day&p=1939945
*/
package utils.senocular{
	
	public class CloneDisplayObject{
		
		public static function CloneDisplayObject( $source:DisplayObject):DisplayObject {
			var targetClass:Class = Object($source).constructor;
			var duplicate:DisplayObject = new targetClass();
			duplicate.transform = $source.transform;
			duplicate.filters = $source.filters;
			duplicate.cacheAsBitmap = $source.cacheAsBitmap;
			duplicate.opaqueBackground = $source.opaqueBackground;
			if ($source.scale9Grid) {
				var rect:Rectangle = $source.scale9Grid;
				duplicate.scale9Grid = rect;
			}
			return duplicate;
		}
	}
}
}