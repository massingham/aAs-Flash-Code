package com.aA.Utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Preloader Factory Class
	 * Base code from 'AS3 with Preloader' template file from flashdevelop
	 * 
	 * Just have to add '[Frame(factoryClass="Preloader")]' to the start of the Main.as file
	 * 
	 * @author Anthony Massingham
	 */
	public class PreloaderFactory extends MovieClip 
	{
		private var lastPercent:Number = 0;
		private var textPercent:TextField;
		private var format:TextFormat
		
		public function PreloaderFactory() 
		{			
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			// Initialise the %TF
			textPercent = new TextField();
			format = new TextFormat("Calibri", 20, 0xFFFFFF, true);
			textPercent.text = "000 %";
			format.align = TextFormatAlign.RIGHT;			
			textPercent.defaultTextFormat = format;
			textPercent.autoSize = TextFieldAutoSize.CENTER;
			textPercent.selectable = false;
			addChild(textPercent);
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			
		}
		
		private function checkFrame(e:Event):void 
		{
			var loaded:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			var percent:Number = Math.round(loaded * 100);
			
			var ax:Number = (percent - lastPercent) * 0.1;
			lastPercent += ax;
			
			textPercent.x = (stage.stageWidth * (lastPercent / 100)) - textPercent.width - 10;
			textPercent.y = (stage.stageHeight / 2) + 30 - textPercent.height;
			textPercent.text = Math.round(lastPercent) + " %";
			
			graphics.clear();
			graphics.beginFill(0, 0.1);
			graphics.drawRect(0, stage.stageHeight / 2, stage.stageWidth, 30);
			graphics.endFill();
			
			graphics.beginFill(0, 0.9);
			graphics.drawRect(0, stage.stageHeight / 2, stage.stageWidth * (lastPercent / 100), 30);
			graphics.endFill();
						
			//if (currentFrame == totalFrames) 
			if (Math.round(lastPercent) == 100)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			graphics.clear();
			removeChild(textPercent);
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			if (parent == stage) stage.addChildAt(new mainClass() as DisplayObject, 0);
			else addChildAt(new mainClass() as DisplayObject, 0);
		}
		
	}
	
}