package com.aA.Game 
{
	/**
	 * A Simple Game Timer
	 * 
	 * Runs on the Delta Time Principle
	 * 
	 * @author Anthony Massingham
	 */
	public class GameTimer 
	{
		var t:Number = 0;
		var dt:Number = 1 / 30;
		var currentTime:Number;
		
		public function GameTimer(frameRate = 30) 
		{
			dt = 1 / frameRate;
			currentTime = getCurrentTime();
		}
		
		/**
		 * Gets the delta time
		 */
		public function update():void {
			var newTime:Number = getCurrentTime();
			var frameTime = newTime-currentTime;
			currentTime = newTime;
			
			while (frameTime > 0) {
				var deltaTime:Number = Math.min(frameTime, dt);
				//integrate(t,deltaTime);
				frameTime-= deltaTime;
				t += deltaTime;
			}
			
			// render
		}
		
		public function getCurrentTime():Number {
			var d:Date = new Date();
			return d.getTime();
		}
		
	}

}