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
		private var enemies:FlxGroup;	// group of enemies
		private var enemyBullets:FlxGroup;	// group of all enemies bullets
		
		private var runSpeed:Number;	// players run speed - used to increase scroll rate of buildings, foregrounds (and baddies eventually)
		private var score:int;		// tracks distance ran
		private var stage:int;		// used to control when run speed changed
		private var eTimer:int;			// used to determine when to spawn an enemy
		
		private var distance:Number;	// used to store how far ran in current game
		private var distanceText:FlxText;	// for displaying distanse
		
		override public function create():void 
		{	
			player = new Player(FlxG.width / 10, 100, 10);	// init player 
			runSpeed = 150;												// and some vars
			score = 0;
			stage = 0;
			distance = 0;
			eTimer = 0;
			
			distanceText = new FlxText(10, 15, FlxG.width/2);
			distanceText.setFormat(null, 24, 0xffffffff);
			
			bgs = new FlxGroup();										// init backgrounds		
			bgs.add(new Background(0, runSpeed/100));
			bgs.add(new Background(2400, runSpeed / 100));
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
			enemies = new FlxGroup();
			add(enemies);
			enemyBullets = new FlxGroup();
			add(enemyBullets);
			
			add(player);
			
			fgs = new FlxGroup();	// init foregrounds and add last, so alyays  on top of all other sprites
			
			fgs.add(new Foreground(0, runSpeed*1.5));
			fgs.add(new Foreground(2400, runSpeed*1.5));		
			add(fgs);
			
			add(distanceText);
		}	
		override public function update():void
		{	
			player.x = FlxG.width / 10;
			doHUD();
			spawnEnemies();
			doCollisionDetection();
			checkUserInput();
			updateBuildings();	
			updateObstacles();
			updateEnemies();
			updateEnemyBullets();
			updateSpeed();
			updateDistance();
			
			super.update();	// update parent - draws all sprites added to this	
		}
		/*
		 * increments a timer and spawns an enemy at the right time
		 */
		private function spawnEnemies():void
		{
			eTimer++;
			if (eTimer == 500) {
				addEnemy();
				eTimer = 0;
			}
		}
		/*
		 * keeps track of how far the player has ran this go
		 */
		private function updateDistance():void
		{
			if (runSpeed < 700) {
				distance += runSpeed/1000;
			}else{
				distance += (runSpeed / 500);
			}
		}
		/*
		 * displays distance run text
		 */
		private function doHUD():void
		{
			distanceText.text = "Distance ran: " + Math.floor(distance) + "m";
		}
		/*
		 * gets keyboard input
		 */
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
			if (FlxG.keys.pressed("Q")) {}
			if (FlxG.keys.pressed("W")) {}
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
			grp_buildings.push(new Building((grp_buildings[1].x + grp_buildings[1].width + ((Math.random()*140)+(stage*10)))+player.width, grp_buildings[1].y + ((Math.random() * (FlxG.height - grp_buildings[1].y-100))- 80), runSpeed));
			add(grp_buildings[2]);
			addObstacle();
		}
		/*
		 * adds an obstacle to the top of the building at the end of the queue
		 */
		private function addObstacle():void
		{
			if(grp_buildings[2].width >= 900){
				var newBaddie:Obstacle;
				newBaddie = new Obstacle( (grp_buildings[2].x + 300) + ( Math.random()*((grp_buildings[2].width-300)-300) ), grp_buildings[2].y-96, runSpeed, Math.round(Math.random()));
				obstacles.add(newBaddie);
			}
		}
		/*
		 * adds an enemy to the building at the end of the queue
		 */
		private function addEnemy():void
		{
			if(grp_buildings[2].width < 1000){
				var newBaddie:Enemy;
				newBaddie = new Enemy( (grp_buildings[2].x + 300) + ( Math.random()*((grp_buildings[2].width-300)-300) ), grp_buildings[2].y-128, runSpeed, Math.round(Math.random()));
				enemies.add(newBaddie);
			}
		}
		/*
		 * adds an enemy bullet to the x,y arguments
		 */
		private function addEnemyBullet(x:int,y:int):void
		{		
			var newBaddie:EnemyBullet;
			newBaddie = new EnemyBullet( x,y+50,runSpeed,0,3);
			enemyBullets.add(newBaddie);
		}
		/*
		 * updates all obstacles - garbage collection
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
		 * updated all enemies - garbage collection
		 * 					   - fires
		 */
		private function updateEnemies():void
		{
			for (var u:int = 0; u < enemies.length; u++) {
				if (enemies.members[u].shootTimer >= 500 )  {
					enemies.members[u].shootTimer = 0;
					addEnemyBullet(enemies.members[u].x,enemies.members[u].y);
				}
				if (enemies.members[u].dead == true) {
					enemies.members[u].kill();
					enemies.members[u].destroy();
					enemies.remove(enemies.members[u], true);
				}
			}
		}
		/*
		 * updates enemy bullets - garbage collection
		 */
		private function updateEnemyBullets():void
		{
			for (var u:int = 0; u < enemyBullets.length; u++) {	
				if (enemyBullets.members[u].dead == true) {
					enemyBullets.members[u].kill();
					enemyBullets.members[u].destroy();
					enemyBullets.remove(enemyBullets.members[u], true);
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
			for (var y:int = 0; y < enemies.length; y++) {		// change speed of enemies
				enemies.members[y].setRunSpeed(runSpeed);
			}
			for (var x:int = 0; x < enemyBullets.length; x++) {		// change speed of enemy bullets
				enemyBullets.members[x].setRunSpeed(runSpeed);
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
			for (var c:int = 0; c < enemies.length; c++) {		// pixel perfect collision check
				if (FlxCollision.pixelPerfectCheck(player, enemies.members[c])) {
					playerHitEnemy(player, enemies.members[c]);
				}
			}
			for (var d:int = 0; d < enemyBullets.length; d++) {		// pixel perfect collision check
				if (FlxCollision.pixelPerfectCheck(player, enemyBullets.members[d])) {
					playerHitEnemyBullet(player, enemyBullets.members[d]);
				}
			}
		}
		/*
		 * handler for collision between player and any building
		 */
		private function playerHitBuilding(pl:Player, bd:Building):void		
		{
			if(pl.isTouching(FlxObject.FLOOR)) {
				if (runSpeed < 70) { runSpeed += .1; }
				else if (runSpeed > 700) { runSpeed += .1; }
				else { runSpeed += 1; }
			}else if (pl.isTouching(FlxObject.RIGHT)) {
				if((bd.y - pl.y) >= 60){	// if player is 60 or more pixels above ledge (ie, just clipped it)
					player.y = bd.y - pl.height;
					runSpeed /= 2;
				}else{
					FlxG.shake(0.01,0.025);
					runSpeed = 0;
					FlxG.fade(0xff000000, 1.5, restartState);
				}
			}else{
				FlxG.shake(0.02,0.025);
				runSpeed = 0;
			}
		}
		/*
		 * handler for collision between player and obstacle
		 */
		private function playerHitObstacle(pl:Player, ob:Obstacle):void
		{
			if (pl.attacking == true && ob.type == 1) {
				FlxG.flash(0xffaa0000, 0.3);
			}else {
				runSpeed /= 3;
				FlxG.shake(0.01);
			}
			ob.dead = true;
		}
		/*
		 * handler for collision between player and enemy
		 */
		private function playerHitEnemy(pl:Player, ob:Enemy):void
		{
			if (pl.attacking == true) {
				FlxG.flash(0xffaa0000, 0.3);
			}else {
				runSpeed /= 3;
				FlxG.shake(0.01);
			}
			ob.dead = true;
		}
		/*
		 * handler for collision between player and enemy bullet
		 */
		private function playerHitEnemyBullet(pl:Player, ob:EnemyBullet):void
		{
			if (pl.attacking == true) {
				// hit bullet with weapon
			}else {
				runSpeed /= 3;
				FlxG.shake(0.01);
			}
			ob.dead = true;
		}
		/*
		 * resets playstate
		 */
		private function restartState():void
		{
			FlxG.resetState();
		}
	}
}