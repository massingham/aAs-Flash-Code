package com.aA.Mobile.UI.Views 
{
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
			background = new Bitmap(new BitmapData(stage.fullScreenWidth, stage.fullScreenHeight, false, backgroundColour));
			addChildAt(background, 0);
		}
	}

}