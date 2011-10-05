package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Oliver Ross
	 */
	public class Player extends FlxSprite
	{
		
		private var runSpeed:int;	// controlls the speed of animation
		
		[Embed(source = '../lib/gfx/red_ninjaed.png')]
		private var redNinjaSheet:Class;
		public var attacking:Boolean;	// true if player is attacking
		public var sliding:Boolean;		// true if player is sliding
		private var slideCounter:int;	// used to time different animations
		private var slideCooldown:int;
		private var weaponCounter:int;
		private var weaponCooldown:int; 
		
		public function Player(x:int, y:int, run:int):void 	// constructor
		{
			this.runSpeed = run;
			this.loadGraphic(redNinjaSheet, true, false, 96, 84);
			this.addAnimation("run", [0,1,2,3,4,5],runSpeed);	// set animations
			this.addAnimation("jump", [6, 6, 8, 8, 8, 8, 7, 7, 7, 7], runSpeed);
			this.addAnimation("slide", [9], 1, false);
			this.addAnimation("attack", [10],1, false);
			this.addAnimation("fall", [7]);
			this.addAnimation("leap", [8]);
			this.maxVelocity.y = 900;
			this.acceleration.y = 1000;
			this.x = x;
			this.y = y;
			this.offset.x = -30;
			this.attacking = false;
			this.sliding = false;
		}
		override public function update():void	// update - called each frame by parent
		{
			if ( ((FlxG.keys.justPressed("Z"))||(FlxG.keys.pressed("DOWN"))) && slideCounter == 0 && slideCooldown < 30 ){
				slideCounter = 24;
				slideCooldown = 65;
			} 
			if ((FlxG.keys.justPressed("X") || FlxG.keys.justPressed("RIGHT"))&& weaponCounter == 0 && weaponCooldown < 15) {
				weaponCounter = 12;
				weaponCooldown = 40;
			}
			slideCooldown--;
			weaponCooldown--;
			if (slideCounter > 0 && this.velocity.y == 0) {
				play("slide");
				slideCounter--;
				attacking = false;
				sliding = true;
			}else if (weaponCounter > 0) {
				play("attack");
				attacking = true;
				sliding = false;
				weaponCounter--;
			}else if ((FlxG.keys.pressed("SPACE") || FlxG.keys.pressed("UP")) && this.velocity.y != 0) {
				play("jump");
				attacking = false;
				sliding = false;
			}else if (this.velocity.y > 3) {
				play("fall");
				slideCounter = 0;
				slideCooldown = 0;
				attacking = false;
				sliding = false;
			}else{
				play("run");
				attacking = false;
				sliding = false;
			}
			
			super.update();
		}
	}
}