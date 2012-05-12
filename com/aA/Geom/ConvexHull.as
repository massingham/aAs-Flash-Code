package com.aA.Geom 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ConvexHull
	{
		
		// Current implementation ... using "Graham Scan" 
		
		public static function grahamScan2D(points:Array):Array {
			var sortedPonts:Array = ConvexHull.sortC(ConvexHull.bottomRight, points);
			
			var H:Array = new Array(sortedPonts[1], sortedPonts[0]);
			var i:Number = 2;
			var numPoints:int = sortedPonts.length;
			
			while (i < numPoints) {
				if(H[0] != null && H[1] != null){
					if (ConvexHull.isLeft( H[0], H[1], sortedPonts[i]) <= 0) {
						H.unshift(sortedPonts[i]);
						i++
					} else {
						H.splice(0, 1);
					}
				} else {
					H.unshift(sortedPonts[i]);
					i++;
				}
			}
			H.push(H[0]);
			return H;
		}
		
		public static function isLeft(P0:Point, P1:Point, P2:Point):Number {
			return (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y);
		}
		
		public static function sortC(start:Function, points:Array):Array {
			sortCC(start, points).reverse();
			points.unshift(points.pop());
			return points;
		}
		
		public static function sortCC(start:Function, points:Array):Array {
			var idx:Number = start(points);
			var point:Point = points[idx];
			var same:Array = new Array();
			points.sort(function(a:Point, b:Point):int {
				var aR:Number = Line.angle(point, a);
				var bR:Number = Line.angle(point, b);
				if (aR > bR) {
					return -1;
				} else if (aR < bR) {
					return 1;
				} else {
					same.push(a);
					return 0;
				}
			});
			
			Array2.removeItems(points, same);
			return points;
		}
		
		public static function bottomRight(p:Array):Number {
			var idx:Number = 0;
			for (var i:int = 0; i < p.length; i++) {
				var pt:Point = p[i];
				if ( pt.y > p[idx].y || (pt.y >= p[idx].y && pt.x > p[idx].x) ) {
					idx = i;
				}
			}
			return idx;
		}
		
	}

}