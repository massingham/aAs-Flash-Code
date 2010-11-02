package com.aA.UI 
{
	import flash.display.Sprite;
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
		private var buttonSprite:Sprite;
		private var label:TextField;
		
		public function SimpleButton(w:int, h:int, text:String, fontSize:int, colour:uint) 
		{
			buttonSprite = new Sprite();
			addChild(buttonSprite);
			
			label = Text.getTextField(text, fontSize, 0, "CENTER");
			
			buttonSprite.graphics.lineStyle(0, 0, 0.2);
			buttonSprite.graphics.drawRect(0, 0, w, h);
			
			label.x = w / 2 - label.width / 2;
			label.y = h / 2 - label.height / 2;
			
			buttonSprite.addChild(label);
		}
		
	}

}