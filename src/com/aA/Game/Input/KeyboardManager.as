package com.aA.Game.Input 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	* add these :
	* 
	*	stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyboardManager.getInstance().onKeyDown);
	*	stage.addEventListener(KeyboardEvent.KEY_DOWN, muteSounds);
	*	stage.addEventListener(KeyboardEvent.KEY_UP, KeyboardManager.getInstance().onKeyUp);
	*	stage.addEventListener(Event.ENTER_FRAME, KeyboardManager.getInstance().update);
	* @author Anthony Massingham
	*/
	public class KeyboardManager extends EventDispatcher
	{
		private static var _instance:KeyboardManager;
		private var binds:Array;
		private var activeBinds:Array;
		
		public function KeyboardManager() 
		{
			binds = new Array();
			activeBinds = new Array();
		}
		
		public static function getInstance():KeyboardManager {
			if (_instance == null) {
				_instance = new KeyboardManager();
			}
			
			return _instance;
		}
		
		public function onKeyDown(e:KeyboardEvent):void {			
			dispatchEvent(e);
			
			var command:String = binds[e.keyCode];
			if (command == null) return;
			var commandEvent:Event = new Event(command);
			activeBinds[command] = commandEvent;
		}
		
		public function onKeyUp(e:KeyboardEvent):void {
			dispatchEvent(e);
			
			var command:String = binds[e.keyCode];
			if (command == null) return;
			activeBinds[command] = null;
		}
		
		public function bindKey(keycode:uint, command:String):void {
			binds[keycode] = command;
		}
		
		public function unbindKey(keycode:uint):void {
			binds[keycode] = null;
		}
		
		public function update(e:Event):void {
			for each (var evt:Event in activeBinds) {
				if (evt != null) {
					dispatchEvent(evt);
				}
			}
		}
	}

}