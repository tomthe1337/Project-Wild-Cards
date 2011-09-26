package  
{
	import org.flixel.*;
	
	public class Building extends FlxSprite
	{
		private var player_runSpeed:int;
		[Embed(source = '../lib/gfx/Platform1.png')]
		private var plat1:Class;
		[Embed(source = '../lib/gfx/Platform2.png')]
		private var plat2:Class;
		[Embed(source = '../lib/gfx/Platform3.png')]
		private var plat3:Class;
		[Embed(source = '../lib/gfx/Platform4.png')]
		private var plat4:Class;
		[Embed(source = '../lib/gfx/Platform5.png')]
		private var plat5:Class;
		[Embed(source = '../lib/gfx/Platform6.png')]
		private var plat6:Class;
		[Embed(source = '../lib/gfx/Platform7.png')]
		private var plat7:Class;
		[Embed(source = '../lib/gfx/Platform8.png')]
		private var plat8:Class;
		[Embed(source = '../lib/gfx/Platform9.png')]
		private var plat9:Class;
		[Embed(source = '../lib/gfx/Platform10.png')]
		private var plat10:Class;
		
		public function Building(x:int, y:int, speed:int):void
		{
			switch( Math.ceil( Math.random() * 20) ) {		// select a random sprite
				case 0:
					// an image. this will be almost never
					break;
				case 1:
					this.loadGraphic(plat1, true, false, 600, 600);
					this.addAnimation("normal", [0]);
					break;
				case 2:
					this.loadGraphic(plat2, true, false, 700, 600);
					this.addAnimation("normal", [0]);
					break;
				case 3:
					this.loadGraphic(plat3, true, false, 800, 600);
					this.addAnimation("normal", [0]);
					break;
				case 4:
					this.loadGraphic(plat4, true, false, 900, 600);
					this.addAnimation("normal", [0]);
					break;
				case 5:
					this.loadGraphic(plat5, true, false, 1000, 600);
					this.addAnimation("normal", [0]);
					break;
				case 6:
					this.loadGraphic(plat6, true, false, 1100, 600);
					this.addAnimation("normal", [0]);
					break;
				case 7:
					this.loadGraphic(plat7, true, false, 1200, 600);
					this.addAnimation("normal", [0]);
					break;
				case 8:
					this.loadGraphic(plat8, true, false, 1300, 600);
					this.addAnimation("normal", [0]);
					break;
				case 9:
					this.loadGraphic(plat9, true, false, 1400, 600);
					this.addAnimation("normal", [0]);
					break;
				case 10:
					this.loadGraphic(plat10, true, false, 1500, 600);
					this.addAnimation("normal", [0]);
					break;
				case 11:
					this.loadGraphic(plat1,true,true,600,600)
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 12:
					this.loadGraphic(plat2, true, true, 700, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 13:
					this.loadGraphic(plat3, true, true, 800, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 14:
					this.loadGraphic(plat4, true, true, 900, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 15:
					this.loadGraphic(plat5, true, true, 1000, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 16:
					this.loadGraphic(plat6, true, true, 1100, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 17:
					this.loadGraphic(plat7, true, true, 1200, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 18:
					this.loadGraphic(plat8, true, true, 1300, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 19:
					this.loadGraphic(plat9, true, true, 1400, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
				case 20:
					this.loadGraphic(plat10, true, true, 1500, 600);
					this.addAnimation("normal", [0]);
					this.facing = FlxObject.LEFT;
					break;
			}
			this.x = x;
			this.y = y;
			this.player_runSpeed = speed;		// scroll rect at requested speed
			this.immovable = true;				// no physics will affect this
		}
		override public function update():void
		{
			this.velocity.x = -player_runSpeed;
			super.update();
		}
		public function setRunSpeed(speed:Number):void
		{
			this.player_runSpeed = speed;
		}
	}
}