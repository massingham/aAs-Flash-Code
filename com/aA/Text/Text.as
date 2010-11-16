package com.aA.Text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import flash.text.Font;
	import flash.text.AntiAliasType;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Text 
	{
		// UNICODE RANGE REFERENCE
		/*
		Default ranges
			U+0020-U+0040, // Punctuation, Numbers
			U+0041-U+005A, // Upper-Case A-Z
			U+005B-U+0060, // Punctuation and Symbols
			U+0061-U+007A, // Lower-Case a-z
			U+007B-U+007E, // Punctuation and Symbols
		Extended ranges (if multi-lingual required)
			U+0080-U+00FF, // Latin I
			U+0100-U+017F, // Latin Extended A
			U+0400-U+04FF, // Cyrillic
			U+0370-U+03FF, // Greek
			U+1E00-U+1EFF, // Latin Extended Additional
		*/
 
		// [Embed(source = 'C:/Windows/Fonts/CALIBRI.TTF', fontName = 'MY_FONT', fontWeight = 'regular', unicodeRange ='U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E', mimeType = 'application/x-font', embedAsCFF="false")]
		// private static var myFont:String;
		
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
			
			//Font.registerFont(CalibriFont);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "MY_FONT";
			textFormat.size = size;
			textFormat.color = color;
			
			tf.embedFonts = true;
			
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
			
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.defaultTextFormat = textFormat;
			tf.htmlText = text;
			
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