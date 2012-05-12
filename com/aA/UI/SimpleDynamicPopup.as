package com.aA.UI 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.aA.Colour.ColourScheme;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.text.TextFieldAutoSize;
	
	import com.aA.Text.Text;
	/**
	 * Based on the code of SimplePopup, however adds the 
	 * ability to dynamically resize as more content is added
	 * 
	 * @author Anthony Massingham
	 */
	public class SimpleDynamicPopup extends Sprite
	{
	
		private var theWidth:int;
		private var theHeight:int;
		private var headerHeight:int;
		private var boxSprite:Sprite;
		private var headerSprite:Sprite;
		
		private var contentSprite:Sprite;
		private var yPos:Number;
		private var currentLine:Array;
		
		private var gradient:Boolean;
		
		/**
		 * 
		 * @param	minWidth
		 * @param	minHeight
		 * @param	gradient
		 * @param	headerHeight
		 * @param	header
		 * @param	headerSize
		 */
		public function SimpleDynamicPopup(minWidth:int, minHeight:Number, gradient:Boolean, headerHeight:int = 50, header:* = "Popup Box", headerSize:int = 25) 
		{
			this.theWidth = minWidth;
			this.theHeight = minHeight;
			this.headerHeight = headerHeight;
			this.gradient = gradient;
			
			yPos = 10;
			
			boxSprite = new Sprite();
			addChild(boxSprite);
			
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			// Determine the nature of the header image...
			headerSprite = new Sprite();
			if (typeof header == "object") {
				// sprite
				headerSprite = header;
				if (this.headerHeight < headerSprite.height) headerHeight = headerSprite.height + 10;
			} else {
				// string
				var textField:TextField = Text.getTextField(header, headerSize, ColourScheme.getInstance().text, "LEFT");
				headerSprite.addChild(textField);
			}
			
			addChild(headerSprite);
			headerSprite.y = headerHeight / 2 - headerSprite.height / 2;
			headerSprite.x = 10;
			
			contentSprite.y += headerHeight;
			
			currentLine = new Array();
			
			drawPopup();
		}
		
		public function clearPopup():void {
			for (var i:int = contentSprite.numChildren - 1; i >= 0; i--) {
				contentSprite.removeChildAt(i);
			}
			
			currentLine = new Array();
			
			yPos = 10;
		}
		
		public function drawPopup():void {			
			// height does not include header height.  Draw the header first
			var g:Graphics = boxSprite.graphics;
			g.clear();
			
			g.beginFill(ColourScheme.getInstance().fill_Light, 1);
			g.drawRect(0, 0, theWidth, theHeight + headerHeight);
			g.endFill();
			
			if(gradient){
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(theWidth, headerHeight, Math.PI / 2, 0, 0);
				
				g.beginGradientFill(GradientType.LINEAR, [ColourScheme.getInstance().fill, ColourScheme.getInstance().fill_Dark], [1, 1], [0, 255], gradientMatrix);
			} else {
				g.beginFill(ColourScheme.getInstance().fill);
			}
			g.drawRect(0, 0, theWidth, headerHeight);
			g.endFill();
			
			// Outline
			g.lineStyle(0, 0xCACACA);
			g.drawRect(0, 0, theWidth, theHeight + headerHeight);
		}
		
		public function addSprite(sprite:Sprite):void {
			contentSprite.addChild(sprite);
			
			sprite.x = theWidth / 2 - sprite.width / 2;
			sprite.y = yPos;
			
			yPos += sprite.height + 10;
		}
		
		public function addText(text:String, fontSize:int):TextField {
			var tf:TextField = Text.getTextField(text, fontSize, ColourScheme.getInstance().text);
			if (tf.width > theWidth) {
				tf.autoSize = TextFieldAutoSize.NONE;
				tf.width = theWidth - 20;
				tf.wordWrap = true;
				tf.height = tf.textHeight + 10;
			}			
			
			contentSprite.addChild(tf);
			tf.x = theWidth / 2 - tf.width / 2;
			tf.y = yPos;
			
			yPos += tf.height + 10;
			
			return tf;
		}
		
		public function addInput(w:int, h:int, size:int):TextField {
			var tf:TextField = Text.getInput(w, h, size, ColourScheme.getInstance().fill_Light, ColourScheme.getInstance().fill_Dark);
			
			contentSprite.addChild(tf);
			tf.x = theWidth / 2 - tf.width / 2;
			tf.y = yPos;
			
			yPos += tf.height + 10;
			
			return tf;
		}
		
		public function addButton(buttonText:String, w:int, h:int, fontSize:int, newline:Boolean = true):SimpleButton {
			var button:SimpleButton = new SimpleButton(w, h, buttonText, fontSize);
			
			contentSprite.addChild(button);
			button.x = theWidth / 2 - button.width / 2;
			button.y = yPos;
			
			if(newline){
				yPos += button.height + 5;
			} else {
				
			}
			
			currentLine.push(button);
			
			if (!newline) {
				finishLine();
			}
			
			return button;
		}
		
		public function finishLine(padding:int = 10):void {
			var xPos:Number = 0;
			var distance:Number = 0;
			for (var i:int = 0; i < currentLine.length; i++) { 
				currentLine[i].x = xPos;
				xPos += currentLine[i].width + padding;
			}
			
			distance = theWidth - xPos + padding;
			
			for (i = 0; i < currentLine.length; i++) { 
				currentLine[i].x += distance / 2;
			}
		}
		
		public function addSpace(distance:int = 20):void {
			yPos += distance;
			currentLine = new Array();
		}
		
		public function resize():void {
			if (contentSprite.height > theHeight) {
				theHeight = contentSprite.height + 20;
			}
			
			drawPopup();
		}
		
	}

	}