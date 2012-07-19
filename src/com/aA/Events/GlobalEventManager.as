package com.aA.Events 
{
	import com.Kondoot.KMA.Events.DataEvent;
	import flash.display.DisplayObject;
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
		
		public function registerEvent(object:DisplayObject, displayObject:Boolean, type:String, toDispatch:Event):void {
			var id:String = object.name;
			if (storedEvents[id] != null) {
				if (storedEvents[id] != type) {
					throw new Error("There is already an event stored for this object.  Might want to recode this Anthony");
				} 
			}
			
			storedEvents[id] = toDispatch;
			object.addEventListener(type, forwardEvent, false, 0, true)
			
			if (displayObject) {
				object.addEventListener(Event.REMOVED_FROM_STAGE, removeEvent, false, 0, true);
			}
		}
		
		private function removeEvent(event:Event):void {
			storedEvents[event.currentTarget.name] = null;
		}
		
		public function unregisterEvent(object:DisplayObject):void {
			if(storedEvents[object.name] != null) {
				object.removeEventListener(storedEvents[object.name], forwardEvent);
				storedEvents[object.name] = null;
			}
		}
		
		private function forwardEvent(event:Event):void {
			trace("Attempting to forward an event");
			dispatchEvent(storedEvents[event.currentTarget.name]);
		}
		
		public function sendGlobalEvent(event:Event):void {
			dispatchEvent(event);
		}
		
	}

}