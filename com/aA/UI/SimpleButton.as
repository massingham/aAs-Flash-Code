package com.aA.UI 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.aA.Text.Text;
	/**
	 * Simple Button
	 * 
	 * @author Anthony Massingham
	 * @email anthony.massingham@gmail.com
	 */
	public class SimpleButton extends Sprite
	{
		public var text:String;
		private var colour:uint;
		
		private var buttonSprite:Sprite;
		private var label:TextField;
		
		private var theWidth:Number;
		private var theHeight:Number;
		
		/**
		 * Creates a simple button
		 * 
		 * @param	w			The Minimum Width of the Button
		 * @param	h			The Minimum Height of the Button ( Width and Height will increase if text doesnt fit)
		 * @param	text		The Text
		 * @param	fontSize	The Size of the Text
		 * @param	colour		The BG Colour on Mouseover
		 */
		public function SimpleButton(w:int, h:int, text:String, fontSize:int, colour:uint) 
		{
			this.text = text;
			this.colour = colour;
			this.theWidth = w;
			this.theHeight = h;
			
			buttonSprite = new Sprite();
			addChild(buttonSprite);
			
			label = Text.getTextField(text, fontSize, 0, "CENTER");
			
			if (label.width > this.theWidth) {
				trace("width is greater");
				this.theWidth = label.width + 10;
			}
			
			if (label.height > this.theHeight) {
				this.theHeight = label.height + 10;
			}
			
			label.x = theWidth / 2 - label.width / 2;
			label.y = theHeight / 2 - label.height / 2;
			
			drawButton();
			buttonSprite.addChild(label);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, mEvent);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, mEvent);
			
			this.buttonMode = true;
		}
		
		/**
		 * Draws the button
		 * 
		 * @param	bgColour
		 * @param	fontColour
		 */
		public function drawButton(bgColour:uint = 0xFFFFFF, fontColour:uint = 0x000000):void {
			buttonSprite.graphics.clear();
			buttonSprite.graphics.beginFill(bgColour);
			buttonSprite.graphics.lineStyle(0, 0, 0.2);
			buttonSprite.graphics.drawRect(0, 0, theWidth, theHeight);
			buttonSprite.graphics.endFill();
			
			buttonSprite.graphics.lineStyle();
			
			buttonSprite.graphics.beginFill(0xFFFFFF, 0.1);
			buttonSprite.graphics.drawRect(0, 0, theWidth, theHeight / 2);
			buttonSprite.graphics.endFill();
			
			label.textColor = fontColour;
		}
		
		/**
		 * Simple event listeners.  Call MouseEvent.CLICK yourself.
		 * @param	event
		 */
		private function mEvent(event:MouseEvent):void {
			switch(event.type) {
				case "mouseOver":
				case "mouseUp":
					drawButton(colour, 0xFFFFFF);
				break;
				case "mouseDown":
					drawButton(colour - 0x111111, 0xFFFFFF);
				break;
				default:
					drawButton();
				break;
			}
		}
		
	}

}