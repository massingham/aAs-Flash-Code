package com.aA.UI 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.aA.Text.Text;
	import com.aA.Colour.ColourScheme;
	/**
	 * Simple Button
	 * 
	 * @author Anthony Massingham
	 * @email anthony.massingham@gmail.com
	 */
	public class SimpleButton extends Sprite
	{	
		protected var text:String;
		protected var buttonSprite:Sprite;
		protected var label:TextField;
		
		private var theWidth:Number;
		private var theHeight:Number;
		
		private var backgroundColour:uint;
		private var fontColour:uint;
		private var colourScheme:ColourScheme;
		
		private var useColourScheme:Boolean;
		
		/**
		 * Creates a simple button
		 * 
		 * @param	w			The Minimum Width of the Button
		 * @param	h			The Minimum Height of the Button ( Width and Height will increase if text doesnt fit)
		 * @param	text		The Text
		 * @param	fontSize	The Size of the Text
		 * @param	colour		The BG Colour on Mouseover
		 */
		public function SimpleButton(w:int, h:int, text:String, fontSize:int, _backgroundColour:uint = 1, _fontColour:uint = 1) 
		{
			this.text = text;
			this.theWidth = w;
			this.theHeight = h;
			colourScheme = ColourScheme.getInstance();
			
			useColourScheme = false;
			
			if (_backgroundColour == 1) {
				useColourScheme = true;
			} else {
				this.backgroundColour = _backgroundColour;
			}
			
			if (_fontColour == 1) {
				useColourScheme = true;
			} else {
				this.fontColour = _fontColour;
			}
			
			trace("COLOUR SCHEME : " +useColourScheme)
			
			buttonSprite = new Sprite();
			addChild(buttonSprite);
			
			label = Text.getTextField(text, fontSize, 0, "CENTER");
			
			if (label.width > this.theWidth) {
				this.theWidth = label.width + 10;
			}
			
			if (label.height > this.theHeight) {
				this.theHeight = label.height + 10;
			}
			
			label.x = theWidth / 2 - label.width / 2;
			label.y = theHeight / 2 - label.height / 2;
			
			drawButton(MouseEvent.MOUSE_OUT);
			buttonSprite.addChild(label);
			
			this.name = text;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, mEvent);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, mEvent);
			
			this.buttonMode = true;
		}
		
		public function setLabel(s:String):void {
			label.text = s;
		}
		
		public function centreLabel():void {
			label.x = theWidth / 2 - label.width / 2;
			label.y = theHeight / 2 - label.height / 2;
		}
		
		public function disable():void {
			this.buttonMode = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, mEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mEvent);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mEvent);
			this.removeEventListener(MouseEvent.MOUSE_UP, mEvent);
			
			drawButton(MouseEvent.MOUSE_OUT);
			
			this.alpha = 0.5;
		}
		
		public function enable():void {
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, mEvent);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, mEvent);
			
			drawButton(MouseEvent.MOUSE_OUT);
			
			this.alpha = 1;
		}
		
		/**
		 * Draws the button
		 * 
		 * @param	bgColour
		 * @param	fontColour
		 */
		public function drawButton(state:String):void {
			buttonSprite.graphics.clear();
			
			switch(state) {
				case MouseEvent.MOUSE_DOWN:
					if (useColourScheme) {
						buttonSprite.graphics.beginFill(colourScheme.fill_Dark);
						buttonSprite.graphics.lineStyle(0, colourScheme.fill_Dark);
						label.textColor = colourScheme.text;
					} else {
						buttonSprite.graphics.beginFill(backgroundColour);
						buttonSprite.graphics.lineStyle(0, fontColour);
						label.textColor = fontColour;
					}
				break;
				case MouseEvent.MOUSE_OUT:
					if (useColourScheme) {
						buttonSprite.graphics.beginFill(colourScheme.fill);
						buttonSprite.graphics.lineStyle(0, colourScheme.fill_Dark);
						label.textColor = colourScheme.text;
					} else {
						buttonSprite.graphics.beginFill(backgroundColour);
						buttonSprite.graphics.lineStyle(0, fontColour);
						label.textColor = fontColour;
					}
				break;
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.MOUSE_UP:
					if (useColourScheme) {
						buttonSprite.graphics.beginFill(colourScheme.fill_Light);
						buttonSprite.graphics.lineStyle(0, colourScheme.fill_Dark);
						label.textColor = colourScheme.text;
					} else {
						buttonSprite.graphics.beginFill(backgroundColour);
						buttonSprite.graphics.lineStyle(0, fontColour);
						label.textColor = fontColour;
					}
				break;
			}
			
			buttonSprite.graphics.drawRect(0, 0, theWidth, theHeight);
			buttonSprite.graphics.endFill();
		}
		
		/**
		 * Simple event listeners.  Call MouseEvent.CLICK yourself.
		 * @param	event
		 */
		private function mEvent(event:MouseEvent):void {
			drawButton(event.type);
		}
		
	}

}