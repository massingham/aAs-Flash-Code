package com.aA.Mobile.UI 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.aA.Text.Text;
	/**
	 * ...
	 * @author ...
	 */
	public class aUIComboItem extends aUIButton
	{
		public function aUIComboItem(_width:Number, _height:Number, _label:String) 
		{
			super(_label, _width, _height, "LEFT");
		}
		
		override public function draw():void 
		{
			getFullWidth();
			label.textColor = 0xD6D6D6;
			
			//drawButton(buttonSprite, style.getColour(aUIColourScheme.COLOUR_FILL));
			//drawButton(button_overSprite, Colour.changeBrightness(style.getColour(aUIColourScheme.COLOUR_FILL), 10));
			//drawButton(button_pressSprite, Colour.changeBrightness(style.getColour(aUIColourScheme.COLOUR_FILL), -10));
			drawButton(hitAreaSprite, 0);
		}
		
	}

}