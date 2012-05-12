package com.aA.Motion 
{
	import flash.display.DisplayObject;
	/**
	 * A Simple Class for Handling Tweens
	 * Similar to Tweenmax/Tweenlite etc, but they need a license.  So I made my own.  Go me.
	 * @author Anthony Massingham
	 */
	public class SimpleTween 
	{
		
		
		/**
		 * 
		 * @param	object
		 * @param	properties
		 * @param	speed
		 */
		public function SimpleTween(object:DisplayObject, properties:Object, speed:int):void {
			
		}
		/**
		 * Tween To
		 * 
		 * @param	object
		 * @param	properties
		 * @param	speed
		 */
		public static function tweenTo(object:DisplayObject, properties:Object, speed:int):void {
			return new SimpleTween(object, properties, speed);
		}
		
		//public static function tweenFrom(object:DisplayObject, properties:Object, speed:int):void {
		//	return new SimpleTween(object, properties, speed);
		//}
	}

}