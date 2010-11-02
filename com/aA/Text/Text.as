package com.aA.Text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Text 
	{
		// font is hardcoded for now, possibly add a static method to set the font ?
		[Embed(source="C:/Windows/Fonts/calibri.ttf", fontName="Calibri", fontWeight="none", advancedAntiAliasing="true", mimeType = "application/x-font")] private var calibri:Class;
		
		/**
		 * Returns a simple TextField
		 * 
		 * @param	text			The Text
		 * @param	size			Font Size
		 * @param	color			Font Colour, DEFAULT : Black
		 * @param	alignment		Alignment, DEFAULT : LEFT
		 * @return
		 */
		public static function getTextField(text:String, size:int, color:uint = 0x000000, alignment:String = "LEFT"):TextField {
			var tf:TextField = new TextField();
			
			var textFormat:TextFormat = new TextFormat("Calibri", size, color);
			textFormat.font = "calibri";
			
			tf.defaultTextFormat = textFormat;
			
			switch(alignment) {
				case "CENTER":
					tf.autoSize = TextFieldAutoSize.CENTER;
				break;
				case "LEFT":
					tf.autoSize = TextFieldAutoSize.LEFT;
				break;
				case "RIGHT":
					tf.autoSize = TextFieldAutoSize.RIGHT;
				break;
			}
			
			tf.htmlText = text;
			tf.selectable = false;
			tf.mouseEnabled = false;
			
			return tf;
		}
		
		/**
		 * Gets a simple input Box
		 * 
		 * @param	width						Width of the Box
		 * @param	height						Height of the Box
		 * @param	size						Font Size
		 * @param	bgColour					Background Colour, DEFAULT : WHITE
		 * @param	fontcolor					Text Colour, DEFAULT : BLACK
		 * @param	alignment					Alignment, DEFAULT : LEFT
		 * @return
		 */
		public static function getInput(width:int, height:int, size:int, bgColour:uint = 0xFFFFFF, fontcolor:uint = 0x000000, alignment:String = "LEFT"):TextField {
			var tf:TextField = getTextField("", size, fontcolor, alignment);
			tf.type = TextFieldType.INPUT;
			
			tf.width = width;
			tf.height = height;
			tf.border = true;
			tf.embedFonts = true;
			
			tf.backgroundColor = bgColour;
			tf.selectable = true;
			
			return tf;
		}
	}

}