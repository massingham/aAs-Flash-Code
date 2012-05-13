package com.aA.Game.Console
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import com.aA.Text.Text;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Console extends Sprite
	{
		private static var _instance:Console;
		
		private var consoleSprite:Sprite;
		private var consoleText:TextField;
		private var inputText:TextField;
		private var open:Boolean;
		private var commands:Dictionary;
		
		private var w:Number = 800;
		private var h:Number = 200;
		
		public function Console(e:SingletonEnforcer) 
		{
			open = false;
			commands = new Dictionary();
			
			consoleSprite = new Sprite();
			addChild(consoleSprite);
			
			consoleText = Text.getTextField("Console Created\n\n", 10, 0xFFFFFF, "LEFT", "Courier New", false);
			consoleSprite.addChild(consoleText);
			consoleText.autoSize = "none";
			consoleText.width = w;
			consoleText.height = h - 30;
			consoleText.selectable = true;
			consoleText.mouseEnabled = true;
			
			inputText = Text.getInput(800, 20, 12);
			consoleSprite.addChild(inputText);
			inputText.y = h - 20;
			inputText.addEventListener(KeyboardEvent.KEY_DOWN, checkforenter);
			inputText.restrict = "a-z A-Z 0-9 _";
			
			consoleSprite.graphics.beginFill(0x000000, 0.8);
			consoleSprite.graphics.drawRect(0, 0, w, h);
			consoleSprite.graphics.endFill();
			
			consoleSprite.visible = false;
			
			addCommand("commands", showcommands);
			
			addLine("Type 'commands' to List all commands\n");
			
			this.addEventListener(Event.ADDED_TO_STAGE, keySetup);
		}
		
		private function keySetup(event:Event):void {
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, openClose);
		}
		
		private function openClose(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case 192:
					this.toggleConsole();
				break;
			}
		}
		
		public static function getInstance():Console {
			if (_instance == null) {
				_instance = new Console(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		public function addCommand(commandName:String, runFunction:Function):void {
			if (runFunction == null) {
				commands[commandName] = "dispatch";
			} else {
				commands[commandName] = runFunction;
			}
		}
		
		private function showcommands(params:Array):void {
			var print:String = "";
			trace(params);
			
			var alphabetical:Array = new Array();
			for (var key:String in commands) {
				alphabetical.push(key);
			}
			
			alphabetical.sort();
			
			if (params != null) {
				print += "COMMANDS CONTAINING " + params[0] + ":\n";
				
				var regex:RegExp = new RegExp(params[0],"gi");
				
				for (var i:int = 0; i < alphabetical.length; i++) {
					if (alphabetical[i].search(regex) != -1) {
						
						var text:String = alphabetical[i];
						var startPos:Number = text.search(regex);
						var textSplit:String = text.substr(0, startPos) + params[0].toUpperCase() + text.substring(startPos + params[0].length);
						
						print += " - " + textSplit + "\n";
					}
				}
			} else {
				print += "ALL COMMANDS\n";
				for (i = 0; i < alphabetical.length; i++) {
					print += " - " + alphabetical[i] + "\n";
				}
			}
			
			addLine(print);
		}
		
		private function parseInput(inputText:String):void {
			// first element will be the command name
			var stringSplit:Array = inputText.split(" ");
			var commandName:String = stringSplit[0];
			stringSplit.splice(0, 1);
			if (stringSplit.length == 0) {
				stringSplit = null;
			}
			addLine(">\"" + commandName + "\" (" + stringSplit + ")");			
			if (commands[commandName] == null) {
				addLine("I'm sorry \"" + commandName + "\" is not a recognised command");
			} else if (commands[commandName] == "dispatch") {
				// dispatch
				dispatchEvent(new ConsoleEvent(ConsoleEvent.DISPATCH_COMMAND, stringSplit, commandName));
			} else {
				commands[commandName].apply(null, stringSplit);
			}
		}
		
		public function addLine(line:String):void {
			consoleText.appendText(line + "\n");
			trace(line);
			consoleText.scrollV = consoleText.numLines;
		}
		
		private function checkforenter(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
			
			if (event.keyCode == 13) {
				// ENTER
				parseInput(inputText.text);
				inputText.text = "";
			}
		}
		
		public function toggleConsole():void {
			open = !open;
			if (open) {
				// close
				consoleSprite.visible = true;
				this.stage.focus = inputText;
			} else {
				// open
				consoleSprite.visible = false;
			}
		}
		
	}

}

class SingletonEnforcer {
}