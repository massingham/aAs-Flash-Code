package com.aA.Sound 
{
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	/**
	 * Tone used in the Tone Generator, Essentially a simple data storage device
	 * 
	 * @author Anthony Massingham
	 * @email anthony.massingham@gmail.com
	 */
	public class Tone 
	{
		public static const AMP_MULTIPLIER:Number = 0.15;
		public static const SAMPLING_RATE:int = 44100;
		public static const TWO_PI:Number = 2 * Math.PI;
		public static const TWO_PI_OVER_SR:Number = TWO_PI / SAMPLING_RATE;
		
		// Pentatonic scale
		public static const C4:Number = 261.626;
		public static const D4:Number = 293.665;
		public static const E4:Number = 329.628;
		public static const F4:Number = 349.228;
		public static const G4:Number = 391.995;
		public static const A4:Number = 440;
		public static const B4:Number = 494.883;
		public static const C5:Number = 523.251;
		
		public static const WHOLE:Number = 500;
		
		public var noteSound:Sound;
		
		public var theNote:Number;
		public var theLength:Number;
		
		private var stopTimer:Timer;
		
		public function Tone(note:Number, length:Number = 500) 
		{
			theNote = note;
			theLength = length;
			
			stopTimer = new Timer(theLength, 1);
			stopTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stop);
			
			noteSound = new Sound();
		}
		
		public function play():void {
			noteSound.addEventListener(SampleDataEvent.SAMPLE_DATA, playSineWave);
			stopTimer.reset();
			noteSound.play();
			stopTimer.start();
		}
		
		private function playSineWave(event:SampleDataEvent):void {
			var sample:Number;
			//for (var i:int = 0; i < 8192; i ++) {
			for (var i:int = 0; i < 2048; i ++) {
				sample = Math.sin((i + event.position) * TWO_PI_OVER_SR * theNote);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
		}
		
		public function stop(event:TimerEvent):void {
			noteSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, playSineWave);
			
			//SoundChannel.stop();
		}
		
	}

}