package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class EnemyBullet extends FlxSprite
	{
		private var scrollSpeed:Number;
		public var dead:Boolean;
		public var type:int;
		private var speedX:int;
		[Embed(source = '../lib/gfx/bullets.png')]
		private var imgBullets:Class;
		
		public function EnemyBullet(px:Number, py:Number, speed:Number, ty:int, sp:int)
		{
			this.loadGraphic(imgBullets, true, false, 64, 16);
			this.addAnimation("fly",[0],0);
			this.x = px;
			this.y = py;
			this.speedX = sp;
			this.scrollSpeed = speed;
			this.dead = false;
			this.type = ty;
		}
		override public function update():void
		{
			this.play("throw");
			this.velocity.x = -scrollSpeed;
			if (this.x <= 0-this.width) {
				this.dead = true;
			}
			this.x -= speedX;
			super.update();
		}
		public function setRunSpeed(speed:int):void
		{
			this.scrollSpeed = speed;
		}
	}
}