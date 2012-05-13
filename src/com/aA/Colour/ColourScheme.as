package com.aA.Colour 
{
	import flash.geom.ColorTransform;
	import com.aA.Colour.Colour;
	
	/**
	 * Simple class to help manage colour schemes for a whole project.
	 * My GUI Library uses this class.
	 * @author Anthony Massingham
	 */
	public class ColourScheme
	{
		public static var instance:ColourScheme;
		
		public var fill:uint;
		public var fill_Dark:uint;
		public var fill_Light:uint;
		
		public var text:uint;
		public var text_Dark:uint;
		public var text_Light:uint;
		
		public var highlight:uint;
		public var highlight_Dark:uint;
		public var highlight_Light:uint;	
		
		private var brightnessLevel:int = 60;
		
		public function ColourScheme() 
		{
			
		}
		
		public static function getInstance():ColourScheme {
			if (instance == null) {
				instance = new ColourScheme();
			}
			
			return instance;
		}
		
		/**
		 * 
		 * @param	f	Fill Colour
		 * @param	t	Text Colour
		 * @param	h	Highlight Colour
		 */
		public function setColours(f:uint, t:uint, h:uint):void {
			setFill(f);
			setText(t);
			setHighlight(h);
		}
		
		public function setBrightnessLevel(value:int):void {
			brightnessLevel = value;
		}
		
		public function setFill(c:uint):void {
			fill = c;
			fill_Dark = getDark(c);
			fill_Light = getLight(c);
			
			trace(fill);
			trace(fill_Dark);
			trace(fill_Light);
		}
		
		public function setText(c:uint):void {
			text = c;
			text_Dark = getDark(c);
			text_Light = getLight(c);
		}
		
		public function setHighlight(c:uint):void {
			highlight = c;
			highlight_Dark = getDark(c);
			highlight_Light = getLight(c);
		}
		
		private function getDark(c:uint):uint {
			var amount:Number = brightnessLevel;
			var col:Object = Colour.colorHEXtoOBJ(c);
			
			col.r = (col.r - amount < 0) ? 0 : col.r - amount;
			col.g = (col.g - amount < 0) ? 0 : col.g - amount;
			col.b = (col.b - amount < 0) ? 0 : col.b - amount;
			
			return Colour.colorOBJtoHex(col);
		}
		
		private function getLight(c:uint):uint {
			var amount:Number = brightnessLevel;
			var col:Object = Colour.colorHEXtoOBJ(c);
			
			col.r = (col.r + amount > 255) ? 255 : col.r + amount;
			col.g = (col.g + amount > 255) ? 255 : col.g + amount;
			col.b = (col.b + amount > 255) ? 255 : col.b + amount;
			
			return Colour.colorOBJtoHex(col);
		}
		
	}

}