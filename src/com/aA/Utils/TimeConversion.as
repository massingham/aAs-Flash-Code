package com.aA.Utils 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class TimeConversion
	{
		
		public static function milliToDay(milliseconds:Number):Number {
			var val:Number = milliseconds;
			
			// mm - s
			val /= 1000;
			
			// s - m
			val /= 60;
			
			// m - h
			val /= 60;
			
			// h - d
			val /= 24;
			
			return Math.round(val);
		}
		
	}

}