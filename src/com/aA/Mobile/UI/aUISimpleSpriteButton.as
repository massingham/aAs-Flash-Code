package com.aA.Mobile.UI 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class aUISimpleSpriteButton extends aUIComponent
	{
		// Some default states
		private var states:Dictionary;
		
		protected var theWidth:Number;
		protected var theHeight:Number;
		
		private var displaySprite:Sprite;
		private var hitSprite:Sprite;
		
		private var currentState:String;
		private var targetState:String;		// Used in fades
		
		public function aUISimpleSpriteButton(theWidth:Number, theHeight:Number) 
		{
			this.theHeight = theHeight;
			this.theWidth = theWidth;
			this.buttonMode = true;
			
			states = new Dictionary();
			
			displaySprite = new Sprite();
			hitSprite = new Sprite();
			
			addChild(displaySprite);
			addChild(hitSprite);
			
			hitSprite.graphics.beginFill(0);
			hitSprite.graphics.drawRect(0, 0, theWidth, theHeight);
			hitSprite.graphics.endFill();
			
			hitSprite.alpha = 0;
			
			currentState = "";
		}
		
		/**
		 * 
		 * @param	state
		 * @param	stateIcon
		 */
		public function addState(state:String, stateIcon:DisplayObject, event:MouseEvent = null, useInputDimensions:Boolean = false):void {
			if (event) {
				hitSprite.addEventListener(event.type, mEvent);				
				states[event.type] = stateIcon;
			} else {
				states[state] = stateIcon;
			}
			
			if(!useInputDimensions){
				stateIcon.width = theWidth;
				stateIcon.height = theHeight;
			} else {
				theWidth = stateIcon.width;
				theHeight = stateIcon.height;
				
				hitSprite.graphics.clear();
				hitSprite.graphics.beginFill(0);
				hitSprite.graphics.drawRect(0, 0, theHeight, theHeight);
				hitSprite.graphics.endFill();
			}
			
			stateIcon.visible = false;
			displaySprite.addChild(stateIcon);
			
			if (currentState == "") {
				setState(state);
			}
		}
		
		public function get state():String {
			return currentState;
		}
		
		/**
		 * 
		 * @param	state
		 */
		public function setState(state:String):void {
			if (state == currentState) return;
			if (currentState != "") {
				states[currentState].visible = false;
			}
			currentState = state;
			if (states[currentState] == null) {
				throw new Error("State doesn't exist : " + currentState);
			}
			states[currentState].visible = true;
			states[currentState].alpha = 1;
		}
		
		public function fadeToState(state:String):void {
			if (currentState == state) return;
			targetState = state;
			
			states[targetState].alpha = 0;
			states[targetState].visible = true;
			
			states[currentState].alpha = 1;
			
			addEventListener(Event.ENTER_FRAME, crossfade);
		}
		
		private function crossfade(event:Event):void {
			states[targetState].alpha += 0.05;
			states[currentState].alpha -= 0.05;
			
			if (states[currentState].alpha <= 0.1) {
				states[currentState].visible = false;
				states[currentState].alpha = 1;
				
				setState(targetState);
				targetState = "";
				removeEventListener(Event.ENTER_FRAME, crossfade);
			}
		}
		
		private function mEvent(event:MouseEvent):void {
			if (states[event.type]) {
				setState(event.type);
			}
		}
		
		public function enable():void {
			this.alpha = 1;
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		public function disable():void {
			this.alpha = 0.5;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
	}

}