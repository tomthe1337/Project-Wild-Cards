package  
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{	
		private var player:FlxSprite;	// the player character
		
		private var bgs:FlxGroup;	// group of background sprites		
		private var fgs:FlxGroup;	// group of foreground sprites
		
		public var grp_buildings:Array;	// array of buildings
		
		public var runSpeed:int;	// players run speed - used to increase scroll rate of buildings, foregrounds (and baddies eventually)
		private var score:int;		// tracks distance ran
		private var stage:int;		// used to control when run speed changed
		
		override public function create():void 
		{	
			player = new Player(FlxG.width / 10, FlxG.height/2, 10);	// init player 
			runSpeed = 500;												// and some vars
			score = 0;
			stage = 0;
			
			bgs = new FlxGroup();										// init backgrounds		
			bgs.add(new Background(0, runSpeed*0.005));
			bgs.add(new Background(2400, runSpeed*0.005));
			
			add(bgs);			// add backgrounds first, so all other sprites drawn on top
			
			grp_buildings = new Array();	// init buildings, add first 3 (always in same place)
			grp_buildings.push(new Building(0, 380, runSpeed));
			grp_buildings.push(new Building(grp_buildings[0].x + grp_buildings[0].width, 380, runSpeed));
			grp_buildings.push(new Building(grp_buildings[1].x + grp_buildings[1].width, 380, runSpeed));
			add(grp_buildings[0] );
			add(grp_buildings[1]);
			add(grp_buildings[2]);
			
			add(player);
			
			fgs = new FlxGroup();	// init foregrounds and add last, so alyays  on top of all other sprites
			
			fgs.add(new Foreground(0, runSpeed*0.02));
			fgs.add(new Foreground(2300, runSpeed*0.02));
			add(fgs);
		}	
		override public function update():void
		{	
			if((FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("UP")) && player.isTouching(FlxObject.FLOOR)){
				player.velocity.y = -player.maxVelocity.y / 2;	// jump key handling
			}
			if ((FlxG.keys.justReleased("SPACE") || FlxG.keys.justReleased("UP"))) {
				if (player.velocity.y < 0) {
					player.velocity.y *= 0.5;	// start to fall when jump key released
				}
			}
			if (FlxG.keys.justReleased("ENTER")) { FlxG.resetState(); }
			player.x = FlxG.width / 10;		// to reset state, used for testing
			
			super.update();	// update parent - draws all sprites added to this
			
			updateBuildings();	
			updateSpeed();	
		}
		/*
		 * checks if a building has gone past
		 * if it has, destroys it and creates a new instance at back of row of buildings
		 */
		private function updateBuildings():void	
		{			
			for (var i:int = 0; i < grp_buildings.length; i++) {
				if (grp_buildings[i].x < 0 - grp_buildings[i].width) {
					remove(grp_buildings[i]);
					grp_buildings = grp_buildings.reverse();
					grp_buildings.pop();
					grp_buildings = grp_buildings.reverse();
					addBuildingToEnd();
				}
				FlxG.collide(player, grp_buildings[i], playerHitBuilding);	// check if player has hit a building
			}
		}
		/*
		 * adds a building to the end of the array - ie, the end not currently onscreen
		 */
		private function addBuildingToEnd():void
		{
			grp_buildings.push(new Building(grp_buildings[1].x + grp_buildings[1].width + ((Math.random()*140)+(30*stage)), grp_buildings[1].y + (Math.random() * (FlxG.height - grp_buildings[1].y ))- 80, runSpeed));
			add(grp_buildings[2]);
		}
		/*
		 * updates speed/stage and all dependant objects
		 */
		private function updateSpeed():void
		{
			score += 1;
			if (score % 300 == 0) {
				stage++;
				runSpeed += stage * 2;
				var x0f:Number = fgs.members[0].x;
				var x1f:Number = fgs.members[1].x
				remove(fgs);
				fgs.callAll("kill");
				fgs.callAll("destroy");
				fgs.clear();
				fgs.add(new Foreground(x0f, Math.ceil(runSpeed*0.02)));
				fgs.add(new Foreground(x1f, Math.ceil(runSpeed * 0.02)));
				
				add(fgs);
				
				for (var t:int = 0; t < grp_buildings.length; t++) {
					grp_buildings[t].setRunSpeed(runSpeed);
				}
			}
		}
		/*
		 * handler for collision between player and any building
		 */
		private function playerHitBuilding(pl:Player, bd:Building):void
		{
			// do nothing
		}
	}
}