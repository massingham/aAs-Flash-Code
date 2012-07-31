package com.aA.Mobile.UI.Behaviour 
{
	import com.aA.Style.StyleManager;
	import com.greensock.BlitMask;
	import com.gskinner.motion.GTween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ScrollableItem extends EventDispatcher
	{
		public static const TYPE_HORIZ:String = "HORIZ";
		public static const TYPE_VERT:String = "VERT";
		
		public static const EVENT_CLEAR:String = "clear";
		public static const EVENT_RELEASE:String = "up";
		public static const EVENT_RESET:String = "reset";
		
		public static const MIN_VELOCITY:Number = 0.8;
		
		private var newPos:Point
		private var oldPos:Point;
		private var speed:Point;
		private var startPosition:Point;
		private var mouseStart:Point;
		public var item:DisplayObject;
		private var visibleArea:Point;
		private var defaultPosition:Point;
		private var bm:BlitMask;
		
		private var type:String;
		
		private var scrollbarTween:GTween;
		
		// all for show milladio
		private var scrollbarSprite:Bitmap;
		
		private var notLargeEnough:Boolean;
		
		public function ScrollableItem(item:DisplayObject, type:String, visibleArea:Point):void {
			this.item = item;
			this.type = type;
			this.visibleArea = visibleArea;
			notLargeEnough = false;
			this.defaultPosition = new Point(item.x, item.y);
			
			if (item.parent != null) {
				addMask(null);
			} else {
				item.addEventListener(Event.ADDED_TO_STAGE, addMask);
			}
			
			newPos = new Point(0, 0);
			oldPos = new Point(0, 0);
			speed = new Point(0, 0);
			startPosition = new Point(0, 0);
			mouseStart = new Point(0, 0);
			
			this.item.addEventListener("reset", resetScroll);
			this.item.addEventListener("refresh", refreshScroll);
			this.item.addEventListener("up", closeUp);
			this.item.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
		}
		
		public function reset():void {
			resetScroll(null);
		}
		
		private function resetScroll(event:Event):void {
			immediateStopMovement();
			this.item.x = defaultPosition.x;
			this.item.y = defaultPosition.y;
			
			newPos = new Point(0, 0);
			oldPos = new Point(0, 0);
			speed = new Point(0, 0);
			startPosition = new Point(0, 0);
			mouseStart = new Point(0, 0);
			
			bm.update(null, true);
			bm.bitmapMode = false;
			drawScrollbar();
			update(null);
		}
		private function refreshScroll(event:Event):void {			
			immediateStopMovement();
			
			bm.update(null, true);
			bm.bitmapMode = false;
			drawScrollbar();
			//update(null);
		}
		
		private function addMask(event:Event):void {
			item.removeEventListener(Event.ADDED_TO_STAGE, addMask);
			
			bm = new BlitMask(item, defaultPosition.x, defaultPosition.y, visibleArea.x, visibleArea.y, false, false, 0xFF000000);
			bm.bitmapMode = false;
			bm.addEventListener(MouseEvent.MOUSE_DOWN, bmDown);
			
			scrollbarSprite = new Bitmap(new BitmapData(10, 10, false, StyleManager.getInstance().getProperty("colour","blue_1")));
			scrollbarSprite.y = defaultPosition.y;
			scrollbarSprite.x = defaultPosition.x + visibleArea.x - 15;
			item.parent.addChild(scrollbarSprite);
			scrollbarSprite.alpha = 0;
			drawScrollbar();
		}
		
		private function drawScrollbar():void {
			// scrollbar as onscreen compared to offscreen values
			if (item.height < visibleArea.y) {
				scrollbarSprite.visible = false;
				return;
			} else if (scrollbarSprite.visible == false) {
				scrollbarSprite.visible = true;
			}
			
			scrollbarSprite.height = visibleArea.y * (visibleArea.y / item.height);	
			
			var p100:Number = (item.y-defaultPosition.y) / (item.height - visibleArea.y);
			var pos:Number = (visibleArea.y - scrollbarSprite.height) * p100;
			
			scrollbarSprite.y = defaultPosition.y - pos;
		}
		
		private function bmDown(event:MouseEvent):void {
			if (bm.bitmapMode) {
				//bm.bitmapMode = false;
				mouseEvent(event);
			}
		}
		
		private function mouseEvent(event:MouseEvent):void { 
			drawScrollbar();
			
			notLargeEnough = false;
			if (type == TYPE_HORIZ) {
				if (item.width < visibleArea.x) {
					notLargeEnough = true;
				}
			} else {
				if (item.height < visibleArea.y) {
					notLargeEnough = true;
				}
			}
			
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					scrollbarTween = new GTween(scrollbarSprite, 0.2, { alpha:1 } );
					
					item.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					
					if (notLargeEnough) {
						//bm.bitmapMode = false;
						return;
					} else {
						bm.update(null, true);
						//bm.bitmapMode = true;
					}
					
					if (item.hasEventListener(Event.ENTER_FRAME)) {
						item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
					}
					
					speed = new Point(0, 0);
					
					scroll();
				break;
			case MouseEvent.MOUSE_MOVE:
					this.dispatchEvent(new Event(EVENT_CLEAR));
					
					if (notLargeEnough) {
						if (bm.bitmapMode) bm.bitmapMode = false;
						return;
					} else {
						if (!bm.bitmapMode) bm.bitmapMode = true;
					}
					
					newPos = new Point(item.stage.mouseX, item.stage.mouseY);
					speed = new Point(newPos.x - oldPos.x, newPos.y - oldPos.y);
					oldPos = newPos.clone();
					
					update(null);
				break;
			case MouseEvent.MOUSE_UP:
					this.dispatchEvent(new Event(EVENT_RELEASE));
					
					if (notLargeEnough) {
						return;
					}
					
					applyVelocity();
					
					item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
				break;
			}
		}
		
		private function closeUp(event:Event):void {
			this.dispatchEvent(new Event(EVENT_RELEASE));
					
			if (notLargeEnough) {
				return;
			}
					
			applyVelocity();
			
			item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
			item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
		}
		
		private function immediateStopMovement():void {
			item.removeEventListener(Event.ENTER_FRAME, update);
			item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
			item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
			
			newPos = new Point(0, 0);
			oldPos = new Point(0, 0);
			speed = new Point(0, 0);
			startPosition = new Point(0, 0);
			mouseStart = new Point(0, 0);
		}
		
		private function applyVelocity():void {
			item.addEventListener(Event.ENTER_FRAME, velocityUpdate);
		}
		
		private function velocityUpdate(event:Event):void {
			if (type == TYPE_HORIZ) {
				item.x += speed.x;
			} else {
				item.y += speed.y;
			}
			
			speed.x *= 0.96;
			speed.y *= 0.96;
			
			// LIMITS
			boundsCheck();
			
			drawScrollbar();
			
			if (type == TYPE_HORIZ) {
				if (Math.abs(speed.x) < MIN_VELOCITY) {
					scrollbarTween = new GTween(scrollbarSprite, 0.5, { alpha:0 } );
					item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);

					bm.bitmapMode = false;
				}
			} else {
				if (Math.abs(speed.y) < MIN_VELOCITY) {
					scrollbarTween = new GTween(scrollbarSprite, 0.5, { alpha:0 } );
					item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
					
					bm.bitmapMode = false;
				}
			}
			
		}
		
		private function boundsCheck():void {
			if (type == TYPE_HORIZ) {
				if (item.x + item.width < visibleArea.x) {
					item.x = visibleArea.x - item.width;
				} else if (item.x > defaultPosition.x) {
					item.x = defaultPosition.x;
				}
			} else {
				if (item.y > defaultPosition.y) {
					item.y = defaultPosition.y;
				} else if (item.y + item.height < visibleArea.y + defaultPosition.y) {
					dispatchEvent(new Event("bottom"));
					refreshScroll(null);
					item.y = defaultPosition.y + (visibleArea.y - item.height);
				}
			}
			
			bm.update();
		}
		
		private function update(event:Event):void {
			if (type == TYPE_HORIZ) {
				item.x = startPosition.x + (item.stage.mouseX - mouseStart.x);
			} else {
				item.y = startPosition.y + (item.stage.mouseY - mouseStart.y);
			}
			
			boundsCheck();
		}
		
		private function stopScroll():void {			
			item.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function scroll():void {
			if (type == TYPE_HORIZ) {
				startPosition.x = item.x;
				mouseStart.x = item.stage.mouseX;
				oldPos.x = mouseStart.x;
			} else {
				startPosition.y = item.y;
				mouseStart.y = item.stage.mouseY;
				oldPos.y = mouseStart.y;
			}
		}
	}

}