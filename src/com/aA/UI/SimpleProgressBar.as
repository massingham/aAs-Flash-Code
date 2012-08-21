package com.aA.UI 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimpleProgressBar extends Sprite
	{
		
		private var percent:Number = 0;
		private var _bgColour:uint;
		private var _fgColour:uint;
		
		public function SimpleProgressBar(bgColour:uint, fgColour:uint) 
		{
			_bgColour = bgColour;
			_fgColour = fgColour;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.RESIZE, onResize);
			
			this.graphics.beginFill(_bgColour);
			this.graphics.drawRect(0, 0, 1, 1);
			this.graphics.endFill();
		}
		
		private function onResize():void {
			draw();
		}
		
		public function onProgress(event:ProgressEvent):void {
			percent = (event.bytesLoaded / event.bytesTotal);
			draw();
		}
		
		private function draw():void {
			this.graphics.clear();
			
			this.graphics.beginFill(_bgColour);
			this.graphics.drawRect(0, 0, 1, 1);
			this.graphics.endFill();
			
			this.graphics.beginFill(_fgColour);
			this.graphics.drawRect(0, 0, 1*percent, 1);
			this.graphics.endFill();
		}
	}

}