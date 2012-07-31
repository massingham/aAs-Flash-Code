package com.aA.Mobile.UI.InfiniteSwipeList 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class InfiniteSwipeItem extends Sprite
	{
		protected var itemWidth:Number;
		protected var itemHeight:Number;
		
		protected var bgSprite:Sprite;
		public var tutorialShown:Boolean;
		
		public var _currentSelection:Boolean = false;
		
		public function InfiniteSwipeItem(itemWidth:Number, itemHeight:Number) 
		{
			this.itemWidth = itemWidth
			this.itemHeight = itemHeight;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void {
			drawBG();
		}
		
		protected function drawBG():void {
			bgSprite = new Sprite();
			addChild(bgSprite);
			
			bgSprite.graphics.beginFill(0xEFF0F4);
			bgSprite.graphics.drawRect(0, 0, itemWidth, 1);
			bgSprite.graphics.endFill();
			
			bgSprite.graphics.beginFill(0x5C5C5C);
			bgSprite.graphics.drawRect(0, 0, 2, 1);
			bgSprite.graphics.endFill();
			
			bgSprite.graphics.beginFill(0x5C5C5C);
			bgSprite.graphics.drawRect(itemWidth - 2, 0, 2, 1);
			bgSprite.graphics.endFill();
			
			bgSprite.height = itemHeight;
		}
		
		public function clear():void {
			
		}
		
		public function sendContent(content:*):void {
			
		}
		
		public function get currentSelection():Boolean {
			return _currentSelection;
		}
		
		public function set currentSelection(value:Boolean):void {
			_currentSelection = value;
		}
	}

}