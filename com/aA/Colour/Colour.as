package com.aA.Colour 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author ...
	 */
	public class Colour 
	{
		/**
		 * Increase or Decrease the brightness of a colour
		 * 
		 * @param	colour
		 * @param	amount
		 * @return
		 */
		public static function changeBrightness(colour:uint, amount:int):uint {
			var col:Object = Colour.colorHEXtoOBJ(colour);

			col.r = Colour.capColour(col.r, amount);
			col.g = Colour.capColour(col.g, amount);
			col.b = Colour.capColour(col.b, amount);
			
			return Colour.colorOBJtoHex(col);
			
			return colour;
		}
		
		/**
		 * Converts a colour object to a uint
		 * @param	col
		 * @return
		 */
		public static function colorOBJtoHex(col:Object):uint {
			col.r = capColour(col.r, 0);
			col.g = capColour(col.g, 0);
			col.b = capColour(col.b, 0);
			return ((col.r << 16) | (col.g << 8) | (col.b)); 
		}
		
		/**
		 * Converts a uint to a colour object
		 * @param	_rgb
		 * @return
		 */
		public static function colorHEXtoOBJ(rgb:uint):Object {
			var red:Number = ((rgb >> 16) & 0xFF);
			var green:Number = ((rgb >> 8) & 0xFF);
			var blue:Number = ((rgb) & 0xFF);
			
			return ( { r:red, g:green, b:blue } );
		}
		
		/**
		 * Caps a value to ensure it doesn't go outside 0-255
		 * @param	colour
		 * @param	amount
		 * @return
		 */
		public static function capColour(colour:Number, amount:int):Number {
			colour += amount;
			if (colour > 255) {
				colour = 255;
			} else if (colour < 0) {
				colour = 0;
			}
			return colour;
		}
			
		public static function RGBtoHSB(colour:Array):Array {
			var hue:Number;
			var sat:Number;
			var f:Number;
			var i:Number;
			var x:Number;
			var val:Number;
			var r:Number = colour[0];
			var g:Number = colour[1];
			var b:Number = colour[2];
			
			r /= 255;
			g /= 255;
			b /= 255;
			
			x = Math.min(Math.min(r, g), b);
			val = Math.max(Math.max(r, g), b);
			
			if (x == val) {
				return new Array(undefined, 0, val * 100);
			}
			
			f = (r == x)?g - b:((g == x)?b - r:r - g);
			i = (r == x) ? 3 : ((g == x) ? 5 : 1);
			
			hue = Math.floor((i - f / (val - x)) * 60) % 360;
			sat = Math.floor(((val - x) / val) * 100);
			val = Math.floor(val * 100);
			
			return (new Array(hue, sat, val));
		}
		
		public static function HSBtoRGB(hsbArray:Array):Array {
			var hue:Number = hsbArray[0] % 360;
			var sat:Number = hsbArray[1] / 100;
			var bri:Number = hsbArray[2] / 100;
			
			var i:int;
			var f:Number, p:Number, q:Number, t:Number;
			var r:Number, g:Number, b:Number;
			
			if (sat == 0) {
				return [Math.round(bri * 255), Math.round(bri * 255), Math.round(bri * 255)];
			} else {
				hue /= 60;
				
				i = Math.floor(hue);
				f = hue - i;
				p = bri * (1 - sat);
				q = bri * (1 - sat * f);
				t = bri * (1 - sat * (1 - f));
				
				switch(i) {
					case 0:
						r = bri;
						g = t;
						b = p;
					break;
				case 1:
						 r = q;
						g = bri;
						b = p;
					break;
				case 2:
						r = p;
						g = bri;
						b = t;
					break;
					case 3:
						r = p;
						g = q;
						b = bri;
					break;
				case 4:
						r = t;
						g = p;
						b = bri;
					break;
				default:
						r = bri;
						g = p;
						b = q;
					break;
				}
				
				return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
			}
		}
		
		public static function getSafeColour(colour:Array, sCap:Number = 10, bCap:Number = 90):Array {
			var hsb:Array = Colour.RGBtoHSB(colour);
			if (hsb[1] < sCap && hsb[2] > bCap) {
				if (hsb[1] < sCap) {
					hsb[1] = sCap;
				}
				if (hsb[2] > bCap) {
					hsb[2] = bCap;
				}
				if (hsb[0] == null) {
					hsb[0] = 1;
				}
				hsb = capHSB(hsb);
				trace(hsb);
				return Colour.HSBtoRGB(hsb);
			} else {
				return colour;
			}
		}
		
		public static function capHSB(val:Array):Array {
			if (val[0] > 360) {
				val[0] = 360;
			} else if (val[0] < 0) {
				val[0] = 0;
			}
			if (val[1] > 100) {
				val[1] = 100;
			} else if (val[1] < 0) {
				val[1] = 0;
			}
			if (val[2] > 100) {
				val[2] = 100;
			} else if (val[2] < 0) {
				val[2] = 0;
			}
			return val;
		}
	}

}