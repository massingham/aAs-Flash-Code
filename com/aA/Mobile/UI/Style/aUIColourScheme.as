package com.aA.Mobile.UI.Style 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public dynamic class aUIColourScheme 
	{
		public static const COLOUR_LINE:String 			= "lineColour";
		public static const COLOUR_FILL:String 			= "fillColour";
		public static const COLOUR_DARK_FILL:String 	= "darkfillColour";
		public static const COLOUR_HIGHLIGHT:String 	= "highlightColour";
		public static const COLOUR_BUTTONTEXT:String 	= "buttonTextColour";
		public static const COLOUR_INPUTBGCOLOUR:String 	= "inputBGColour";
		
		public var lineColour:uint = 0x000000;
		public var fillColour:uint = 0xFFFFFF;
		public var highlightColour:uint = 0xCCCCCC;
		public var textColour:uint = 0x333333;
		public var buttonTextColour:uint = 0xFFFFFF;
		
		private var keyArray:Array;
		
		public function aUIColourScheme() 
		{
			keyArray = new Array();
		}
		
		public function importObject(obj:Object):void {
			for (var key:String in obj) {
				this[key] = obj[key];
				keyArray.push(key);
			}
		}
		
		public function getColour(type:String):uint {
			if (this[type] != null) {
				return this[type];
			}
			
			return 0;
		}
		
		public function getColours():Object {
			var returnobj:Object = new Object();
			
			for (var i:int = 0; i < keyArray.length; i++) {
				if(this[keyArray[i]]) returnobj[keyArray[i]] = this[keyArray[i]];
			}
			
			return returnobj;
		}
	}

}