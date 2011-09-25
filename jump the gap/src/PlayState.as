package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class PlayState extends FlxState
	{	
		private var player:Player;	// the player character
		
		private var bgs:FlxGroup;	// group of background sprites		
		private var fgs:FlxGroup;	// group of foreground sprites
		private var grp_buildings:Array;	// array of buildings
		private var baddies:FlxGroup;	// group of baddies
		
		private var runSpeed:Number;	// players run speed - used to increase scroll rate of buildings, foregrounds (and baddies eventually)
		private var score:int;		// tracks distance ran
		private var stage:int;		// used to control when run speed changed
		
		override public function create():void 
		{	
			player = new Player(FlxG.width / 10, FlxG.height/2, 10);	// init player 
			runSpeed = 150;												// and some vars
			score = 0;
			stage = 0;
			bgs = new FlxGroup();										// init backgrounds		
			bgs.add(new Background(0, runSpeed/5));
			bgs.add(new Background(2400, runSpeed / 5));
			add(bgs);			// add backgrounds first, so all other sprites drawn on top
			
			grp_buildings = new Array();	// init buildings, add first 3 (always in same place)
			grp_buildings.push(new Building(0, 380, runSpeed));
			grp_buildings.push(new Building(grp_buildings[0].x + grp_buildings[0].width, 380, runSpeed));
			grp_buildings.push(new Building(grp_buildings[1].x + grp_buildings[1].width, 380, runSpeed));
			add(grp_buildings[0] );
			add(grp_buildings[1]);
			add(grp_buildings[2]);
			
			baddies = new FlxGroup();
			add(baddies);
			
			add(player);
			
			fgs = new FlxGroup();	// init foregrounds and add last, so alyays  on top of all other sprites
			
			fgs.add(new Foreground(0, runSpeed*1.5));
			fgs.add(new Foreground(2400, runSpeed*1.5));		
			add(fgs);
		}	
		override public function update():void
		{	
			player.x = FlxG.width / 10;
			if((FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("UP")) && player.isTouching(FlxObject.FLOOR)){
				player.velocity.y = -player.maxVelocity.y / 2;	// jump key handling
			}
			if ((FlxG.keys.justReleased("SPACE") || FlxG.keys.justReleased("UP"))) {
				if (player.velocity.y < 0) {
					player.velocity.y *= 0.5;	// start to fall when jump key released
				}
			}
			if (FlxG.keys.justReleased("ENTER")) { FlxG.resetState(); }		// used for testing
			if (FlxG.keys.justPressed("Q")) { }
			if (FlxG.keys.justPressed("W")) { }
			
			for (var b:int = 0; b < baddies.length; b++) {		// pixel perfect collision check
				if (FlxCollision.pixelPerfectCheck(player, baddies.members[b])) {
					playerHitObstacle(player, baddies.members[b]);
				}
			}
			
			super.update();	// update parent - draws all sprites added to this
			
			updateBuildings();	
			updateObstacles();
			updateSpeed();	
		}
		/*
		 * checks if a building has gone past
		 * if it has, destroys it and creates a new instance at back of row of buildings
		 */
		private function updateBuildings():void	
		{			
			for (var i:int = 0; i < grp_buildings.length; i++) {
				if (grp_buildings[i].x <= 0 - grp_buildings[i].width) {
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
			addObstacle();
		}
		/*
		 * adds an obstacle to the top of the building at the end of the queue
		 */
		private function addObstacle():void
		{
			switch(Math.ceil(Math.random() * 2)) 
			{
				case 1:
					if(grp_buildings[2].width >= 650){
						var newBaddie:Baddie;
						newBaddie = new Baddie( (grp_buildings[2].x + 300) + ( Math.random()*((grp_buildings[2].width-300)-300) ), grp_buildings[2].y-50, runSpeed);
						baddies.add(newBaddie);
					}
					break;
				case 2:
					if(grp_buildings[2].width >= 650){
						var newBaddie2:Baddie;
						newBaddie2 = new Baddie( (grp_buildings[2].x + 300) + ( Math.random()*((grp_buildings[2].width-300)-300) ), grp_buildings[2].y-100, runSpeed);
						baddies.add(newBaddie2);
					}
					break;
			}
		}
		/*
		 * updates all obstacles
		 */
		private function updateObstacles():void
		{
			for (var u:int = 0; u < baddies.length; u++) {	
				if (baddies.members[u].dead == true) {
					baddies.members[u].kill();
					baddies.members[u].destroy();
					baddies.remove(baddies.members[u], true);
				}
			}
			//FlxG.collide(player, baddies, playerHitObstacle);
		}
		/*
		 * updates speed/stage and all dependant objects
		 */
		private function updateSpeed():void
		{
			score += 1;
			if (score % 250 == 0) {	// at levelup....
				stage++;
				//addObstacle();
			}
			for (var t:int = 0; t < grp_buildings.length; t++) {	// change speed of buildings
				grp_buildings[t].setRunSpeed(runSpeed);
			}
			for (var j:int = 0; j < fgs.length; j++) {				// change speed of foregrounds
				fgs.members[j].setRunSpeed(runSpeed*1.5);
			}
			for (var k:int = 0; k < fgs.length; k++) {				// change speed of backgrounds
				bgs.members[k].setRunSpeed(runSpeed/5);
			}
			for (var w:int = 0; w < baddies.length; w++) {				// change speed of backgrounds
				baddies.members[w].setRunSpeed(runSpeed);
			}
		}
		/*
		 * handler for collision between player and any building
		 */
		private function playerHitBuilding(pl:Player, bd:Building):void
		{
			if (runSpeed < 700) { runSpeed += 2; }
			else{runSpeed += .1;}
		}
		private function playerHitObstacle(pl:Player, ob:Baddie):void
		{
			if (pl.attacking == true) {
				trace("killed it");
			}else {
				trace(" got hit");
				runSpeed /= 2;
			}
			ob.dead = true;
		}
		
	}
}