package com.aA.Mobile.UI.Views 
{
	import com.aA.Mobile.UI.aUIComponent;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * Generic List Item
	 * 
	 * @author Anthony Massingham
	 */
	public class aUIListItem extends aUIComponent
	{
		protected var padding:int;
		
		protected var borderSprite:Sprite;
		protected var bgSprite:Sprite;
		protected var iconSprite:Sprite;
		protected var text:TextField;
		
		protected var itemWidth:Number;
		protected var itemHeight:Number;
		
		public var data:String;
		
		public function aUIListItem(data:String, itemWidth:Number, itemHeight:Number) 
		{			
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.data = data;
			
			init();
		}
		
		protected function init():void {
			bgSprite = new Sprite();
			addChild(bgSprite);
			
			borderSprite = new Sprite();
			addChild(borderSprite);
			
			drawBGSprite();
			
			padding = 0;
		}
		
		protected function drawBGSprite(colour:uint = 0xEEEEEE):void {
			bgSprite.graphics.clear();
			bgSprite.graphics.beginFill(colour);
			bgSprite.graphics.drawRect(0, 0, itemWidth, itemHeight);
			bgSprite.graphics.endFill();
			
			drawBorder();
		}
		
		protected function drawBorder():void {
			borderSprite.graphics.clear();
			borderSprite.graphics.lineStyle(0, 0xDADADA);
			borderSprite.graphics.moveTo(0, 0);
			borderSprite.graphics.lineTo(itemWidth, 0);
			borderSprite.graphics.moveTo(0, itemHeight);
			borderSprite.graphics.lineTo(itemWidth, itemHeight);
			
			if (iconSprite) {
				borderSprite.graphics.lineStyle(0, 0xEEEEEE);
				//borderSprite.graphics.moveTo(iconSprite.width, 0);
				//borderSprite.graphics.lineTo(0, 0);
				borderSprite.graphics.moveTo(0, itemHeight);
				borderSprite.graphics.lineTo(iconSprite.width, itemHeight);
			}
		}
		
		protected function alignContent():void {
			var offset:Number = 0;
			
			if (iconSprite) {
				iconSprite.height = itemHeight - (padding * 2);
				iconSprite.scaleX = iconSprite.scaleY;
				
				iconSprite.x = padding;
				iconSprite.y = padding;
				
				offset = iconSprite.width + padding;
			} 
			
			if (text) {
				text.x = offset * 1.2;
				text.y = itemHeight / 2 - text.height / 2;
			}
			
			moveBorderToTop();
		}
		
		/**
		 * Moves the border sprite to the top of the display list
		 */
		protected function moveBorderToTop():void {
			this.setChildIndex(borderSprite, this.numChildren - 1);
		}
		
		public function addSprite(value:Sprite):void {
			iconSprite = value;
			addChild(iconSprite);
			
			alignContent();
			drawBorder();
		}
		
		public function addText(value:String):void {
			text = Text.getTextField(value, itemHeight * 0.3, 0, "LEFT", "_sans", false);
			addChild(text);
			text.cacheAsBitmap = true;
			
			alignContent();
		}
		
		public function highlight():void {
			drawBGSprite(0x829DBB);
		}
		
		public function reset():void {
			drawBGSprite();
		}
		
	}

}