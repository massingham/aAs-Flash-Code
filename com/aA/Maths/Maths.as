package aA.Maths 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Maths 
	{
		
		/**
		 * Returns the distance between two points
		 * @param	point1
		 * @param	point2
		 * @return
		 */
		public static function distance(point1:Point, point2:Point):Number {
			var distance:Number = Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2));
			return distance
		}
		
	}
	
}