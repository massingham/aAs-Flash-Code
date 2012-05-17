package com.aA.Mobile.UI.Views 
{
	import com.aA.Colour.Colour;
	import com.aA.Mobile.UI.aUIComponent;
	import com.aA.Mobile.UI.Style.aUIColourScheme;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	/**
	 * Simple View.  Just basic for now, I want to classerise all of this later
	 * @author Anthony Massingham
	 */
	public class aUIListView extends aUIComponent
	{
		protected var headerHeight:Number;
		protected var listWidth:Number;
		protected var itemHeight:Number;
		
		private var backButton:Sprite;
		
		private var list:Vector.<aUIListItem>;
		private var bgSprite:Sprite;
		private var listSprite:Sprite;
		private var headerSprite:Sprite;
		
		// Scrolling variables
		private var startPosition:Number;
		private var mouseStart:Number;
		private var mouseDown:Boolean;
		
		public var currentSelection:aUIListItem;
		
		private var columns:int = 1;
		
		private var headerLabelText:String;
		
		public function aUIListView(listWidth:Number, headerHeight:Number, itemHeight:Number, headerLabel:String) 
		{
			this.listWidth = listWidth;
			this.headerHeight = headerHeight;
			this.itemHeight = itemHeight;
			
			headerLabelText = headerLabel;
			init();
			
			//listSprite.addEventListener(TouchEvent.TOUCH_BEGIN, touchEvent);
			//listSprite.addEventListener(TouchEvent.TOUCH_MOVE, touchEvent);
			
			//listSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
		}
		
		/**
		 * 
		 */
		private function init():void {
			bgSprite = new Sprite();
			addChild(bgSprite);
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			listSprite = new Sprite();
			addChild(listSprite);
			
			headerSprite = new Sprite();
			addChild(headerSprite);
			
			backButton = new Sprite();
			addChild(backButton);
			
			backButton.graphics.beginFill(0x2E5380);
			backButton.graphics.drawRect(0, 0, headerHeight, headerHeight);
			backButton.graphics.endFill();
			
			backButton.graphics.beginFill(0, 0.5);
			backButton.graphics.moveTo(headerHeight * .75, headerHeight * .75);
			backButton.graphics.lineTo(headerHeight * .75, headerHeight * .25);
			backButton.graphics.lineTo(headerHeight * .25, headerHeight / 2);
			backButton.graphics.lineTo(headerHeight * .75, headerHeight * .75);
			backButton.graphics.endFill();
			
			backButton.graphics.lineStyle(0, 0x151515, 0.5);
			backButton.graphics.moveTo(headerHeight, 0);
			backButton.graphics.lineTo(headerHeight, headerHeight);
			
			backButton.addEventListener(MouseEvent.MOUSE_DOWN, back);
			
			var headerlabel:TextField = Text.getTextField(headerLabelText, headerHeight * 0.3, 0xE4E4E4, "LEFT", "_sans", false);
			headerSprite.addChild(headerlabel);
			headerlabel.x = backButton.width + backButton.width * 0.2;
			headerlabel.y = headerHeight / 2 - headerlabel.height / 2;
			
			list = new Vector.<aUIListItem>();
			
			drawHeader();
			listSprite.y = headerSprite.height;
		}
		
		private function addedToStage(event:Event):void {
			bgSprite.graphics.beginFill(0xFFFFFF);
			bgSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bgSprite.graphics.endFill();
		}
		
		protected function drawHeader():void {
			headerSprite.graphics.lineStyle();
			
			headerSprite.graphics.clear();
			headerSprite.graphics.beginFill(0x202020);
			headerSprite.graphics.drawRect(0, 0, listWidth, headerHeight);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.beginFill(Colour.changeBrightness(0x202020, -10));
			headerSprite.graphics.drawRect(0, headerHeight*0.95, listWidth, headerHeight*0.05);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.beginFill(0x000000,0.3);
			headerSprite.graphics.drawRect(0, headerHeight, listWidth, headerHeight*0.05);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.lineStyle(0,Colour.changeBrightness(0x202020, -30));
			headerSprite.graphics.moveTo(0, headerHeight);
			headerSprite.graphics.lineTo(0, headerHeight);
		}
		
		public function addElement(data:String, text:String = "", sprite:Sprite = null):void {
			var item:aUIListItem = new aUIListItem(data, this.listWidth/columns, this.itemHeight);
			listSprite.addChild(item);
			
			item.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
			
			if (text != "") {
				item.addText(text);
			}
			
			if (sprite != null) {
				item.addSprite(sprite);
			}
			
			list.push(item);
			
			orderList();
		}
		
		public function orderList():void {
			var h:Number = 0;
			var w:Number = listWidth / columns;
			var xpos:Number = 0;
			
			for (var i:int = 0; i < list.length; i++) {
				for (var n:int = 0; n < columns; n++) {
					list[i].x = w*n;
					list[i].y = h;
				}
				
				list[i].x = xpos * w;
				list[i].y = h;
				
				if (xpos < columns-1) {
					xpos ++;
				} else {
					xpos = 0;
					h += itemHeight;
				}
				
				listSprite.setChildIndex(list[i], listSprite.numChildren - 1);
			}
		}
		
		private function touchEvent(event:TouchEvent):void {
			trace(event.type);
			switch(event.type) {
				case TouchEvent.TOUCH_BEGIN:
					//this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					
					// A Button is probably selected
					currentSelection = event.target as aUIListItem;
					currentSelection.highlight();
					
					scroll();
				break;
			case TouchEvent.TOUCH_MOVE:
					if (currentSelection) {
						currentSelection.reset();
						currentSelection = null;
					} 
					update(null);
				break;
				//case MouseEvent.MOUSE_UP:
			//		this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					//stopScroll();
				//break;
			}
		}
		
		private var newY:Number = 0;
		private var oldY:Number = 0;
		private var ySpeed:Number;
		
		private function mouseEvent(event:MouseEvent):void {
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					if (currentSelection != null) {
						currentSelection.reset();
						currentSelection = null;
					}
					currentSelection = event.currentTarget as aUIListItem;
					currentSelection.highlight();
					
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					
					if (this.hasEventListener(Event.ENTER_FRAME)) {
						removeEventListener(Event.ENTER_FRAME, velocityUpdate);
					}
					
					scroll();
				break;
				case MouseEvent.MOUSE_MOVE:
					if (currentSelection) {
						currentSelection.reset();
						currentSelection = null;
					}
					
					newY = mouseY;
					ySpeed = newY - oldY;
					oldY = newY;
					
					update(null);
				break;
				case MouseEvent.MOUSE_UP:
					event.preventDefault();
					event.stopImmediatePropagation();
				
					if (currentSelection) {
						dispatchEvent(new Event(Event.SELECT));
					}
					
					applyVelocity();
					
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
				break;
			}
		}
		
		private function applyVelocity():void {
			this.addEventListener(Event.ENTER_FRAME, velocityUpdate);
		}
		
		private function velocityUpdate(event:Event):void {
			listSprite.y += ySpeed;
			ySpeed *= 0.96;
			
			if (listSprite.y > headerHeight) {
				listSprite.y = headerHeight;
				ySpeed = 0;
			} else if ((listSprite.y + listSprite.height) < stage.fullScreenHeight) {
				listSprite.y = stage.fullScreenHeight - listSprite.height;
				ySpeed = 0;
			}
			
			if (Math.abs(ySpeed) < 0.1) {
				this.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
			}
		}
		
		private function back(event:MouseEvent):void {
			dispatchEvent(new Event("back"));
		}
		
		
		private function scroll():void {
			startPosition = listSprite.y;
			mouseStart = mouseY;
			oldY = mouseStart;
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event):void {			
			if (listSprite.height > stage.fullScreenHeight - headerHeight) {
				listSprite.y = startPosition + mouseY - mouseStart;
				
				if (listSprite.y > headerHeight) {
					listSprite.y = headerHeight;
				} else if ((listSprite.y + listSprite.height) < stage.fullScreenHeight) {
					listSprite.y = stage.fullScreenHeight - listSprite.height;
				}
			}
		}
		
		private function stopScroll():void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
	}

}