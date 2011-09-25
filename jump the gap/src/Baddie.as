package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Baddie extends FlxSprite
	{
		private var scrollSpeed:Number;
		public var dead:Boolean;
		public var onBuilding:Boolean;
		
		public function Baddie(px:Number, py:Number, speed:Number)
		{
			this.makeGraphic(50, 50, 0xffffffff);
			this.x = px;
			this.y = py;
			this.scrollSpeed = speed;
			this.dead = false;
			this.onBuilding = false;
			this.allowCollisions = 0x0001;
		}
		override public function update():void
		{
			this.velocity.x = -scrollSpeed;
			
			
			
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