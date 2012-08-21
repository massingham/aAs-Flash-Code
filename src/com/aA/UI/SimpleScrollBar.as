package com.aA.UI 
{
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimpleScrollBar extends Sprite
	{
		private var clip:Sprite;
		private var scrollHeight:Number;
		
		private var maskSprite:Sprite;
		private var controlsSprite:Sprite;
		private var barSprite:Sprite;
		private var backSprite:Sprite;
		private var upArrowSprite:Sprite;
		private var downArrowSprite:Sprite;
		
		private var currentPos:Number;
		private var scrollSpeed:Number = 0;
		private var ratio:Number;
		private var startPos:Number;
		private var savedPercentage:Number;
		
		private var clipY:Number;
		
		public var scrolling:Boolean;
		
		private var scrollerVisible:Boolean = false;
		
		/**
		 * Creates a simple scrollbar, since all my other attempts were so horribly broken
		 * 	
		 * @param	clip	the clip to scroll
		 * @param	height	the height of the mask, and therefore - the scrollbar
		 */
		public function SimpleScrollBar(clip:Sprite, scrollHeight:Number) 
		{
			this.clip = clip;
			clipY = this.clip.y;
			this.scrollHeight = scrollHeight;
			currentPos = 0;
			scrolling = false;
			startPos = this.clip.y;
			
			if (clip.height > scrollHeight) {
				createMask();
				createControls();					
				
				this.x = clip.x;
				this.y = clip.y;
				
				scrollerVisible = true;
			} else {
				trace("CLIP ISNT TALL ENOUGH, LOWER THE HEIGHT");
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onRemoved(event:Event):void {
			if (maskSprite) {
				clip.mask = null;
			}
		}
		
		public function activateMouseWheel(activate:Boolean = true):void {
			if(activate){
				this.parent.addEventListener(MouseEvent.MOUSE_WHEEL, scrollWheel);
			} else {
				this.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollWheel);
			}
		}
		
		public function scrollWheel(event:MouseEvent):void {
			if (event.delta < 0) {
				scrollSpeed = 5;
			} else {
				scrollSpeed = -5;	
			}
			
			var maxHeight:Number = (backSprite.height - barSprite.height) + 10;

			if (barSprite.y >= 10 && barSprite.y <= maxHeight) {
				barSprite.y += scrollSpeed;
				
				if (barSprite.y < 10) {
					barSprite.y = 10;
				} else if (barSprite.y > maxHeight) {
					barSprite.y = maxHeight;
				}
			}
			
			
			var relativey:Number = barSprite.y - 10;
					
			// %age pos
			var percentPos:Number = (relativey / (backSprite.height - barSprite.height));					
			var temp:Number = clip.height - scrollHeight;

			clip.y = clipY - (temp * percentPos);
			
			barSprite.stopDrag();
			
			dispatchEvent(new Event("scroll"));
		}
		
		
		public function moveToBottomPosition():void {
			trace("scroll Height " + scrollHeight + " clip.height " + clip.height);
			clip.y = scrollHeight - clip.height - 20;
			
			scrollSpeed = 50;
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		/**
		 * Recalculates the scrollbarheight etc.
		 * @param	newHeight
		 */
		public function redrawScroller(newHeight:Number = 0):void {
			if (barSprite) {
				savedPercentage = barSprite.y;
			} else {
				savedPercentage = 0;
			}

			
			if (newHeight.toString() == "NaN") {
				newHeight = 0;
			}
			
			if (newHeight != 0) {
				scrollHeight = newHeight;
			}
			
			//clipY = this.clip.y;
			
			//clipY = this.clip.y;
			//this.scrollHeight = scrollHeight;
			//currentPos = 0;
			if(scrollerVisible){
				removeAllListeners();
				
				clip.mask = null;
				maskSprite.graphics.clear();
				removeChild(maskSprite);
				
				removeChild(controlsSprite);
				
				backSprite.graphics.clear()
				controlsSprite.removeChild(backSprite);
				barSprite.graphics.clear();
				controlsSprite.removeChild(barSprite);
				upArrowSprite.graphics.clear();
				controlsSprite.removeChild(upArrowSprite);
				downArrowSprite.graphics.clear();
				controlsSprite.removeChild(downArrowSprite);
			}
			
			// trace("is " + clip.height +" > " + scrollHeight);
			if (clip.height > scrollHeight) {				
				createMask();
				createControls();					
				
				if (!scrollerVisible) {
					this.x = clip.x;
					this.y = clip.y;
				}
				
				if (savedPercentage != 0) {
					barSprite.y = savedPercentage;
					
					var maxHeight:Number = (backSprite.height - barSprite.height) + 10;
					if (barSprite.y > maxHeight) {
						barSprite.y = maxHeight;
					}
					
					scrollClip(null);
				}
				
				scrollerVisible = true;
			} else {
				scrollerVisible = false;
				// trace("CLIP ISNT TALL ENOUGH, LOWER THE HEIGHT");
				
				clip.y = startPos;
				this.y = clip.y;
			}
		}
		
		/**
		 * Create clip mask
		 */
		private function createMask():void {
			maskSprite = new Sprite();
			addChild(maskSprite);
			
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRect(0, 0, clip.width, scrollHeight);
			maskSprite.graphics.endFill();
			
			maskSprite.alpha = 0.2;
			
			clip.mask = maskSprite;
		}

		private function removeAllListeners():void {
			upArrowSprite.removeEventListener(MouseEvent.MOUSE_DOWN, scrollUpClick);
			upArrowSprite.removeEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			downArrowSprite.removeEventListener(MouseEvent.MOUSE_DOWN, scrollDownClick);
			downArrowSprite.removeEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			barSprite.removeEventListener(MouseEvent.MOUSE_DOWN, clickDrag);
			if(this.clip.stage != null){
				this.clip.stage.removeEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			}
		}
		
		/**
		 * create bar controls
		 */
		private function createControls():void {
			controlsSprite = new Sprite();
			addChild(controlsSprite);
			
			backSprite = new Sprite();
			controlsSprite.addChild(backSprite);
			
			barSprite = new Sprite();
			controlsSprite.addChild(barSprite);
			
			upArrowSprite = new Sprite();
			controlsSprite.addChild(upArrowSprite);
			upArrowSprite.addEventListener(MouseEvent.MOUSE_DOWN, scrollUpClick);
			upArrowSprite.addEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			upArrowSprite.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			upArrowSprite.addEventListener(MouseEvent.MOUSE_OUT, highlight);
			
			downArrowSprite = new Sprite();
			controlsSprite.addChild(downArrowSprite);
			downArrowSprite.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownClick);
			downArrowSprite.addEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			downArrowSprite.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			downArrowSprite.addEventListener(MouseEvent.MOUSE_OUT, highlight);
			
			backSprite.graphics.beginFill(0x6F6F6F);
			backSprite.graphics.drawRect(0, 10, 10, scrollHeight - 20);
			backSprite.graphics.endFill();
			
			ratio = (scrollHeight / clip.height);			
			
			barSprite.graphics.beginFill(0xAAAAAA);
			barSprite.graphics.drawRect(0, 0, 10, ratio * backSprite.height);
			barSprite.graphics.endFill();	
			barSprite.addEventListener(MouseEvent.MOUSE_DOWN, clickDrag);
			barSprite.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			barSprite.addEventListener(MouseEvent.MOUSE_OUT, highlight);
			
			barSprite.alpha = 0.7;
			barSprite.buttonMode = true;
			
			//this.clip.stage.addEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			
			barSprite.x = 0;
			barSprite.y = 10;
			
			upArrowSprite.graphics.beginFill(0xAAAAAA);
			upArrowSprite.graphics.drawRect(0, 0, 10, 10);
			upArrowSprite.graphics.endFill();
				
			upArrowSprite.graphics.beginFill(0x000000);
			upArrowSprite.graphics.moveTo(2, 7);
			upArrowSprite.graphics.lineTo(5, 3);
			upArrowSprite.graphics.lineTo(8, 7);
			upArrowSprite.graphics.lineTo(2, 7);
			upArrowSprite.graphics.endFill();
			
			upArrowSprite.buttonMode = true;
			
			upArrowSprite.alpha = 0.7;
			
			upArrowSprite.x = 0;
			upArrowSprite.y = 0;
			
			downArrowSprite.graphics.beginFill(0xAAAAAA);
			downArrowSprite.graphics.drawRect(0, 0, 10, 10);
			downArrowSprite.graphics.endFill();
			
			downArrowSprite.graphics.beginFill(0x000000);
			downArrowSprite.graphics.moveTo(2, 3);
			downArrowSprite.graphics.lineTo(5, 7);
			downArrowSprite.graphics.lineTo(8, 3);
			downArrowSprite.graphics.lineTo(2, 3);
			downArrowSprite.graphics.endFill();
			
			downArrowSprite.alpha = 0.7;
			
			downArrowSprite.buttonMode = true;
		
			downArrowSprite.x = 0;
			downArrowSprite.y = scrollHeight - 10;
			
			controlsSprite.x = 0 + clip.width;
		}
		
		private function clickDrag(event:MouseEvent):void {
			barSprite.startDrag(false, new Rectangle(0, 10, 0, backSprite.height - barSprite.height));
			this.stage.addEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			
			scrolling = true;
			addEventListener(Event.ENTER_FRAME, scrollClip);
		}
		
		private function scrollDownClick(event:MouseEvent):void {
			scrollSpeed = 2;
			
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function scrollUpClick(event:MouseEvent):void {
			scrollSpeed = -2;
			
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function highlight(event:MouseEvent):void {
			if (event.type == "mouseOver") {
				event.currentTarget.alpha = 1;
			} else {
				event.currentTarget.alpha = 0.7;
			}
		}
		
		private function scroll(event:Event):void {
			var maxHeight:Number = (backSprite.height - barSprite.height) + 10;
			
			if (scrollSpeed != 0) {
				if (barSprite.y >= 10 && barSprite.y <= maxHeight) {
					barSprite.y += scrollSpeed;
					
					if (barSprite.y < 10) {
						barSprite.y = 10;
					} else if (barSprite.y > maxHeight) {
						barSprite.y = maxHeight;
					}
					
					scrollClip();
				}
			}
			
			dispatchEvent(new Event("scroll"));
		}
		
		private function scrollClip(event:Event = null):void {
			var relativey:Number = barSprite.y - 10;
					
			// %age pos
			var percentPos:Number = (relativey / (backSprite.height - barSprite.height));					
			var temp:Number = clip.height - scrollHeight;

			clip.y = clipY - (temp * percentPos);
			
			dispatchEvent(new Event("scroll"));
		}
		
		private function buttonRelease(event:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, buttonRelease);
			scrollSpeed = 0;
			scrolling = false;
			removeEventListener(Event.ENTER_FRAME, scroll);
			removeEventListener(Event.ENTER_FRAME, scrollClip);
			barSprite.stopDrag();			
		}
		
	}
	
}