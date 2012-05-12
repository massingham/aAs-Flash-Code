package com.aA.Text.TypewriterText 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import com.aA.Text.Text;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class TypewriterText extends Sprite
	{
		private var textArray:Array;
		private var charArray:Array;
		private var totalChars:int;
		
		private var textSprite:Sprite;
		
		private var runningTotal:int;
		private var xpos:int;
		
		private var cursor:TextField;
		private var cursorBlink:Timer;
		
		public var expectedWidth:Number = 0;
		private var size:Number
		
		public function TypewriterText(textArray:Array, size:int) 
		{
			this.size = size;
			this.textArray = textArray;
			charArray = new Array();
			
			textSprite = new Sprite();
			addChild(textSprite);
			
			totalChars = 0;
			for (var i:int = 0; i < textArray.length; i++) {				
				// textSprite.addChild(textArray[i]);
				totalChars += textArray[i].text.length;
				//totalChars ++ // Space
				
				expectedWidth += textArray[i].width;
			}
			
			cursor = Text.getTextField("_", size);
			addChild(cursor);
			
			cursorBlink = new Timer(200, 10);
			cursorBlink.addEventListener(TimerEvent.TIMER, blink);
			cursorBlink.addEventListener(TimerEvent.TIMER_COMPLETE, blinkStop);
			
			cursorBlink.start();
		}
		
		private function blink(event:TimerEvent):void {
			cursor.visible = !cursor.visible;
		}
		
		private function blinkStop(event:TimerEvent):void {
			cursor.visible = false;
		}
		
		public function renderText(speed:int = 1000):void {
			cursorBlink.stop();
			cursor.visible = true;
			
			var typeTimer:Timer = new Timer(speed, totalChars);
			runningTotal = 0;
			xpos = 0;
			typeTimer.addEventListener(TimerEvent.TIMER, click);
			typeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, done);
			
			typeTimer.start();
		}
		
		private function done(event:TimerEvent):void {
			cursorBlink.start();
		}
		
		private function click(event:TimerEvent):void {
			// determine which char we're up to
			var currentChar:int = 0;
			var currentWord:int = 0;
			var prevWords:int = 0;
			var lastChar:Boolean;
			
			mainloop: for (var i:int = 0; i < textArray.length; i++) {
				for (var n:int = 0; n < textArray[i].text.length; n++) {
					if (runningTotal == currentChar) {
						if (n == textArray[i].text.length - 1) {
							lastChar = true;
						}
						
						currentWord = i;
						
						break mainloop;
					}
					currentChar++;
				}
				
				prevWords += textArray[i].text.length;
			}
			
			var t:TextField = Text.getTextField(textArray[currentWord].text.charAt(currentChar - prevWords), size);
			t.x = xpos;
			
			xpos += t.width-3;
			textSprite.addChild(t);
			
			runningTotal++;
			
			if (lastChar && runningTotal != totalChars) {
				xpos += 5;
			}
			
			cursor.x = xpos;
		}
		
	}

}