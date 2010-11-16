package com.aA.Colour 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author ...
	 */
	public class Colour 
	{
		public static function changeBrightness(colour:uint, value:Number):uint {
			var c:RGB = RGB.getRGB(colour);
			
			//c.Blue = c.Blue + value;
			//c.Green = c.Green + value;
			//c.Red = c.Red + value;
			
			//c.changeAll(0);
			
			return RGB.getHex(c.Red + value, c.Green + value, c.Blue+value);
		}
	}

}