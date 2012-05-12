package com.aA.Mobile.UI 
{
	import com.aA.Mobile.UI.Style.aUIStyleGuide;
	import com.aA.Mobile.UI.Style.aUIStyleManager;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIComponent extends Sprite
	{
		protected var _styleGuide:aUIStyleGuide = null;
		
		public function aUIComponent() 
		{
			
		}
		
		public function get style():aUIStyleGuide {
			if (_styleGuide == null) {
				return aUIStyleManager.getInstance().getStyleCopy();
			} else {
				return _styleGuide;
			}
		}
		
		public function set style(customStyle:aUIStyleGuide):void {
			_styleGuide = customStyle;
			draw();
		}
		
		public function draw():void {
			
		}
		
	}

}