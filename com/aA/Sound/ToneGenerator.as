package com.aA.Sound 
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	/**
	 * My Attempt at a Tone Generator
	 * @author Anthony Massingham
	 * @email anthony.massingham@gmail.com
	 */
	public class ToneGenerator 
	{
		public var tones:Dictionary = new Dictionary();
		
		public function ToneGenerator() 
		{
			tones[Tone.C4] = new Tone(Tone.C4);
			tones[Tone.D4] = new Tone(Tone.D4);
			tones[Tone.E4] = new Tone(Tone.E4);
			tones[Tone.F4] = new Tone(Tone.F4);
			tones[Tone.G4] = new Tone(Tone.G4);
			tones[Tone.A4] = new Tone(Tone.A4);
			tones[Tone.B4] = new Tone(Tone.B4);
			tones[Tone.C5] = new Tone(Tone.C5);
		}
		
		public function play(frequency:Number):void {			
			//var note:Tone = new Tone(frequency);
			//note.play();
			
			tones[frequency].play();
		}
		
	}

}