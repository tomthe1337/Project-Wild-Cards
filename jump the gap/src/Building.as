package  
{
	import org.flixel.*;
	
	public class Building extends FlxSprite
	{
		private var player_runSpeed:int;
		
		public function Building(x:int, y:int, speed:int):void
		{
			var color:uint;
			
			switch( Math.ceil( Math.random() * 4 ) ) {		// select a random colour
				case 0:
					color = 0xff000000;	// black 
					break;
				case 1:
					color = 0xffaa0000;	//	red
					break;
				case 2:
					color = 0xff00aa00;	// green
					break;
				case 3:
					color =  0xff0000aa;	// blue
					break;
				case 4:
					color = 0xffffffff;	// white
			}
			this.makeGraphic((Math.random()*1200)+400, 600, color);		// make a randomly sized rect
			this.x = x;
			this.y = y;
			this.player_runSpeed = speed;		// scroll rect at requested speed
			this.immovable = true;				// no physics will affect this
			this.antialiasing = true;
		}
		override public function update():void
		{
			this.velocity.x = -player_runSpeed;
			super.update();
		}
		public function setRunSpeed(speed:int):void
		{
			this.player_runSpeed = speed;
		}
	}
}