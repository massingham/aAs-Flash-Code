package com.aA.Mobile.UI.Style 
{
	import com.aA.Mobile.UI.Style.aUIColourScheme;
	import com.aA.Mobile.UI.Style.aUIStyleGuide;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIStyleManager 
	{		
		private static var _instance:aUIStyleManager;
		
		private var globalStyleGuide:aUIStyleGuide;
		
		public function aUIStyleManager() 
		{
			globalStyleGuide = new aUIStyleGuide();
		}
		
		public static function getInstance():aUIStyleManager {
			if (_instance == null) {
				_instance = new aUIStyleManager();
			}
			
			return _instance;
		}
		
		public function getStyleCopy():aUIStyleGuide {
			return globalStyleGuide.copy();
		}
		
		public function getGlobalStyle():aUIStyleGuide {
			return globalStyleGuide;
		}
		
		public function setTextFormatting(obj:Object):void {
			globalStyleGuide.setTextFormatting(obj);
		}
		
		public function set cornerRadius(val:int):void {
			globalStyleGuide.cornerRadius = val;
		}
		
		public function get cornerRadius():int {
			return globalStyleGuide.cornerRadius;
		}
		
		public function setColourScheme(obj:Object):void {
			globalStyleGuide.setColourScheme(obj);
		}
		
		public function addTextFormattingValue(name:String, value:*):void {
			globalStyleGuide.addTextFormattingValue(name, value);
		}
		
		public function getColours():aUIColourScheme {
			return globalStyleGuide.getColourScheme();
		}
		
		public function getColour(type:String):uint {
			return globalStyleGuide.getColour(type);
		}
	}

}