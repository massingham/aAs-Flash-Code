package com.aA.Mobile.UI.Views 
{
	import com.aA.Style.StyleManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMobileView extends Sprite
	{
		protected var background:Bitmap;
		protected var backgroundColour:uint = 0xFFFFFF;
		protected var noBackground:Boolean = false;
		
		public function aUIMobileView() 
		{
			
		}
		
		/**
		 * Call init when you need it
		 * 
		 * Normally I'd place this on an 'addedtostage' listener, 
		 * but this gives greater control over how and when things are rendered
		 */
		public function init():void {			
			draw();
		}
		
		public function draw():void {
			if (noBackground) return;
			background = new Bitmap(new BitmapData(1, 1, false, backgroundColour));
			background.width = StyleManager.getInstance().getProperty("stage","stageWidth");
			background.height = StyleManager.getInstance().getProperty("stage", "stageHeight");
			addChildAt(background, 0);
		}
	}

}