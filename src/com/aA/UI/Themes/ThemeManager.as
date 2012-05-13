package com.aA.UI.Themes 
{
	/**
	 * Theme Manager Singleton
	 * @author Anthony Massingham
	 */
	public class ThemeManager 
	{
		// List of themes
		public static var THEME_DEFAULT:int = 0;
		// List of themes
		
		public var instance:ThemeManager;
		
		public var theme:Theme;
		
		public function ThemeManager() 
		{
			// DONT USE THIS
		}
		
		public static function getInstance():ThemeManager {
			if (instance == null) {
				instance = new ThemeManager();
			}
			
			return instance;
		}
		
		public static function setTheme(themeid:int):void {
			theme = getTheme(themeid);
		}
		
		public static function getTheme(id):Theme {
			switch(id) {
				default:
					return DefaultTheme.instance();
				break;
			}
		}
		
	}

}