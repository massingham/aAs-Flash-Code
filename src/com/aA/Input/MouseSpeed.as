package com.aA.Input 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class MouseSpeed extends Sprite
	{
		private var newY:Number = 0;
		private var oldY:Number = 0;
		public var ySpeed:Number;
		private var newX:Number = 0;
		private var oldX:Number = 0;
		public var xSpeed:Number;
		  
		public function MouseSpeed() 
		{
			this.addEventListener(Event.ENTER_FRAME, calculateMouseSpeed);
		}
		
		private function calculateMouseSpeed(e:Event):void {
			newY = mouseY;
			ySpeed = newY - oldY;
			oldY = newY;
  			
			newX = mouseX;
			xSpeed = newX - oldX;
			oldX = newX;
		}
		
		public function getYSpeed():Number {
			return ySpeed;
		}
		
		public function getXSpeed():Number {
			return xSpeed;
		}
	}

}