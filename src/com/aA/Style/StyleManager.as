package com.aA.Style 
{
	import flash.utils.Dictionary;
	/**
	 * Static class to handle style guides
	 * @author Anthony Massingham
	 */
	public class StyleManager 
	{
		private static var _instance:StyleManager;
		
		private var styles:Dictionary;
		
		public function StyleManager() 
		{
			styles = new Dictionary();
		}
		
		public static function getInstance():StyleManager {
			if (_instance == null) {
				_instance = new StyleManager();
			}
			return _instance;
		}
		
		public function addStyle(style:String, values:Array):void {
			if (styles[style] == null) {
				styles[style] = new Style(style);
			}
			trace("<STYLE> Adding " + style);
			for (var i:int = 0; i < values.length; i++) {
				styles[style].setProperty(values[i].property, values[i].value);
			}
		}
		
		public function getProperty(style:String, property:String):* {
			if (styles[style] == null) return 0;
			return styles[style].getProperty(property);
		}
		
	}

}