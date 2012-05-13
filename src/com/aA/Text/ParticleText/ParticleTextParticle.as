package aA.UI.ParticleText 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ParticleTextParticle extends Sprite
	{
		private var targetX:Number;
		private var targetY:Number;
		private var maxAlpha:Number = 0.5;
		
		public var assigned:Boolean;
		public var kill:Boolean;
		
		public var speed:Number;
		
		public function ParticleTextParticle(radius:Number, colour:uint, targetX:Number, targetY:Number, speed:Number = 0.1) 
		{
			this.targetX = targetX;
			this.targetY = targetY;
			this.speed = speed;
			
			this.graphics.beginFill(colour);
			this.graphics.drawCircle(0, 0, radius + Math.random() * radius);
			this.graphics.endFill();
			
			//this.graphics.beginFill(0xFFFFFF, 0.5);
			//this.graphics.drawCircle(0, 0, radius / 2);
			//this.graphics.endFill();
			
			this.alpha = 0;
			
			assigned = true;
			
			this.addEventListener(Event.ENTER_FRAME, moveToPosition);
		}
		
		public function reassign(targetX:Number, targetY:Number):void {
			this.targetX = targetX;
			this.targetY = targetY;
			
			assigned = true;
		}
		
		public function removatron():void {
			this.targetX += (Math.random() * 100) - 50;
			this.targetY += (Math.random() * 100) - 50;
			
			kill = true;
		}
		
		private function moveToPosition(event:Event):void {
			this.x += (targetX - this.x) * speed;
			this.y += (targetY - this.y) * speed;
			
			if (kill) {
				if (this.alpha > 0) {
					this.alpha -= 0.05;
				} else {
					this.removeEventListener(Event.ENTER_FRAME, moveToPosition);
					this.parent.removeChild(this);
					
					delete this;
				}
			} else {
				if (this.alpha < maxAlpha) {
					this.alpha += 0.02;
				}
			}
			
			this.x += Math.random()/2;
			this.y += Math.random()/2;
		}
		
	}
	
}