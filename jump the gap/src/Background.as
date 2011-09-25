package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Background extends FlxSprite	// scrolling background
	{
		[Embed(source = '../lib/gfx/sunset.png')] private var suns:Class;
		private var player_runspeed:int;
		
		public function Background(px:Number, speed:Number)
		{
			this.loadGraphic(suns, true, false, 2400, 600);
			this.addAnimation("normal", [0]);
			this.x = px;
			this.player_runspeed = speed;
		}
		override public function update():void
		{
			play("normal");
			
			this.x -= player_runspeed;
			if (this.x <= -(this.width)) {		// if offscreen, move back to start
				this.x = this.width;
			}
			super.update();
		}
	}

}