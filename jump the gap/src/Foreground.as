package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Foreground extends FlxSprite
	{
		[Embed(source = '../lib/gfx/hills.png')] private var hill:Class;
		private var player_runspeed:Number;
		
		
		public function Foreground(px:Number, speed:Number)
		{
			this.loadGraphic(hill, true, false, 2400, 600);
			this.addAnimation("normal", [0], 0);
			this.x = px;
			this.player_runspeed = speed;
		}
		override public function update():void
		{
			play("normal");
			this.x -= player_runspeed;
			if (this.x <= -(this.width-100)) {	// if ofscreen, move back to start
				this.x *= -1 ;
			}
			super.update();
		}
	}

}