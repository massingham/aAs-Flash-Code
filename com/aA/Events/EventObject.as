package com.aA.Events {
		
	public class EventObject {
		
		private var _obj:Object;
		private var _event:String;
		private var _func:Function;
		
		/**
		 * 
		 * @param	obj
		 * @param	event
		 * @param	func
		 */
		public function EventObject(obj:Object, event:String, func:Function) {
			this._obj = obj;
			this._event = event;
			this._func = func;
		}
		
		public function get event():String {
			return _event;
		}
		
		public function get func():Function {
			return _func;
		}
		
		public function get obj():Object {
			return _obj;
		}
		
		public function finalize():void {
			
		}
		
	}
}