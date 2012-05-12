package com.aA.Motion 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class StaticMovement 
	{
		
		public static function spin(item:DisplayObject, speed:Number):void {
			item.addEventListener(Event.ENTER_FRAME, spinUpdate);
		}
		
	}

}