package com.aA.UI.SimpleCheckList 
{
	import com.aA.Colour.Colour;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimpleCheckItem extends Sprite
	{
		private var hitAreaSprite:Sprite;
		private var boxSprite:Sprite;
		private var checkSprite:Sprite;
		private var textField:TextField;
		
		private var boxSize:Number;
		private var totalWidth:Number;
		private var boxColour:uint;
		private var value:String;
		private var fontSize:int;
		
		public function SimpleCheckItem(boxSize:Number, totalWidth:Number, boxColour:uint, value:String, fontSize:int = -1) 
		{
			this.boxSize = boxSize;
			this.boxColour = boxColour;
			this.totalWidth = totalWidth;
			this.value = value;
			this.fontSize = fontSize;
			
			init();
		}
		
		private function init():void {
			boxSprite = new Sprite();
			boxSprite.graphics.beginFill(boxColour);
			boxSprite.graphics.drawRect(0, 0, boxSize, boxSize);
			boxSprite.graphics.endFill();
			addChild(boxSprite);
			
			var padding:int = boxSize * .2;
			
			checkSprite = new Sprite();
			checkSprite.graphics.lineStyle(2, Colour.changeBrightness(boxColour, -50));
			checkSprite.graphics.moveTo(padding, padding);
			checkSprite.graphics.lineTo(boxSize-padding, boxSize-padding);
			checkSprite.graphics.moveTo(boxSize-padding, padding);
			checkSprite.graphics.lineTo(padding, boxSize-padding);
			addChild(checkSprite);
			
			textField = Text.getTextField(value, fontSize, boxColour, "LEFT", "_sans", false);
			addChild(textField);
			textField.x = boxSize + padding;
			textField.y = boxSize / 2 - textField.height / 2;
			
			hitAreaSprite = new Sprite();
			addChild(hitAreaSprite);
			
			hitAreaSprite.graphics.beginFill(0);
			hitAreaSprite.graphics.drawRect(0, 0, totalWidth, this.height);
			hitAreaSprite.graphics.endFill();
			
			hitAreaSprite.alpha = 0;
		}
		
		public function check():void {
			checkSprite.visible = true;
		}
		
		public function uncheck():void {
			checkSprite.visible = false;
		}
		
		public function get checked():Boolean {
			return checkSprite.visible;
		}
	}

}