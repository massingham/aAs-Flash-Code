package aA.Utils {
	
	import flash.events.*;
	import flash.net.*;
	
	public class XMLLoader extends EventDispatcher{
		
		private var XMLUrl:String;
		private var theXML:XML;
		
		public function XMLLoader(url:String):void {
			// Add .xml on the end if it's not there
			if(url.substring(url.length-4,url.length)!=".xml"){
				url+=".xml";
			}
			
			XMLUrl = url;
			loadXML(XMLUrl);		
		}
		
		private function loadXML(url:String):void{
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, inputError);
		}
		
		private function loadComplete(event:Event):void{
			var loader:URLLoader = URLLoader(event.target);
			var xml:XML = XML(loader.data);
		
			theXML = xml;
			
			dispatchEvent(new Event("complete"));
		}
		
		private function inputError(evt:Event):void{
			trace("IO ERROR : " + evt.target);
		}
		
		public function getXML():XML{
			return theXML;
		}
			
	}
	
}