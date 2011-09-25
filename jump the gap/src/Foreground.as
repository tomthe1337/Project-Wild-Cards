package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Foreground extends FlxSprite
	{
		[Embed(source = '../lib/gfx/hills.png')] private var hill:Class;
		private var player_runSpeed:int;
		
		public function Foreground(px:Number, speed:int)
		{
			this.loadGraphic(hill, true, false, 2400, 600);
			this.addAnimation("normal", [0]);
			this.x = px;
			this.player_runSpeed = speed;
		}
		override public function update():void
		{
			play("normal");
			this.velocity.x = -player_runSpeed;
			if (this.x <= -this.width) {	// if ofscreen, move back to start
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