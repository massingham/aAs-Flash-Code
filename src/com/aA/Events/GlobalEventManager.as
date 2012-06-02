package com.aA.Events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class GlobalEventManager extends EventDispatcher
	{
		private static var _instance:GlobalEventManager;
		private var storedEvents:Dictionary
		
		public function GlobalEventManager() 
		{
			storedEvents = new Dictionary();
		}
		
		public static function getInstance():GlobalEventManager {
			if (_instance == null) {
				_instance = new GlobalEventManager();
			}
			return _instance;
		}
		
		public function registerEvent(object:IEventDispatcher, type:String, toDispatch:Event):void {
			if (storedEvents[object] != null) {
				if (storedEvents[object] != type) {
					throw new Error("There is already an event stored for this object.  Might want to recode this Anthony");
				}
			}
			storedEvents[object] = toDispatch;
			object.addEventListener(type, forwardEvent);
		}
		
		public function unregisterEvent(object:IEventDispatcher):void {
			if(storedEvents[object] != null) {
				object.removeEventListener(storedEvents[object], forwardEvent);
				storedEvents[object] = null;
			}
		}
		
		private function forwardEvent(event:Event):void {
			trace("Attempting to forward an event");
			dispatchEvent(storedEvents[event.currentTarget]);
		}
		
	}

}