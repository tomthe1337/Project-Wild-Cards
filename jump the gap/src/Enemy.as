package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Enemy extends FlxSprite
	{
		private var scrollSpeed:Number;
		public var dead:Boolean;
		public var type:int;
		public var shootTimer:int;
		
		[Embed(source = '../lib/gfx/enemies.png')]
		private var stripEnemy:Class;
		
		public function Enemy(px:Number, py:Number, speed:Number, ty:int)
		{
			this.loadGraphic(stripEnemy, true, false, 96, 128);
			this.addAnimation("throw", [0, 1], 2);
			this.x = px;
			this.y = py;
			this.scrollSpeed = speed;
			this.dead = false;
			this.type = ty;
			this.shootTimer = 299;
		}
		override public function update():void
		{
			this.play("throw");
			this.velocity.x = -scrollSpeed;
			this.shootTimer++;
			if (this.x <= 0-this.width) {
				this.dead = true;
			}	
			super.update();
		}
		public function setRunSpeed(speed:int):void
		{
			this.scrollSpeed = speed;
		}
	}
}