package com.aA.UI.Themes 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Theme 
	{
		public var instance:Theme;
		
		public function Theme() 
		{
			
		}
		
		public static function getInstance():Theme {
			if (instance == null) {
				instance = new Theme();
			}
			
			return instance;
		}
		
		public static function headerArea(g:Graphics, w:Number, h:Number):void {
			
		}
		
		public static function contentArea(g:Graphics, w:Number, h:Number, primary:):void {
			
		}
		
	}

}