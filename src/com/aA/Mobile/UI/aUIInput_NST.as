package com.aA.Mobile.UI 
{
	import com.aA.Colour.Colour;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AutoCapitalize;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import com.aA.Mobile.UI.Style.aUIColourScheme;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * UI Component that uses the stagetext
	 * @author Anthony Massingham
	 */
	public class aUIInput_NST extends aUIComponent
	{
		private var label:String;
		private var labelTF:TextField;
		
		private var textField:TextField;
		private var borderSprite:Sprite;
		private var borderBitmap:Bitmap;
		private var highlightSprite:Sprite;
		
		private var lineMetric:TextLineMetrics;
		
		private var numberOfLines:int = 1;
		private var _displayAsPassword:Boolean = false;
		
		private var theWidth:Number;
		private var theHeight:Number;
		private var fontSize:Number;
		
		private var snapshot:Bitmap;
		
		[Event(name="change",                 type="flash.events.Event")]
		[Event(name="focusIn",                type="flash.events.FocusEvent")]
		[Event(name="focusOut",               type="flash.events.FocusEvent")]
		[Event(name="keyDown",                type="flash.events.KeyboardEvent")]
		[Event(name="keyUp",                  type="flash.events.KeyboardEvent")]
		
		/**
		 * No Stage Text.  This class removes stage text entirely
		 * 
		 * @param	theWidth
		 * @param	theHeight
		 * @param	numLines
		 * @param	label
		 */
		public function aUIInput_NST(theWidth:Number, theHeight:Number, numLines:int, label:String = "label", fontSize:Number = -1) 
		{
			this.theWidth = theWidth;
			this.theHeight = theHeight * numLines;
			this.numberOfLines = numLines;
			this.fontSize = fontSize;
			
			highlightSprite = new Sprite();
			
			textField = new TextField();
			textField.textColor = style.getColour("textColour");
			textField.type = TextFieldType.INPUT;
			
			labelTF = Text.getTextField(label, fontSize, Colour.changeBrightness(style.getColour("inputBGColour"), 30), "LEFT", "_sans", false);
			addChild(labelTF);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.CHANGE, showhideLabel);
		}
		
		public function display():void {
			
		}
		
		private function init(event:Event):void {
			if (fontSize == -1) {
				fontSize = theHeight * .5;
			}
			var textFormat:TextFormat = new TextFormat("_sans", fontSize, style.getColour("textColour"));
			textField.defaultTextFormat = textFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "Qq_9";
			
			var h:Number = textField.height;
			textField.autoSize = TextFieldAutoSize.NONE;
			textField.height = h;
			
			textField.text = "";
			addChild(textField);
			
			
			draw();
		}
		
		public override function draw():void {
			if (this.stage == null || !this.stage.contains(this)) return;
			lineMetric = null;
			
			textField.width = getBorderRectangle().width;
			textField.y = theHeight / 2 - textField.height / 2;
			textField.x = textField.y *1.2;
			
			drawBorder();
			
			labelTF.y = theHeight / 2 - labelTF.height / 2;
			labelTF.x = labelTF.y;
		}
		
		private function getBorderRectangle():Rectangle {
			var fontHeight:Number = getTotalFontHeight();
			
			// text field is actually smaller, and centred
			//return new Rectangle(this.x + textField.fontSize / 4,
			//	 				 this.y + textField.fontSize / 4,
			//					 Math.round(theWidth - textField.fontSize / 4),
			//					 Math.round((totalFontHeight + (totalFontHeight - textField.fontSize)) * numberOfLines) - textField.fontSize / 4);
			
			
			var padding:Number = (theHeight - fontHeight) >> 1;
			
			return new Rectangle(Math.round(this.x + padding),
								Math.round(this.y + padding),
								Math.round(theWidth - (padding << 1)),
								Math.round(theHeight));
		}
		
		private function drawBorder(spr:Sprite = null):void {
			if (spr == null) spr = this;
			spr.graphics.clear();
			spr.graphics.beginFill(style.getColour("inputBGColour"));
			spr.graphics.lineStyle(0, style.getColour(aUIColourScheme.COLOUR_LINE), 1, true);
			spr.graphics.drawRoundRect(0, 0, theWidth, theHeight, style.cornerRadius, style.cornerRadius);
			spr.graphics.endFill();
		}
		
		private function showhideLabel(event:Event):void {
			if (textField.text == "") {
				labelTF.visible = true;
			} else {
				labelTF.visible = false;
			}
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				textField.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				textField.removeEventListener(type, listener, useCapture);
			}
			else
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
		
		private function isEventTypeStageTextSpecific(type:String):Boolean
		{
			return (type == Event.CHANGE ||
					type == FocusEvent.FOCUS_IN ||
					type == FocusEvent.FOCUS_OUT ||
					type == KeyboardEvent.KEY_DOWN ||
					type == KeyboardEvent.KEY_UP);
		}
			
				
		public override function set x(x:Number):void
		{
			super.x = x;
			this.draw();
		}
		
		public override function set y(y:Number):void
		{
			super.y = y;
			this.draw();
		}
		
		public override function get height():Number
		{
			return this.theHeight;
		}
		
		public override function set width(width:Number):void
		{
			this.theWidth = width;
			this.draw();

		}
		
		public override function get width():Number
		{
			return this.theWidth;
		}
		
		/**
		 * Methods borrowed from 'NATIVETEXT.as'
		 */
		
		private function getTotalFontHeight():Number {
			if (lineMetric != null) return (lineMetric.ascent + lineMetric.descent);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = textField.getTextFormat();;
			tf.text = "QgQ_";
			lineMetric = tf.getLineMetrics(0);
			return (lineMetric.ascent + lineMetric.descent);
		}
		
		public override function set visible(visible:Boolean):void
		{
			super.visible = visible;
			textField.visible = visible;
		}
		
		public function get multiline():Boolean
		{
			return textField.multiline;
		}
		
		public function set displayAsPassword(value:Boolean):void {
			textField.displayAsPassword = value;
		}
		
		public function get displayAsPassword():Boolean {
			return textField.displayAsPassword;
		}
		
		public function set text(value:String):void {
			textField.text = value;
			if (textField.text == "") {
				showhideLabel(null);
			}
		}
		
		public function get text():String {
			return textField.text;
		}
		
		public function freeze():void {
			textField.mouseEnabled = false;
			textField.selectable = false;
		}
		
		public function unfreeze():void {
			textField.mouseEnabled = true;
			textField.selectable = true;
		}
		
		public function set frozen(value:Boolean):void {
			if (value) {
				freeze();
			} else {
				unfreeze();
			}
		}
	}

}