package com.aA.Camera 
{
	import flash.geom.Point;
	import flash.media.Camera;
	/**
	 * Simple test for camera
	 * @author Anthony Massingham
	 */
	public class Camera2D 
	{
		private var stageWidth:Number = -1
		private var stageHeight:Number = -1
		private var screenWidth:Number = -1
		private var screenHeight:Number = -1
		
		public var _x:Number = 0;
		public var _y:Number = 0;
		
		public var _targetX:Number = 0;
		public var _targetY:Number = 0;
		
		private static var instance:Camera2D;
		
		public function Camera2D() 
		{
			_x = 0;
			_y = 0;
		}
		
		public function setStageDimensions(w:Number, h:Number):void {
			stageWidth = w;
			stageHeight = h;
		}
		
		public function setScreenDimensions(w:Number, h:Number):void {
			screenWidth = w;
			screenHeight = h;
		}
		
		public function init():void {
			if (stageWidth != -1 && screenWidth != -1) {
				_targetX = _x + screenWidth / 2;
				_targetY = _y + screenHeight / 2;
			}
		}
		
		public static function getInstance():Camera2D {
			if (instance == null) {
				instance = new Camera2D();
			} 
			
			return instance;
		}
		
		public function moveTo(p:Point):void {
			_x = p.x;
			_y = p.y;
			
			init();
		}
		
		public function getCameraLocation():Point {
			return new Point(_x, _y);
		}
		
		/**
		 * Centres around the inputted *REAL WORLD* coordinate
		 * @param	p
		 */
		public function lookAt(p:Point):void {
			moveTo(new Point(p.x - screenWidth / 2, p.y - screenHeight / 2));
		}
		
		/**
		 * Gets the Camera coordinates for the current Screen Point
		 * @param	point
		 * @return
		 */
		public function getCameraCoords(point:Point):Point {
			return new Point(point.x - _x, point.y - _y);
		}
		
		/**
		 * Gets the Screen coordinates for the current Camera point.
		 * @param	point
		 * @return
		 */
		public function getScreenCoords(point:Point):Point {
			return new Point(point.x + _x, point.y + _y);
		}
		
	}

}