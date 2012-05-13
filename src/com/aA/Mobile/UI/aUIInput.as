package com.aA.Mobile.UI 
{
	import com.aA.Colour.Colour;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AutoCapitalize;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextField;
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
	public class aUIInput extends aUIComponent
	{
		private var label:String;
		private var labelTF:TextField;
		
		private var textField:StageText;
		private var borderSprite:Sprite;
		private var borderBitmap:Bitmap;
		private var highlightSprite:Sprite;
		
		private var lineMetric:TextLineMetrics;
		
		private var numberOfLines:int = 1;
		private var _displayAsPassword:Boolean = false;
		
		private var theWidth:Number;
		private var theHeight:Number;
		
		private var snapshot:Bitmap;
		
		[Event(name="change",                 type="flash.events.Event")]
		[Event(name="focusIn",                type="flash.events.FocusEvent")]
		[Event(name="focusOut",               type="flash.events.FocusEvent")]
		[Event(name="keyDown",                type="flash.events.KeyboardEvent")]
		[Event(name="keyUp",                  type="flash.events.KeyboardEvent")]
		[Event(name="softKeyboardActivate",   type="flash.events.SoftKeyboardEvent")]
		[Event(name="softKeyboardActivating", type="flash.events.SoftKeyboardEvent")]
		[Event(name="softKeyboardDeactivate", type="flash.events.SoftKeyboardEvent")]
		
		/**
		 * 
		 * @param	theWidth
		 * @param	theHeight
		 * @param	numLines
		 * @param	label
		 */
		public function aUIInput(theWidth:Number, theHeight:Number, numLines:int, label:String = "label") 
		{
			this.theWidth = theWidth;
			this.theHeight = theHeight * numLines;
			this.numberOfLines = numLines;
			
			highlightSprite = new Sprite();
			
			var stio:StageTextInitOptions = new StageTextInitOptions((this.numberOfLines > 1));
			textField = new StageText(stio);
			textField.autoCorrect = false;
			textField.color = style.getColour("textColour");
			
			labelTF = Text.getTextField(label, theHeight >> 1, Colour.changeBrightness(style.getColour("inputBGColour"), 30), "LEFT", "_sans", false);
			addChild(labelTF);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.CHANGE, showhideLabel);
		}
		
		private function init(event:Event):void {
			textField.stage = this.stage;
			textField.fontFamily = "_sans";
			textField.fontSize = theHeight * 0.5;
			
			draw();
		}
		
		public override function draw():void {
			if (this.stage == null || !this.stage.contains(this)) return;
			lineMetric = null;
			textField.viewPort = getBorderRectangle();
			drawBorder();
			
			labelTF.y = theHeight / 2 - labelTF.height / 2;
			labelTF.x = labelTF.y;
		}
		
		private function getBorderRectangle():Rectangle {
			var fontHeight:Number = getTotalFontHeight();
			var padding:Number = (theHeight - fontHeight) >> 1;
			
			/*var returnRectangle:Rectangle = new Rectangle(Math.round(this.x + padding),
								Math.round(this.y + padding),
								Math.round(theWidth - (padding << 1)),
								Math.round(theHeight));*/
			// var globalCoords:Point = this.localToGlobal(new Point(this.x, this.y));
			var globalCoords:Point = new Point(this.x + padding, this.y + padding);
			var returnRectangle:Rectangle = new Rectangle(globalCoords.x,
								globalCoords.y,
								Math.round(theWidth - (padding << 1)),
								Math.round(theHeight));
								
			var s:Sprite = new Sprite();
			//this.stage.addChild(s);
			//s.graphics.beginFill(0xFF00AA);
			//s.graphics.drawRect(returnRectangle.x, returnRectangle.y, returnRectangle.width, returnRectangle.height);
			//s.graphics.endFill();
			
			return returnRectangle;
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
					type == KeyboardEvent.KEY_UP ||
					type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE ||
					type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING ||
					type == SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			textField.dispose();
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
			var textFormat:TextFormat = new TextFormat(textField.fontFamily, textField.fontSize, null, (textField.fontWeight == FontWeight.BOLD), (textField.fontPosture == FontPosture.ITALIC));
			tf.defaultTextFormat = textFormat;
			tf.text = "QgQ_";
			lineMetric = tf.getLineMetrics(0);
			return (lineMetric.ascent + lineMetric.descent);
		}
		
		/**
		 * 
		 */
		
		 public function set autoCapitalize(autoCapitalize:String):void
		{
			textField.autoCapitalize = autoCapitalize;
		}
		
		public function set autoCorrect(autoCorrect:Boolean):void
		{
			textField.autoCorrect = autoCorrect;
		}
		
		public function set color(color:uint):void
		{
			textField.color = color;
		}
		
		public function set editable(editable:Boolean):void
		{
			textField.editable = editable;
		}
		
		public function set fontFamily(fontFamily:String):void
		{
			textField.fontFamily = fontFamily;
		}
		
		public function set fontPosture(fontPosture:String):void
		{
			textField.fontPosture = fontPosture;
		}

		public function set fontSize(fontSize:uint):void
		{
			textField.fontSize = fontSize;
			this.draw();
		}

		public function set fontWeight(fontWeight:String):void
		{
			textField.fontWeight = fontWeight;
		}
		
		public function set locale(locale:String):void
		{
			textField.locale = locale;
		}
		
		public function set maxChars(maxChars:int):void
		{
			textField.maxChars = maxChars;
		}
		
		public function set restrict(restrict:String):void
		{
			textField.restrict = restrict;
		}
		
		public function set returnKeyLabel(returnKeyLabel:String):void
		{
			textField.returnKeyLabel = returnKeyLabel;
		}
		
		public function get selectionActiveIndex():int
		{
			return textField.selectionActiveIndex;
		}
		
		public function get selectionAnchorIndex():int
		{
			return textField.selectionAnchorIndex;
		}
		
		public function set softKeyboardType(softKeyboardType:String):void
		{
			textField.softKeyboardType = softKeyboardType;
		}
		
		public function set textAlign(textAlign:String):void
		{
			textField.textAlign = textAlign;
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
		
		public function assignFocus():void
		{
			textField.assignFocus();
		}
		
		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			textField.selectRange(anchorIndex, activeIndex);
		}
		
		public function set displayAsPassword(value:Boolean):void {
			textField.displayAsPassword = value;
			if (value) {
				textField.autoCorrect = false;
				textField.autoCapitalize = AutoCapitalize.NONE;
			}
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
			//if (snapshot != null && this.contains(snapshot)) return;
			//if (!textField) return;
			//if (!textField.viewPort) return;
			
			//var viewPort:Rectangle = this.getBorderRectangle();
			//var border:Sprite = new Sprite();
			//drawBorder(border);
			
			//var bmd:BitmapData = new BitmapData(textField.viewPort.width, textField.viewPort.height, true, 0x00000000);
			//textField.drawViewPortToBitmapData(bmd);
			
			//bmd.draw(border, new Matrix(1, 0, 0, 1, this.x - viewPort.x, this.y - viewPort.y));
			
			//snapshot = new Bitmap(bmd);
			//snapshot.x = viewPort.x - this.x;
			//snapshot.y = viewPort.y - this.y;
			
			//addChild(snapshot);
			
			textField.visible = false;
		}
		
		public function unfreeze():void {
			//if (snapshot != null && this.contains(snapshot)) {
			//	this.removeChild(snapshot);
			//	snapshot = null;
				textField.visible = true;
			//}
		}
		
		public function set frozen(value:Boolean):void {
			if (value) {
				freeze();
			} else {
				unfreeze();
			}
		}
		
		public function display():void {
			draw();
		}
	}

}