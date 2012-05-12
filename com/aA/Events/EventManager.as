package com.aA.Events {
	
	import flash.events.IEventDispatcher;
	
	// 'stolen' from http://www.actionscript.org/resources/articles/1098/6/ActionScript-30-Best-Practices-Using-the-EventCollector-Class/Page6.html
	
	public class EventManager implements IEventDispatcher {
		
		private var objects:Array;
		
		public function EventManager() {
			
		}
		
		/**
		 * Returns the number of events registered within this Object
		 */
		public function get length():Number {
			
		}
		
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener recieves notification of an event;
		 * 
		 * @param	obj
		 * @param	event
		 * @param	func
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addEvent(obj:IEventDispatcher, event:String, func:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
		}
		
		public function addEventCollection(obj:Object, func:Function, events:Array, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
		}
		
		public function addOneShotEvent(obj:IEventDispatcher, event:String, func:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
		}
		
		public function finalise():void {
			
		}
		
		public function getEventAt(index:int):EventObject {
			
		}
		
		public function hasRegisteredEvent(obj:Object, event:String, func:Function):Object {
			
		}
		
		public function removeAllEvents():void {
			
		}
		
		public function removeEvent(obj:Object, event:String, func:Function):void {
			
		}
		
		public function removeEventAt(index:int):void {
			
		}
		
		public function removeEventsByClassDefinition(classDefinition:Class):void {
			
		}
		
		public function removeEventsCollection(collection:Array, event:String, func:Function):void {
			
		}
		
		public function removeObjectEvents(obj:Object):void {
			
		}		
	}
}