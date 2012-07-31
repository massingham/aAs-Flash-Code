package com.aA.Mobile.UI.InfiniteSwipeList 
{
	import com.aA.Game.SpriteManager;
	import com.aA.Style.StyleManager;
	import com.aA.Text.Text;
	import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.easing.Elastic;
	import com.gskinner.motion.easing.Sine;
	import com.gskinner.motion.GTween;
	import com.Kondoot.API.Data.DataManager;
	import com.Kondoot.API.Data.VideoObject;
	import com.Kondoot.KMA.Views.Popup.BannerPopup.BannerPopupManager;
	import com.Kondoot.MobileTools.Controller.MobileController;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.system.TouchscreenType;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class InfiniteSwipeList extends Sprite
	{
		private static const NUM_ITEMS:int = 4;	// Number of items to store at all times, it will recycle these.
		private static const SWIPE_SPEED:Number = 0.2;
		private var items:Vector.<InfiniteSwipeItem>;
		private var currentVisibleItem:InfiniteSwipeItem
		
		private var visibleItem:int = 0;
		private var currentItem:int = 0;
		private var minItem:int;
		private var maxItem:int;
		private var listWidth:Number;
		private var listHeight:Number;
		
		private var itemWidth:Number;
		private var itemHeight:Number;
		
		private var tempLeftClickArea:Sprite;
		private var tempRightClickArea:Sprite;
		
		private var itemSprite:Sprite;
		
		private var tween:GTween;
		
		// DATA
		private var noMore:Boolean;
		private var pending:Boolean;
		private var currentOffset:Number;
		private var currentLimit:Number;		
		private var call:String;
		private var params:Array;
		private var waiting:Boolean;
		
		public var currentListData:Array;
		
		private var tutorialBlackout:Sprite;
		private var tutorialAnimation:MovieClip;
		private var tutorialShown:Boolean;
		private var loadingBG:Sprite;
		private var loadingSprite:MovieClip;
		
		private var noVideosNotification:Sprite;
		
		private var _postCall:Function;
		
		private var desktopMode:Boolean;
		
		public function InfiniteSwipeList(listWidth:Number, listHeight:Number) 
		{
			itemWidth = listWidth;
			itemHeight = listHeight;
			tutorialShown = false;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function get numItems():Number {
			return NUM_ITEMS;
		}
		
		public function setVidItems(inputItems:Array):void {
			/**for (var i:int = 0; i < NUM_ITEMS; i++) {
				var item:InfiniteSwipeItem = new InfiniteSwipeItem(itemWidth, itemHeight);
				itemSprite.addChild(item);
				items[i] = item;
				
				item.x = itemWidth * i;
			}**/
			
			if (inputItems.length != NUM_ITEMS) return;
			
			items = new Vector.<InfiniteSwipeItem>(NUM_ITEMS);
			
			for (var i:int = 0; i < inputItems.length; i++) {
				itemSprite.addChild(inputItems[i]);
				items[i] = inputItems[i];
				
				if (DataManager.getInstance().firstLoad()) {
					items[i].addEventListener("tutorial_shown", clearTutorialStatus);
				}
			}
			
			draw();
		}
		
		private function clearTutorialStatus(event:Event):void {
			for (var i:int = 0; i < items.length; i++) {
				items[i].removeEventListener("tutorial_shown", clearTutorialStatus);
				items[i].tutorialShown = false;
			}
		}
		
		private function init(event:Event):void {
			currentOffset = 0;
			currentLimit = 10;
			currentListData = new Array();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			waiting = false;
			minItem = 0;
			maxItem = (NUM_ITEMS - 1);
			
			itemSprite = new Sprite();
			addChild(itemSprite);
			
			itemSprite.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			
			tempLeftClickArea = new Sprite();
			tempLeftClickArea.graphics.beginFill(0, 0);
			tempLeftClickArea.graphics.drawRect(0, 0, 10, itemHeight);
			tempLeftClickArea.graphics.endFill();
			
			tempRightClickArea = new Sprite();
			tempRightClickArea.graphics.beginFill(0, 0);
			tempRightClickArea.graphics.drawRect(0, 0, 10, itemHeight);
			tempRightClickArea.graphics.endFill();
			tempRightClickArea.x = itemWidth - tempRightClickArea.width;
			
			addChild(tempLeftClickArea);
			addChild(tempRightClickArea);
			
			if (Capabilities.os == "Windows 7") {
				desktopMode = true;
				
				this.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
				tempRightClickArea.buttonMode = true;
				tempLeftClickArea.buttonMode = true;
			} else {
				removeChild(tempLeftClickArea);
				removeChild(tempRightClickArea);
			}
			
			currentItem = 0;
			
			noVideosNotification = new Sprite();
			noVideosNotification.graphics.beginFill(0xC4C4C4);
			noVideosNotification.graphics.drawRect(0, 0, itemWidth, itemHeight * .1);
			noVideosNotification.graphics.endFill();
			
			var novidsTF:TextField = Text.getTextField("Sorry, no videos!", 10, 0x646464, "LEFT", "_sans", false);
			noVideosNotification.addChild(novidsTF);
			novidsTF.x = itemWidth / 2 - novidsTF.width / 2;
			novidsTF.y = noVideosNotification.height / 2 - novidsTF.height / 2;
			
			noVideosNotification.visible = false;
			noVideosNotification.y = itemHeight / 2 - noVideosNotification.height / 2;
			
			addChild(noVideosNotification);
			
			loadingSprite = new loading_rings();
			loadingBG = new Sprite();
			addChild(loadingBG);
			loadingBG.graphics.beginFill(0, 0.8);
			loadingBG.graphics.drawRect(0, 0, itemWidth, itemHeight);
			loadingBG.graphics.endFill();
			
			loadingBG.addChild(loadingSprite);
			
			loadingSprite.width = itemWidth * .1;
			loadingSprite.scaleY = loadingSprite.scaleX;
			loadingSprite.x = itemWidth / 2;
			loadingSprite.y = itemHeight / 2;
			
			loadingBG.visible = false;
			loadingSprite.stop();
		}
		
		private function onSwipe(event:TransformGestureEvent):void {
			if (event.offsetX == 1) {
				swipeRight();
			} else if (event.offsetX == -1) {
				swipeLeft();
			}
		}
		
		private function onClick(event:MouseEvent):void {
			if (event.target == tempRightClickArea) {
				swipeLeft();
			} else if (event.target == tempLeftClickArea) {
				swipeRight();
			}
		}
		
		private function displayBannerMessage(title:String, msg:String):void {
			BannerPopupManager.getInstance().newPopup(title, msg, 3000);
		}
		
		private function swipeLeft():void {			
			if(currentItem + 1 == currentListData.length){
				// add 'waiting', 'display : ' more!' when more is loaded
				if (noMore) {
					displayBannerMessage("That's it!", "No more videos");
				} else {
					displayBannerMessage("Hold on!", "We're loading more videos...");
					waiting = true;
				}
			} else {
				items[visibleItem].currentSelection = false;
				
				currentItem++;
				visibleItem++;
				presort();
				tween = new GTween(itemSprite, SWIPE_SPEED, { x: 0 - (currentItem * itemWidth) }, { ease:Sine.easeInOut, onComplete: onSwipeComplete} );
			
				checkData();
			}			
		}
		
		private function swipeRight():void {			
			if (currentItem == 0) {
				itemSprite.x = 10;
				visibleItem = 0;
				tween = new GTween(itemSprite, SWIPE_SPEED, { x: 0 - (currentItem * itemWidth) } , { ease:Sine.easeIn } );
			} else {
				items[visibleItem].currentSelection = false;
				currentItem--;
				visibleItem--;
				presort();
				tween = new GTween(itemSprite, SWIPE_SPEED, { x: 0 - (currentItem * itemWidth) }, { ease:Sine.easeInOut, onComplete: onSwipeComplete } );
			}
		}
		
		private function onSwipeComplete(tween:GTween):void {
			trace("visible item is : " +visibleItem);
			displayCurrentItem();
		}
		
		// Moves the internal workings around to ensure that there is always an item on the left, and right hand side of the current viewable item
		private function presort():void {
			if (currentItem + 1 > maxItem) {
				// move one from the front, to the end
				var frontItem:InfiniteSwipeItem = items[0];
				frontItem.clear();
				items.splice(0, 1);
				items[NUM_ITEMS - 1] = frontItem;
				
				maxItem++;
				minItem++;
				visibleItem--;
				draw();
			} else if (currentItem - 1 < minItem && currentItem - 1 >= 0) {
				// move from from the end to the front
				var rearItem:InfiniteSwipeItem = items.pop();
				rearItem.clear();
				items.splice(0, 0, rearItem);
				
				maxItem--;
				minItem--;
				visibleItem++;
				draw();
			}
		}
		
		public function display():void {
			
		}
		
		private function draw():void {
			for (var i:int = 0; i < items.length; i++) {
				items[i].x = (itemWidth * (i + minItem));
			}
		}
		
		/**
		 * shows a quick action tutorial
		 */
		public function showTutorial():void {
			if (tutorialShown) return;
			
			tutorialBlackout = new Sprite();
			addChild(tutorialBlackout);
			
			tutorialBlackout.graphics.beginFill(0, 0.5);
			tutorialBlackout.graphics.drawRect(0, 0, itemWidth, itemHeight);
			tutorialBlackout.graphics.endFill();
			
			// 215 is the normal width
			tutorialAnimation = new anim_swipe();
			tutorialBlackout.addChild(tutorialAnimation);
			
			tutorialAnimation.height = itemHeight * .7;
			tutorialAnimation.scaleX = tutorialAnimation.scaleY;
			
			tutorialAnimation.x = itemWidth / 2 - (107 * tutorialAnimation.scaleX);
			tutorialAnimation.y = itemHeight / 2 - tutorialAnimation.height / 2;
			
			tutorialBlackout.addEventListener(MouseEvent.MOUSE_DOWN, removeTutorial);
		}
		
		private function removeTutorial(event:MouseEvent):void {
			tutorialBlackout.removeEventListener(MouseEvent.MOUSE_DOWN, removeTutorial);
			tutorialBlackout.removeChild(tutorialAnimation);
			removeChild(tutorialBlackout);
			tutorialAnimation = null;
			tutorialBlackout = null;
			tutorialShown = true;
		}
		
		/**
		 * DATA 
		 */
		
		public function setOffset(offsetValue:Number):void {
			currentOffset = offsetValue;
		}
		
		public function setLimit(limitValue:Number):void {
			currentLimit = limitValue;
		}
		
		public function increaseOffset():void {
			currentOffset += currentLimit;
		}
		
		public function setCall(call:String, params:Array = null):void {
			disableNavigation();
			
			this.call = call;
			this.params = params;
			
			reset();
		}
		
		public function reset():void {
			if (itemSprite.visible == false) {
				itemSprite.visible = true;
			}
			noVideosNotification.visible = false;
			items[visibleItem].currentSelection = false;
			noMore = false;
			currentListData = new Array();
			currentOffset = 0;
			currentItem = 0;
			visibleItem = 0;
			minItem = 0;
			maxItem = (NUM_ITEMS - 1);
			
			for (var i:int = 0; i < items.length; i++) {
				items[i].clear();
			}
			
			itemSprite.x = 0;
			draw();
		}
		
		private function loadNext(event:Event):void {
			if (noMore) return;
			if (call == null) return;
			
			if (!pending) {
				doCall();		
			}
		}
		
		private function checkData():void {
			if (currentItem + NUM_ITEMS >= currentOffset) {
				loadNext(null);
			}
		}
		
		public function doCall(specialFunction:Function = null):void {
			_postCall = specialFunction;
			pending = true;
			
			var submitParams:Array = [ { name:"offset", data:currentOffset }, { name:"limit", data:currentLimit } ];
			if (params) {
				for (var i:int = 0; i < params.length; i++) {
					submitParams.push(params[i]);
				}
			} 
			
			MobileController.getInstance().addSingleCall(call, "GET", onCallReturn, null, submitParams);
		}
		
		private function parseData(data:Array):void {
			for (var i:int = 0; i < data.length; i++) {
				var vid:VideoObject = VideoObject.createFromObject(data[i].video);
				currentListData.push(vid);
			}
			if (currentItem == 0) {
				displayCurrentItem();
			}
		}
		
		public function refresh():void {
			disableNavigation();
			doCall();
		}
		
		private function displayCurrentItem():void {
			items[visibleItem].sendContent(currentListData[currentItem]);
		}
		
		public function onCallReturn(data:Array):void {
			data = data["result"];
			
			enableNavigation();
			
			if (data == null) {
				trace("data is null");
				return;
			}
			
			if (data.length != 0) {
				parseData(data);
				increaseOffset();
				
				if(waiting)	displayBannerMessage("All Done!", "More videos this way!");
			} else {
				trace("data length is 0");
				if (currentListData.length == 0) {
					noItemDisplay();
				} else {
					displayBannerMessage("That's it!", "No more videos");
				}
				noMore = true;
			}
			
			waiting = false;
			pending = false;
			
			if (_postCall != null) {
				_postCall(data);
			}
		}
		
		private function noItemDisplay():void {
			itemSprite.visible = false;
			noVideosNotification.visible = true;
		}
		
		public function enableNavigation():void {
			itemSprite.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			if(desktopMode){
				tempLeftClickArea.mouseEnabled = true;
				tempRightClickArea.mouseEnabled = true;
			}
			
			loadingBG.visible = false;
			loadingSprite.stop();
		}
		
		public function disableNavigation():void {
			itemSprite.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			if(desktopMode){
				tempLeftClickArea.mouseEnabled = false;
				tempRightClickArea.mouseEnabled = false;
			}
			
			loadingBG.visible = true;
			loadingSprite.play();
		}
	}

}