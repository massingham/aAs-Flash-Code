package com.aA.Mobile.UI.Style 
{
	/**
	 * Basic Object, use in conjunction with the style manager
	 * @author Anthony Massingham
	 */
	public class aUIStyleGuide 
	{
		private var textFormatting:Object;
		private var colourScheme:aUIColourScheme;
		
		public var buttonOutlines:Boolean;
		public var cornerRadius:int;
		public var boxHeights:Number;
		
		public function aUIStyleGuide() 
		{
			colourScheme = new aUIColourScheme();
			textFormatting = new Object();
			cornerRadius = 0;
		}
		
		public function copy():aUIStyleGuide {
			var g:aUIStyleGuide = new aUIStyleGuide();
			g.setTextFormatting(textFormatting);
			var c:Object = colourScheme.getColours();
			g.setColourScheme(c);
			
			g.buttonOutlines = this.buttonOutlines;
			g.cornerRadius = this.cornerRadius;
			g.boxHeights = this.boxHeights;
			
			return g;
		}
		
		public function setTextFormatting(obj:Object):void {
			textFormatting = obj;
		}
		
		public function setColourScheme(obj:Object):void {
			colourScheme.importObject(obj);
		}  
		
		public function addTextFormattingValue(name:String, value:*):void {
			textFormatting[name] = value;
		}
		
		public function getColourScheme():aUIColourScheme {
			return colourScheme;
		}
		
		public function getColour(type:String):uint {
			return colourScheme.getColour(type);
		}
		
	}

}