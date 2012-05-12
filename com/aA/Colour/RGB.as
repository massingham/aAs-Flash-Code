package com.aA.Colour 
{
	/**
	 * ...
	 * @author ...
	 */
	public class RGB 
	{
		
		private var colour:uint;
		private var red:int;
		private var green:int;
		private var blue:int;
		
		public function RGB(r:Number = 0, g:Number = 0, b:Number = 0) 
		{
			Red = r;
			Green = g;
			Blue = b;
		}
		
		public function get Red():int {
			return colour >> 16;
		}
		
		public function get Green():int {
			return (colour >> 8) & 0xFF;
		}
		
		public function get Blue():int {
			return colour & 0x00FF;
		}
	
		public function changeAll(value:int):void {
			Red += value;
			Green += value;
			Blue += value;
		}
		
		public function set Red(Value:int):void {
			red = (Value > 255)?255:((Value < 0)?0:Value);
			colour = getHex(red, green, blue);
		}
		
		public function set Green(Value:int):void {
			green = (Value > 255)?255:((Value < 0)?0:Value);
			colour = getHex(red, green, blue);
		}
		
		public function set Blue(Value:int):void {
			blue = (Value > 255)?255:((Value < 0)?0:Value);
			colour = getHex(red, green, blue);
		}
		
		public function get Hex():uint {
			return colour;
		}
		
		public function set Hex(Value:uint):void {
			colour = Value;
		}
		
		public static function getHex(r:int, g:int, b:int):uint {
			return (r << 16) | (g << 8) | b;
		}
		
		public static function getRGB(colour:uint):RGB {
			var rgb:RGB = new RGB();
			rgb.Hex = colour;
			
			return rgb;
		}
		
	}

}