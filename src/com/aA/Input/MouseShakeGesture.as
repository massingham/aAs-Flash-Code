package com.aA.Input 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class MouseShakeGesture extends EventDispatcher
	{
		private var previousXValue:Number;
		private var xCounter:int = 0;
		private var direction:int = 0;
		private var required:int;
		
		private var gestureTimer:Timer;
		
		public function MouseShakeGesture(reqShakes:int = 4)
		{
			previousXValue = 0;
			xCounter = 0;
			required = reqShakes
			
			gestureTimer = new Timer(1000, 0);
			gestureTimer.addEventListener(TimerEvent.TIMER, removeCount);
			gestureTimer.start();
		}
		
		private function removeCount(event:TimerEvent):void {
			if(xCounter>0) xCounter--;
		}
		
		public function checkXValue(inputX:Number):void {
			if (previousXValue == 0) {
				previousXValue = inputX;
			}
			
			if (inputX > previousXValue && direction == 0) {
				xCounter++;
				direction = 1;
			} else if (inputX < previousXValue && direction == 1) {
				xCounter++;
				direction = 0;
			}
			
			if (xCounter >= required) {
				dispatchEvent(new Event("shake"));
				xCounter = 0;
			}
		}
		
	}

}