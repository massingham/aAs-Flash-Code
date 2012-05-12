package com.aA.UI 
{
	import flash.display.*
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Anthony Massingham, 2009
	*/
	public class ScrollBar extends Sprite
	{
		private var maskSprite:Sprite;
		
		// dimensions
		private var barRatio:Number;
		private var maxBarHeight:Number;
		
		private var controlClip:Sprite;
		
		private var currentScroll:Number = 0;
		private var targetScroll:Number = 0;
		private var maxScroll:Number = 0;
		
		private var currenty:Number;
		private var barMax:Number;
		
		/**
		 * 
		 * Assign to item in the library, requires the following : 
		 * 'bar_mc'
		 * 'arrow_mc'
		 * 
		 * @param	theHeight		The height of the mask
		 * @param	controlClip		The clip to scroll
		 */
		public function ScrollBar(theHeight:Number, controlClip:Sprite, rows:int) 
		{
			this.controlClip = controlClip;
			targetScroll = controlClip.y;
			trace("start : " + targetScroll);
			
			maskSprite = new Sprite();
			addChild(maskSprite);
			
			maxScroll = 275 * (rows - 2);
			if (maxScroll < 0) {
				maxScroll = 0;
			}
			
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(0, 0, controlClip.width, theHeight);
			maskSprite.graphics.endFill();
			
			maskSprite.x = 0 - controlClip.width - 25;
			controlClip.mask = maskSprite;
			
			this.arrowdown_mc.y = maskSprite.height - this.arrowdown_mc.height / 2;
			
			maxBarHeight = this.arrowdown_mc.y - this.arrowup_mc.y - this.arrowdown_mc.width * 2;
			barRatio = maxBarHeight / controlClip.height;
			
			if(barRatio < 1){
				this.bar_mc.height = maxBarHeight * barRatio;
			} else {
				this.bar_mc.height = maxBarHeight;
			}
			this.bar_mc.y = 0 + this.arrowup_mc.height + this.arrowup_mc.height / 2;
			
			// set the bar max y value
			barMax = maxBarHeight - this.bar_mc.height;
			
			// set alphas
			this.bar_mc.alpha = 0.7;
			this.arrowup_mc.alpha = 0.7;
			this.arrowdown_mc.alpha = 0.7;
			
			this.bar_mc.buttonMode = true;
			this.arrowup_mc.buttonMode = true;
			this.arrowdown_mc.buttonMode = true;
			
			this.bar_mc.addEventListener(MouseEvent.MOUSE_OVER, rollover);
			this.arrowup_mc.addEventListener(MouseEvent.MOUSE_OVER, rollover);
			this.arrowdown_mc.addEventListener(MouseEvent.MOUSE_OVER, rollover);
			
			this.bar_mc.addEventListener(MouseEvent.MOUSE_OUT, rollout);
			this.arrowup_mc.addEventListener(MouseEvent.MOUSE_OUT, rollout);
			this.arrowdown_mc.addEventListener(MouseEvent.MOUSE_OUT, rollout);
			
			this.arrowup_mc.addEventListener(MouseEvent.CLICK, scrollUp);
			this.arrowdown_mc.addEventListener(MouseEvent.CLICK, scrollDown);
			this.bar_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragBar);
			
			this.addEventListener(MouseEvent.MOUSE_UP, stopdragBar);
		}
		
		private function dragBar(event:MouseEvent):void {
			currenty = mouseY - this.bar_mc.y;
			this.bar_mc.addEventListener(Event.ENTER_FRAME, drag);
		}
		
		private function stopdragBar(event:MouseEvent):void {
			this.bar_mc.removeEventListener(Event.ENTER_FRAME, drag);
		}
		
		private function drag(event:Event):void {
			//if (this.bar_mc.y < barMax) {
			//	this.bar_mc.y = mouseY - currenty;
			//}
			
			/*if (this.bar_mc.y < (this.arrowup_mc.y)) {
				trace("a : "+this.bar_mc.y +","+this.arrowup_mc.y);
				this.bar_mc.y = this.arrowup_mc.y;
			} else if (this.bar_mc.y > (this.arrowdown_mc.y - this.arrowdown_mc.height)) {
				trace("b : " + this.bar_mc.y +"," + this.arrowdown_mc.y);
				this.bar_mc.y = this.arrowdown_mc.y;
			} else {
				this.bar_mc.y = mouseY - currenty;
			}*/
		}
		
		private function rollover(event:MouseEvent):void {
			event.currentTarget.alpha = 1;
		}
		private function rollout(event:MouseEvent):void {
			event.currentTarget.alpha = 0.7;
		}
		
		private function scrollUp(event:MouseEvent):void {
			targetScroll += 275;
			
			if (targetScroll > 0) {
				targetScroll = 0;
			}
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function scrollDown(event:MouseEvent):void {
			targetScroll -= 275;			
			if (targetScroll < maxScroll*-1) {
				targetScroll = maxScroll*-1;
			}
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function scroll(event:Event):void {
			var ax:Number = (targetScroll - controlClip.y) * 0.3;
			
			controlClip.y += ax;
			
			// trace(targetScroll);
			
			if (controlClip.y < targetScroll + 0.2 && controlClip.y > targetScroll - 0.2) {
				removeEventListener(Event.ENTER_FRAME, scroll);
			}
		}
		
	}
	
}