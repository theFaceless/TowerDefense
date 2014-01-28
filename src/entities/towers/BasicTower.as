package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	import entities.projectiles.BasicBall;
	import flash.display.InteractiveObject;

	import entities.testenemy.EnemyTemplate;
	
	import flash.ui.Mouse;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input; 
	import net.flashpunk.utils.Key;
	import worlds.TestWorld;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class BasicTower extends GroundTile
	{
		//Range van de toren
		public var range: int = 200;
		//De snelheid van de bal die wordt afgevuurd
		public var ballspeed: int = 500;
		//De fire cooldown
		public var cooldown: int = 0;
		//De damage van de projectitelen
		public var damage: Number = 10;
		public var aspd: Number = 1;
		public var image : Image;
		private var lockedOn: Boolean = false;
		private var lockedEnemy: EnemyTemplate;
		
		//Constructor
		public function BasicTower(map : Map, x : int, y : int, height : int ) 
		{
			super(map, x, y , height);
			this.placeable = false;
			this.passable = false;
		}
		
		override public function added():void 
		{
			//De image van de toren inladen
			super.added();
			image = new Image(Assets.BASICTOWER);
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			addGraphic(image);
			//Het centrum zetten al centrum van de image
			image.centerOrigin();

		}
		
		override public function update():void 
		{
		
			//Test Purposes
			if (Input.check(Key.A)) {
				this.ballspeed += 100;
			}
			if (Input.check(Key.B)) {
				this.range += 10;
			}
			if (Input.check(Key.C)) {
				this.aspd++;
			}
			
			
			
			//End test purposes
			
			//De cooldown van de toren verlagen als hij hoger dan 0 is
			if(this.cooldown > 0)
				this.cooldown -= aspd * FP.elapsed;
			

			
			if (lockedOn == true) {
				shoot(lockedEnemy.x, lockedEnemy.y, lockedEnemy.speed, lockedEnemy.angle);
				if (FP.distance(this.x, this.y, lockedEnemy.x, lockedEnemy.y) >= this.range || lockedEnemy.isDead())
					this.lockedOn = false;
			}
			else
				searchNewTarget(2);
		}
			
		private function searchNewTarget(mode : int): void {
			//WIP TARGET MODES 0: FIRST 1: LAST(Not working yet) 2: CLOSEST (Works on targetting but stays locked on);
			var searchMap: Map = Map.map;
			if(mode == 0) {
				for (var i: int = 0; i < Map.map.enemyList.length && !lockedOn; i++) {
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.range) {
						this.lockedOn = true;
						 
						this.lockedEnemy = searchMap.enemyList[i];
						trace("New target: " + i + " Cords:(" + this.lockedEnemy.x + "," + this.lockedEnemy.y + ")");
					}
				}
			}
			else if(mode == 1) {
				for (var i: int = searchMap.enemyList.length - 1; !lockedOn &&  i >= 0; i--) {
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.range) {
						this.lockedOn = true;
						 
						this.lockedEnemy = searchMap.enemyList[i];
						trace("New target: " + i + " Cords:(" + this.lockedEnemy.x + "," + this.lockedEnemy.y + ")");
					}
				}
			}
			else if (mode == 2) {
				var closest: EnemyTemplate;
				var closestDistance : Number;
				for (i= 0; i < searchMap.enemyList.length; i++) {
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.range) {
						if (closest == null){
							closest = searchMap.enemyList[i];
							closestDistance = FP.distance(this.x, this.y, closest.x, closest.y);
						}
						if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < closestDistance) {
							closest = searchMap.enemyList[i];
							closestDistance = FP.distance(this.x, this.y, closest.x, closest.y);
						}
						 
					
					}
				}
				shoot(closest.x, closest.y, closest.speed, closest.angle);
				closest = null;
			}
			
			
			
		}
				
		private function shoot(x : int, y : int, objectSpeed : int, objectAngle : Number):void 
		{	
			var enemies : Vector.<EnemyTemplate>;
			
			world.getClass(EnemyTemplate, enemies);
			
			//Vars
			var distance: Number;
			var time: Number;
			//End vars
			
			world.getClass(EnemyTemplate, Object);

			//De afstand berekenen tussen tower en enemy
			distance = FP.distance(this.x, this.y, x, y);
			//De tijd berekenen hoe lang de bal er over al doen
			time = distance / ballspeed;
			
			var newx: Number;
			var newy: Number;
			var i: int;
			var precision: int = 30;
			//De verwachte x en y waarden verhogen a.d.h.v. enemyHoek * enemySpeed * de tijd die de bal er over moet doen
			for (i = 0; i < 50; i++) {
				newx = x;
				newy = y;
				
				newx +=  objectSpeed * Math.cos(objectAngle) * time;
				newy += objectSpeed * Math.sin(objectAngle) * time;
				
				distance = FP.distance(this.x, this.y, newx, newy);
				time = distance / ballspeed;
				
				
			}
			
			x += ((objectSpeed) * (Math.cos(objectAngle))) * time;
			y += ((objectSpeed) * (Math.sin(objectAngle))) * time;
			
			//Als het object zich rechts van ons bevind 
			if(x >= this.x)
				image.angle = ((Math.atan((y - this.y) / (x - this.x))) * FP.DEG);
			//Als het object zich links van ons bevind
			else
				image.angle = 180 + ((Math.atan((y - this.y) / (x - this.x))) * FP.DEG);
			//Als de toren van zijn cooldown af is mag hij schieten
			if (this.cooldown <= 0) {
				world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballspeed, this.damage, this.groundHeight + 1));
				//Cooldown resetten
				this.cooldown = 60;
			}
		}
	}

}