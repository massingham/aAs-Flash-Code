package com.aA.Events 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class EventManager 
	{
		private var storedEvents:Dictionary
		
		public function EventManager() 
		{
			storedEvents = new Dictionary();
		}
		
		public function registerEvent(object:IEventDispatcher, id:String, type:String, toDispatch:Event):void {
			storedEvents[id] = toDispatch;
			object.addEventListener(type, forwardEvent);
		}
		
		private function forwardEvent(event:Event):void {
			// dispatchEvent(storedEvents[event.currentTarget.
		}
		
	}

}