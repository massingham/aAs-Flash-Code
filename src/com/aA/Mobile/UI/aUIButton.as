package com.aA.Mobile.UI 
{
	import com.aA.Mobile.UI.Style.aUIColourScheme;
	import com.aA.Colour.Colour;
	import com.aA.Text.Text;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIButton extends aUIComponent
	{
		protected var label:TextField;
		
		protected var hitAreaSprite:Sprite;
		
		protected var imageSprite:Sprite;
		protected var buttonSprite:Sprite;
		protected var button_overSprite:Sprite;
		protected var button_pressSprite:Sprite;
		protected var button_highlight:Sprite;
		
		private var _text:String;
		private var _align:String;
		private var _fullWidth:Number;
		protected var _fullHeight:Number;
		private var _padding:Number = 0;
		private var spritePadding:Number = 0;
		
		protected var theWidth:Number;
		
		private var sprite:DisplayObject = null;
		
		public function aUIButton(labelText:String, fullWidth:Number, fullHeight:Number, align:String = "CENTER") 
		{
			_text = labelText;
			_fullWidth = fullWidth;
			_fullHeight = fullHeight;
			_align = align;
			
			this.name = labelText;
			
			_padding = _fullHeight * 0.2;
			
			init();
			
			this.text = _text;
		}
		
		protected function init():void {
			buttonSprite = new Sprite();
			addChild(buttonSprite);
			
			button_overSprite = new Sprite();
			addChild(button_overSprite);
			button_overSprite.visible = false;
			
			button_highlight = new Sprite();
			addChild(button_highlight);
			button_highlight.visible = false;
			
			button_pressSprite = new Sprite();
			addChild(button_pressSprite);
			button_pressSprite.visible = false;
			
			imageSprite = new Sprite();
			addChild(imageSprite);
			
			label = Text.getTextField("", _fullHeight * .3, style.getColour(aUIColourScheme.COLOUR_BUTTONTEXT), "LEFT", "_sans", false);
			label.cacheAsBitmap = true;
			addChild(label);
						
			hitAreaSprite = new Sprite();
			addChild(hitAreaSprite);
			hitAreaSprite.alpha = 0;
			
			hitAreaSprite.mouseEnabled = true;
			hitAreaSprite.buttonMode = true;
			hitAreaSprite.addEventListener(MouseEvent.MOUSE_DOWN, touch);
			hitAreaSprite.addEventListener(MouseEvent.MOUSE_UP, touch);
			hitAreaSprite.addEventListener(MouseEvent.MOUSE_UP, touch);
			hitAreaSprite.addEventListener(MouseEvent.MOUSE_OUT, touch);
		}
		
		protected function touch(event:MouseEvent):void {
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					button_pressSprite.visible = true;
					//event.stopPropagation();
				break;
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_UP:
					button_pressSprite.visible = false;
					event.stopPropagation();
				break;
				case MouseEvent.CLICK:
					button_pressSprite.visible = false;
					dispatchEvent(new Event("click"));
					event.stopPropagation();
				break;
			}
		}
		
		/**
		 * Adds a sprite to the button
		 * @param	sprite
		 * @param	position
		 */
		public function addSprite(sprite:DisplayObject, position:String = "LEFT", padding:Number = -1):void {
			this.sprite = sprite;
			imageSprite.addChild(this.sprite);
			
			if (padding == -1) {
				padding = _fullHeight * 0.1;
			}
			spritePadding = padding;
			// _padding = _fullHeight * 0.1;
			
			this.sprite.height = _fullHeight - (padding * 2);
			this.sprite.scaleX = this.sprite.scaleY;
			this.sprite.x = padding;
			this.sprite.y = padding;
			
			this.text = label.text;
		}
		
		public override function draw():void {
			getFullWidth();
			label.textColor = style.getColour(aUIColourScheme.COLOUR_BUTTONTEXT);
			
			drawButton(buttonSprite, style.getColour(aUIColourScheme.COLOUR_FILL));
			drawButton(button_overSprite, Colour.changeBrightness(style.getColour(aUIColourScheme.COLOUR_FILL), 10));
			drawButton(button_highlight, style.getColour(aUIColourScheme.COLOUR_HIGHLIGHT));
			drawButton(button_pressSprite, Colour.changeBrightness(style.getColour(aUIColourScheme.COLOUR_FILL), -10));
			drawButton(hitAreaSprite, 0);
		}
		
		protected function drawButton(sprite:Sprite, fill:uint):void {
			sprite.graphics.clear();
			if(style.buttonOutlines) sprite.graphics.lineStyle(0, style.getColour(aUIColourScheme.COLOUR_LINE), 1, true);
			sprite.graphics.beginFill(fill, 1);
			sprite.graphics.drawRoundRect(0, 0, theWidth, _fullHeight, style.cornerRadius, style.cornerRadius);
			sprite.graphics.endFill();
		}
		
		public function setTextHeight(s:Number):void {
			var f:TextFormat = label.getTextFormat();
			f.size = s;
			label.defaultTextFormat = f;
			text = label.text;
		}
		
		public function getFullWidth():void {
			var number:Number = label.width;
			
			if (sprite != null) {
				number += sprite.width + spritePadding * 2;
				
				if (label.text == "") {
					number -= spritePadding * 2;
				}
			}
			
			if (number > _fullWidth) {
				theWidth = number + _padding;
				if (sprite != null) {
					theWidth = number + spritePadding;
				}
			} else {
				theWidth = _fullWidth;
			}
		}
		
		public function set text(val:String):void {
			label.htmlText = val;
			
			getFullWidth();
			
			if(_align=="CENTER"){
				if (sprite == null) {
					label.x = theWidth / 2 - label.width / 2;
				} else {
					label.x = sprite.x + sprite.width + spritePadding;
				}
			} else if (_align == "LEFT") {
				if (sprite == null) {
					label.x = _padding;
				} else {
					label.x = sprite.x + sprite.width + spritePadding;
				}
			}
			
			label.y = _fullHeight / 2 - label.height / 2;
			
			draw();
		}
		
		public function get text():String {
			return label.text;
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			_fullWidth = value;
			this.text = label.text;
			draw();
		}
		
		public function highlight():void {
			button_highlight.visible = true;
		}
		
		public function disableHighlight():void {
			button_highlight.visible = false;
		}
		
		public function disable():void {
			this.alpha = 0.2;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function enable():void {
			this.alpha = 1;
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
	}

}