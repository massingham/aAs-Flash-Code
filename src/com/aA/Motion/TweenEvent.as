package com.aA.Motion 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class TweenEvent extends Event
	{
		public static const TWEEN_COMPLETE:String = "TWEEN_COMPLETE";
		
		public function TweenEvent(type:String) 
		{
			super(type);
		}
		
	}

}