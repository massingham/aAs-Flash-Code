package com.aA.Shapes 
{
	import flash.geom.Point;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Arc 
	{
		
		public static function drawStableArc(startingPoint:Point, startingAngle:Number, angle:Number, radius:Number, shape:Sprite, colour:uint = 0xFFFFFF, drawSides:Boolean = true):void {			
			var radianAngle:Number = startingAngle * (Math.PI / 180);
			
			var point1:Point = new Point();
			point1.x = startingPoint.x + Math.cos(radianAngle) * radius;
			point1.y = startingPoint.y + Math.sin(radianAngle) * radius;
			
			shape.graphics.beginFill(colour, 1);
			
			if (drawSides) {
				shape.graphics.moveTo(startingPoint.x, startingPoint.y);
				shape.graphics.lineTo(point1.x, point1.y);
			} else {
				shape.graphics.moveTo(point1.x,point1.y);
			}		
			
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
				var controlPointRadius:Number = radius / Math.cos(segmentAngle * (Math.PI / 180) / 2);
					
				controlPoint.x = startingPoint.x + Math.cos(controlPointRadians) * (controlPointRadius);
				controlPoint.y = startingPoint.y + Math.sin(controlPointRadians) * (controlPointRadius);
				shape.graphics.curveTo(controlPoint.x, controlPoint.y, xPos2, yPos2);
				
				currentAngle += segmentAngle;
				segmentRadians = (currentAngle + segmentAngle) * (Math.PI / 180);
			}
			shape.graphics.endFill();
		}
		
	}

}