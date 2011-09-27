package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Obstacle extends FlxSprite
	{
		private var scrollSpeed:Number;
		public var dead:Boolean;
		public var onBuilding:Boolean;
		[Embed(source = '../lib/gfx/obstacles.png')]
		private var barr:Class;
		public var type:int;
		
		public function Obstacle(px:Number, py:Number, speed:Number, ty:int)
		{
			this.loadGraphic(barr, true, false, 48, 96);
			this.addAnimation("bounce", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 20);
			this.addAnimation("block", [10,11], 2);
			this.x = px;
			this.y = py;
			this.scrollSpeed = speed;
			this.dead = false;
			this.onBuilding = false;
			this.allowCollisions = 0x0001;
			this.type = ty;
		}
		override public function update():void
		{
			this.velocity.x = -scrollSpeed;
			if (this.type == 0) { play("bounce"); }
			else if (this.type == 1) { play("block"); }
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