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
		private var obstacles:FlxGroup;	// group of baddies
		
		private var runSpeed:Number;	// players run speed - used to increase scroll rate of buildings, foregrounds (and baddies eventually)
		private var score:int;		// tracks distance ran
		private var stage:int;		// used to control when run speed changed
		
		override public function create():void 
		{	
			player = new Player(FlxG.width / 10, 100, 10);	// init player 
			runSpeed = 150;												// and some vars
			score = 0;
			stage = 0;
			bgs = new FlxGroup();										// init backgrounds		
			bgs.add(new Background(0, runSpeed/5));
			bgs.add(new Background(2400, runSpeed / 5));
			add(bgs);			// add backgrounds first, so all other sprites drawn on top
			
			grp_buildings = new Array();	// init buildings, add first 3 (always in same place)
			grp_buildings.push(new Building(0, 280, runSpeed));
			grp_buildings.push(new Building(grp_buildings[0].x + grp_buildings[0].width, 280, runSpeed));
			grp_buildings.push(new Building(grp_buildings[1].x + grp_buildings[1].width, 280, runSpeed));
			add(grp_buildings[0] );
			add(grp_buildings[1]);
			add(grp_buildings[2]);
			
			obstacles = new FlxGroup();
			add(obstacles);
			
			add(player);
			
			fgs = new FlxGroup();	// init foregrounds and add last, so alyays  on top of all other sprites
			
			fgs.add(new Foreground(0, runSpeed*1.5));
			fgs.add(new Foreground(2400, runSpeed*1.5));		
			add(fgs);
		}	
		override public function update():void
		{	
			player.x = FlxG.width / 10;
			doCollisionDetection();
			checkUserInput();
			updateBuildings();	
			updateObstacles();
			updateSpeed();
			
			super.update();	// update parent - draws all sprites added to this	
		}
		private function checkUserInput():void
		{
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
			}
		}
		/*
		 * adds a building to the end of the array - ie, the end not currently onscreen
		 */
		private function addBuildingToEnd():void
		{
			grp_buildings.push(new Building((grp_buildings[1].x + grp_buildings[1].width + ((Math.random()*140)+(stage*20)))+player.width, grp_buildings[1].y + ((Math.random() * (FlxG.height - grp_buildings[1].y-100))- 80), runSpeed));
			add(grp_buildings[2]);
			addObstacle();
		}
		/*
		 * adds an obstacle to the top of the building at the end of the queue
		 */
		private function addObstacle():void
		{
			if(grp_buildings[2].width >= 800){
				var newBaddie:Obstacle;
				newBaddie = new Obstacle( (grp_buildings[2].x + 300) + ( Math.random()*((grp_buildings[2].width-300)-300) ), grp_buildings[2].y-96, runSpeed, Math.round(Math.random()));
				obstacles.add(newBaddie);
			}
		}
		/*
		 * updates all obstacles
		 */
		private function updateObstacles():void
		{
			for (var u:int = 0; u < obstacles.length; u++) {	
				if (obstacles.members[u].dead == true) {
					obstacles.members[u].kill();
					obstacles.members[u].destroy();
					obstacles.remove(obstacles.members[u], true);
				}
			}
		}
		/*
		 * updates speed/stage and all dependant objects
		 */
		private function updateSpeed():void
		{
			score += 1;
			if (score % 250 == 0) {	// at levelup....
				stage++;
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
			for (var w:int = 0; w < obstacles.length; w++) {		// change speed of obstacles
				obstacles.members[w].setRunSpeed(runSpeed);
			}
		}
		
		
		private function doCollisionDetection():void
		{
			for (var a:int = 0; a < grp_buildings.length; a++) {
				FlxG.collide(player, grp_buildings[a], playerHitBuilding);	// check if player has hit a building
			}
			for (var b:int = 0; b < obstacles.length; b++) {		// pixel perfect collision check
				if (FlxCollision.pixelPerfectCheck(player, obstacles.members[b])) {
					playerHitObstacle(player, obstacles.members[b]);
				}
			}
		}
		/*
		 * handler for collision between player and any building
		 */
		private function playerHitBuilding(pl:Player, bd:Building):void		// STILL PRETTY BUGGY------FIX ME!!!!
		{
			if(pl.isTouching(FlxObject.FLOOR)) {
				if (runSpeed < 700) { runSpeed += 2; }
				else { runSpeed += .1; }
			}else if (pl.isTouching(FlxObject.RIGHT)) {
				if((bd.y - pl.y) >= (pl.height/8)){// if hit building in lower eighth of body
					player.y = bd.y - pl.height;
					runSpeed /= 2;
				}else{
					FlxG.shake(0.01,0.025);
					runSpeed = 0;
				}
			}else{
				FlxG.shake(0.01,0.025);
				trace("dedz");
				runSpeed = 0;
			}
		}
		private function playerHitObstacle(pl:Player, ob:Obstacle):void
		{
			if (pl.attacking == true) {
				//trace("killed it");
			}else {
				runSpeed /= 2;
				FlxG.shake(0.01);
			}
			ob.dead = true;
		}
		
	}
}