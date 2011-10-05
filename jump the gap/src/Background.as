package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Background extends FlxSprite	// scrolling background
	{
		[Embed(source = '../lib/gfx/sunset.png')] private var suns:Class;
		private var player_runSpeed:Number;
		
		public function Background(px:Number, speed:Number)
		{
			this.loadGraphic(suns, true, false, 2400, 600);
			this.addAnimation("normal", [0]);
			this.x = px;
			this.player_runSpeed = speed;
		}
		override public function update():void
		{
			play("normal");
			
			this.velocity.x = -player_runSpeed;
			if (this.x <= -this.width) {		// if offscreen, move back to start
				this.x = this.width+(this.width + this.x) ;
			}
			super.update();
		}
		public function setRunSpeed(speed:int):void
		{
			this.player_runSpeed = speed;
		}
	}

}