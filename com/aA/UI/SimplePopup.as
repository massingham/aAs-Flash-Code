package com.aA.UI 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import flash.display.GradientType;
	
	import com.aA.Text.Text;
	import com.aA.Colour.Colour;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimplePopup extends Sprite
	{
		private var boxSprite:Sprite;
		
		private var theWidth:Number;
		private var theHeight:Number;
		private var headerColour:uint;
		private var headerHeight:int;
		private var headerSprite:Sprite;
		
		private var gradient:Boolean;
		 
		/**
		 * Simple Popup Box, Can be used for dialog boxes, menu items, whatevs.
		 * You can either set Text as the header, or a sprite.
		 * 
		 * @param	w
		 * @param	h
		 * @param	header
		 * @param	headerColour
		 */
		public function SimplePopup(w:int, h:int, headerColour:uint = 0x8F8F8F, gradient:Boolean = false, headerHeight:int = 50, header:* = "Popup Box", headerSize:int = 25) 
		{
			this.theWidth = w;
			this.theHeight = h;
			this.headerColour = headerColour;
			this.headerHeight = headerHeight;
			this.gradient = gradient;
			
			// Determine the nature of the header image...
			headerSprite = new Sprite();
			if (typeof header == "object") {
				// sprite
				headerSprite = header;
				if (this.headerHeight < headerSprite.height) headerHeight = headerSprite.height + 10;
			} else {
				// string
				var textField:TextField = Text.getTextField(header, headerSize, 0xFFFFFF, "LEFT");
				headerSprite.addChild(textField);
			}
			
			drawPopup();
			addChild(headerSprite);
			headerSprite.y = headerHeight / 2 - headerSprite.height / 2;
			headerSprite.x = 10;
		}
		
		public function drawPopup():void {
			boxSprite = new Sprite();
			addChild(boxSprite);
			
			// height does not include header height.  Draw the header first
			var g:Graphics = boxSprite.graphics;
			
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, 0, theWidth, theHeight + headerHeight);
			g.endFill();
			
			if(gradient){
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(theWidth, headerHeight, Math.PI / 2, 0, 0);
				
				g.beginGradientFill(GradientType.LINEAR, [headerColour, Colour.changeBrightness(headerColour, -40)], [1, 1], [0, 255], gradientMatrix);
			} else {
				g.beginFill(headerColour);
			}
			g.drawRect(0, 0, theWidth, headerHeight);
			g.endFill();
			
			// Outline
			g.lineStyle(0, 0xCACACA);
			g.drawRect(0, 0, theWidth, theHeight + headerHeight);
		}
		
	}

}