package com.aA.Sound 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SoundManager
	{
		private static var _instance:SoundManager;
		
		private var soundDictionary:Dictionary;
		private var sounds:Array;
		
		private var muted:Boolean = false;
		
		public function SoundManager() 
		{
			soundDictionary = new Dictionary();
			sounds = new Array();
		}
		
		public static function getInstance():SoundManager {
			if (_instance == null) {
				_instance = new SoundManager();
			}
			return _instance;
		}
		
		public function addSound(id:*, name:String):void {
			var soundObj:Object = new Object();
			var snd:Sound = new id;
			
			soundObj.name = name;
			soundObj.sound = snd;
			soundObj.channel = new SoundChannel();
			soundObj.position = 0;
			soundObj.paused = true;
			soundObj.volume = 1;
			soundObj.startTime = 0;
			soundObj.loops = 0;
			soundObj.pausedByAll = false;
			
			soundDictionary[name] = soundObj;
			sounds.push(soundObj);
			
			playSound(name, 0);
		}
		
		public function toggleMute():void {
			muted = !muted;
			if (muted) {
				stopAllSounds();
			}
		}
		
		public function mute(value:Boolean):void {
			if (value) {
				muted = true;
			} else {
				muted = false;
			}
			
			if (muted) {
				stopAllSounds();
			}
		}
		
		public function playSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0):void {			
			if (muted) return;
			
			var snd:Object = this.soundDictionary[name];
			
			snd.volume = volume;
			snd.startTime = startTime;
			snd.loops = loops;
			
			if (snd.paused) {
				snd.channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(snd.volume));
			} else {
				snd.channel = snd.sound.play(startTime, snd.loops, new SoundTransform(snd.volume));
			}
			snd.paused = false;
		}
		
		public function stopAllSounds(useCurrentlyPlayingOnly:Boolean = true):void
        {
            for (var i:int = 0; i <this.sounds.length; i++)
            {
                var id:String = this.sounds[i].name;
                if (useCurrentlyPlayingOnly)
                {
                    if (!this.soundDictionary[id].paused)
                    {
                        this.soundDictionary[id].pausedByAll = true;
                        this.stopSound(id);
                    }
                }
                else
                {
                    this.stopSound(id);
                }
            }
		}
		
		public function stopSound(id:String):void {
			var snd:Object = this.soundDictionary[id];
            snd.paused = true;
            snd.channel.stop();
            snd.position = snd.channel.position
		}
		
	}

}