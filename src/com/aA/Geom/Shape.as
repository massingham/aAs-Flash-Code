package com.aA.Geom 
{
	import flash.geom.Point;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Shape 
	{
		
		/**
		 * Draws an arc.
		 * 
		 * @param	startingPoint
		 * @param	startingAngle
		 * @param	angle
		 * @param	radius
		 * @param	shape
		 * @param	colour
		 * @param	square90
		 * @param	drawSides
		 * @param	colourBacking
		 * @param	alphaValue
		 * @return
		 */
		public static function drawStableArc(startingPoint:Point, startingAngle:Number, angle:Number, radius:Number, shape:Sprite, colour:uint = 0xFFFFFF, square90:Boolean = true, drawSides:Boolean = true, colourBacking:Number = 0, alphaValue:Number = 1 ):Point {			
			var radianAngle:Number = startingAngle * (Math.PI / 180);
			if (angle == 90 && square90) {
				radius = radius / 2;
			}
			
			var point1:Point = new Point();
			point1.x = startingPoint.x + Math.cos(radianAngle) * radius;
			point1.y = startingPoint.y + Math.sin(radianAngle) * radius;
			
			shape.graphics.beginFill(colour, alphaValue);
			if (drawSides) {
				shape.graphics.moveTo(startingPoint.x, startingPoint.y) 
			} else {
				shape.graphics.moveTo(point1.x,point1.y);
			}
			
			//shape.graphics.lineStyle(2,colourBacking);
			
			if (drawSides) {
				shape.graphics.lineTo(point1.x, point1.y);
			}
			//shape.graphics.lineStyle(0,colourBacking);
			
			var numSegments:Number = Math.ceil(Math.abs(angle) / 45);
			var segmentAngle:Number = angle / numSegments;
			
			var currentAngle:Number = startingAngle;
			var segmentRadians:Number = (currentAngle + segmentAngle) * (Math.PI / 180);
			
			var angleMid:Number = 0;
			var controlPoint:Point = new Point(0, 0);
			var xPos2:Number = 0;
			var yPos2:Number = 0;
			
			for (var j:int = 0; j < numSegments; j++) {				
				xPos2 = startingPoint.x + Math.cos(segmentRadians) * radius;
				yPos2 = startingPoint.y + Math.sin(segmentRadians) * radius;
				var controlPointRadians:Number = (currentAngle + (segmentAngle / 2)) * (Math.PI / 180);
				var controlPointRadius:Number = radius / Math.cos(segmentAngle * (Math.PI/180) / 2);
				
				controlPoint.x = startingPoint.x + Math.cos(controlPointRadians) * (controlPointRadius);
				controlPoint.y = startingPoint.y + Math.sin(controlPointRadians) * (controlPointRadius);
				shape.graphics.curveTo(controlPoint.x, controlPoint.y, xPos2, yPos2);
				
				currentAngle += segmentAngle;
				segmentRadians = (currentAngle + segmentAngle) * (Math.PI / 180);
			}
			
			//shape.graphics.lineStyle(2, colourBacking, alphaValue);
			if (drawSides) {
				shape.graphics.lineTo(startingPoint.x, startingPoint.y);
			}
			//shape.graphics.lineStyle(0,colour,alphaValue);
			shape.graphics.endFill();
			
			// calculate midpoint
			var midPoint:Point = new Point();
			
			radianAngle = (startingAngle + (angle / 2)) * (Math.PI / 180);
			
			midPoint.x = startingPoint.x + Math.cos(radianAngle) * (radius + 15);
			midPoint.y = startingPoint.y + Math.sin(radianAngle) * (radius + 15);
			
			return midPoint;
		}
		
	}

}