package aA.UI.ParticleText 
{
	import Display.ColourModifier;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * An Attempt at creating particle text
	 * @author Anthony Massingham
	 */
	public class ParticleText extends Sprite
	{
		// This is the text grid : 
		// 
		// 00		01		 02
		// 
		//
		//
		// 10		11		 12
		//
		//
		//
		// 20		21		 22
		// 
		
		// THE TEXT DEFINITION
		private var letterDefinition:Dictionary = new Dictionary();
		private var paths:Array = new Array();
		
		private var size:Number;
		private var halfsize:Number;
		public var _text:String;
		private var maxParticles:Number;
		private var reuse:Boolean;
		
		private var particleColour:uint;
		
		public var textwidth:Number;
		
		private var particles:Array;
		
		private var speed:Number;
		
		public function ParticleText(text:String, size:Number, maxParticles:Number, particleColour:uint, speed:Number =  0.1) 
		{
			initTextConfig();
			
			this.size = size;
			this.halfsize = size / 2;
			this._text = text;
			this.maxParticles = maxParticles;
			this.particleColour = particleColour;
			this.speed = speed;
			
			textwidth = (size * 3) * text.length;
			
			reuse = false;
			
			particles = new Array();
			
			drawText();
		}
		
		private function initTextConfig():void {
			letterDefinition["A"] = new Array(new Array(2,0,0,0), new Array(0,0,0,2), new Array(0,2,2,2), new Array(1,0,1,2));
			letterDefinition["B"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0), new Array(1, 0, 1, 2));
			letterDefinition["C"] = new Array(new Array(0, 2, 0, 0), new Array(0, 0, 2, 0), new Array(2, 0, 2, 2));
			letterDefinition["D"] = new Array(new Array(0, 0, 0, 1.5), new Array(0, 1.5, 0.5, 2), new Array(0.5, 2, 1.5, 2), new Array(1.5, 2, 2, 1.5), new Array(2, 1.5, 2, 0), new Array(2, 0, 0, 0));
			letterDefinition["E"] = new Array(new Array(0, 0, 0, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0), new Array(1, 0, 1, 2));
			letterDefinition["F"] = new Array(new Array(0, 0, 0, 2), new Array(2, 0, 0, 0), new Array(1, 0, 1, 2));
			letterDefinition["G"] = new Array(new Array(0, 2, 0, 0), new Array(0, 0, 2, 0), new Array(2, 0, 2, 2), new Array(2, 2, 1, 2), new Array(1, 2, 1, 1));
			letterDefinition["H"] = new Array(new Array(0, 0, 2, 0), new Array(0, 2, 2, 2), new Array(1, 0, 1, 2));
			letterDefinition["I"] = new Array(new Array(0, 0, 0, 2), new Array(0, 1, 2, 1), new Array(2, 0, 2, 2));
			letterDefinition["J"] = new Array(new Array(0, 0, 0, 2), new Array(0, 1, 2, 1), new Array(2, 0, 2, 1));
			letterDefinition["K"] = new Array(new Array(0, 0, 2, 0), new Array(1, 0, 0, 2), new Array(1, 0, 2, 2));
			letterDefinition["L"] = new Array(new Array(0, 0, 2, 0), new Array(2, 0, 2, 2));
			letterDefinition["M"] = new Array(new Array(2, 0, 0, 0), new Array(0, 0, 1, 1), new Array(1, 1, 0, 2), new Array(0, 2, 2, 2));
			letterDefinition["N"] = new Array(new Array(2, 0, 0, 0), new Array(0, 0, 2, 2), new Array(2, 2, 0, 2));
			letterDefinition["O"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0));
			letterDefinition["P"] = new Array(new Array(0, 0, 2, 0), new Array(0, 0, 0, 2), new Array(0, 2, 1, 2), new Array(1, 2, 1, 0));
			letterDefinition["Q"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0), new Array(2, 1, 1, 1));
			letterDefinition["R"] = new Array(new Array(0, 0, 2, 0), new Array(0, 0, 0, 2), new Array(0, 2, 1, 2), new Array(1, 2, 1, 0), new Array(1, 1, 2, 2));
			letterDefinition["S"] = new Array(new Array(0, 0, 0, 2), new Array(0, 0, 1, 0), new Array(1, 0, 1, 2), new Array(1, 2, 2, 2), new Array(2, 2, 2, 0));
			letterDefinition["T"] = new Array(new Array(0, 0, 0, 2), new Array(0, 1, 2, 1));
			letterDefinition["U"] = new Array(new Array(0, 0, 2, 0), new Array(2, 0, 2, 2), new Array(2, 2, 0, 2));
			letterDefinition["V"] = new Array(new Array(0, 0, 2, 1), new Array(2, 1, 0, 2));
			letterDefinition["W"] = new Array(new Array(0, 0, 2, 0), new Array(2, 0, 2, 2), new Array(0, 2, 2, 2), new Array(1, 1, 2, 1));
			letterDefinition["X"] = new Array(new Array(0, 0, 2, 2), new Array(2, 0, 0, 2));
			letterDefinition["Y"] = new Array(new Array(0, 0, 1, 1), new Array(0, 2, 1, 1), new Array(1, 1, 2, 1));
			letterDefinition["Z"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 0), new Array(2, 0, 2, 2));
			
			letterDefinition["0"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0));
			letterDefinition["1"] = new Array(new Array(0, 2, 2, 2));
			letterDefinition["2"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 1, 2), new Array(1, 2, 1, 0), new Array(1, 0, 2, 0), new Array(2, 0, 2, 2));
			letterDefinition["3"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(1, 2, 1, 0));
			letterDefinition["4"] = new Array(new Array(0, 0, 1, 0), new Array(1, 0, 1, 2), new Array(0, 1, 2, 1));
			letterDefinition["5"] = new Array(new Array(0, 0, 0, 2), new Array(0, 0, 1, 0), new Array(1, 0, 1, 2), new Array(1, 2, 2, 2), new Array(2, 2, 2, 0));
			letterDefinition["6"] = new Array(new Array(0, 2, 0, 0), new Array(0, 0, 2, 0), new Array(2, 0, 2, 2), new Array(2, 2, 1, 2), new Array(1, 2, 1, 0));
			letterDefinition["7"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2));
			letterDefinition["8"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(2, 0, 0, 0), new Array(1, 0, 1, 2));
			letterDefinition["9"] = new Array(new Array(0, 0, 0, 2), new Array(0, 2, 2, 2), new Array(2, 2, 2, 0), new Array(0, 0, 1, 0), new Array(1, 0, 1, 2));
			
			letterDefinition[" "] = new Array();
			letterDefinition["."] = new Array(new Array(2, 0.8, 2, 1.2));
		}
		
		/**
		 * Draws the text using particles
		 */
		private function drawText():void {
			_text = _text.toUpperCase();
			//trace("attempting to draw : " + text);
			var reuseCount:Number = 0;
			
			// caluclate number of particles per letter.
			// Even ? 
			
			for (var i:int = 0; i < text.length; i++) {
				//trace("drawing :" +_text.charAt(i));
				var currentPoints:Array = letterDefinition[_text.charAt(i)];
					
				this.graphics.lineStyle(0);
				
				var PPLine:Number = maxParticles / currentPoints.length;
				PPLine = Math.round(PPLine);
				
				for (var n:int = 0; n < currentPoints.length; n++) {
					// pairs
					
					var x1:Number = currentPoints[n][1] * halfsize;
					var y1:Number = currentPoints[n][0] * size;
					var x2:Number = currentPoints[n][3] * halfsize;
					var y2:Number = currentPoints[n][2] * size;
					
					var something:Number = (size * 1.5) * i;
					//x1 += (size * 1.5) * i;
					x1 += something;
					//x2 += (size * 1.5) * i;
					x2 += something;
					
					//this.graphics.moveTo(x1, y1);
					//this.graphics.lineTo(x2, y2);
					
					var xDifference:Number = x2 - x1;
					var yDifference:Number = y2 - y1;
					var absxDifference:Number = Math.abs(x1 - x2);
					var absyDifference:Number = Math.abs(y1 - y2);
					
					var lineLength:Number = Math.sqrt(Math.pow(absxDifference, 2) + Math.pow(absyDifference, 2));

					var steps:Number = lineLength / PPLine;
					
					var xStep:Number = xDifference / PPLine;
					var yStep:Number = yDifference / PPLine;
					
					for (var z:int = 0; z < PPLine; z++) {
						if (reuse) {
							if (particles[reuseCount] == null) {
								var particle:ParticleTextParticle = new ParticleTextParticle(size / 10, particleColour, x1 + (xStep * z), y1 + (yStep * z), speed);				
								addChild(particle);
								
								particle.x = (x1 + (xStep * z)) + ((Math.random() * 100) - 50);
								particle.y = (y1 + (yStep * z)) + ((Math.random() * 100) - 50);
								
								particles.push(particle);
								reuseCount ++;
							} else {
								//trace(reuseCount, particles.length);
								//trace(particles[reuseCount].assigned);
								
								while ((particles[reuseCount]).assigned) {
									reuseCount++;
								}
								particles[reuseCount].reassign(x1 + (xStep * z), y1 + (yStep * z));
								reuseCount++;
							}
						} else {
							particle = new ParticleTextParticle(size / 10, particleColour, x1 + (xStep * z), y1 + (yStep * z), speed);				
							addChild(particle);
							particle.x = Math.random() * 200;
							particle.y = Math.random() * 200;
							
							particles.push(particle);
						}
					}
				}
			}
			
			removeStragglers();
		}
		
		public function disperse():void {
			for (var i:int = 0; i < particles.length; i++) {
				particles[i].assigned = false;
			}
		}
		
		public function removeStragglers():void {
			for (var i:int = particles.length - 1; i >= 0; i--) {
				if (particles[i].assigned == false) {
					particles[i].removatron();
					particles.splice(i, 0);		
				}
			}
		}
		
		public function clearAllText():void {
			disperse();
			removeStragglers();
			
			var timer:Timer = new Timer(5000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, removeThis);
			timer.start();
		}
		
		private function removeThis(event:TimerEvent):void {
			this.parent.removeChild(this);
			delete this;
		}
		
		public function updateText(newText:String):void {
			_text = newText;
			reuse = true;
			disperse();
			drawText();
			textwidth = (size * 3) * text.length;
		}
		
		public function set text(newText:String):void {
			updateText(newText);
		}
		
		public function get text():String {
			return _text;
		}
		
	}
	
}