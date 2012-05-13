package com.aA.Geom
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Line
	{
		
		public static function length(startPoint:Point, endPoint:Point):Number {
			var xdist:Number = startPoint.x - endPoint.x;
			var ydist:Number = startPoint.y - endPoint.y;
			return Math.sqrt((xdist * xdist) + (ydist * ydist));
		}
		
		public static function scalar(startPoint:Point, endPoint:Point, point:Point):Number {
			var l:Number = Line.length(startPoint, endPoint);
			var s:Number = Line.length(startPoint, point);
			return (s / l);
		}
		
		public static function angle(startPoint:Point, endPoint:Point):Number {
			return Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
		}
		
		public static function degree(startPoint:Point, endPoint:Point):Number {
			return angle(startPoint, endPoint) * (180 / Math.PI);
		}
		
		public static function isParalell(start1:Point, end1:Point, start2:Point, end2:Point):Boolean {
			return Line.angle(start1, end1) == Line.angle(start2, end2);
		}
		
		public static function isPointOnLine(startPoint:Point, endPoint:Point, point:Point):Boolean {
			return (Math.abs(Line.degree(startPoint, endPoint) - Line.degree(startPoint, point)) < 0.25 && Line.length(startPoint, point) <= Line.length(startPoint, endPoint));
		}
		
		public static function projectOnLine(startPoint:Point, endPoint:Point, length:Number):Object {
			var a:Number = Line.angle(startPoint, endPoint);
			return { x:startPoint.x + Math.cos(a) * length, y:startPoint.y + Math.sin(a) * length};
		}
		
	}

}