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
		public var image : Image;
		//Range van de toren
		public var towerRange: int = 200;
		//De snelheid van de bal die wordt afgevuurd
		public var ballSpeed: int = 500;
		//De fire cooldown
		public var towerCD: int = 0;
		//De damage van de projectitelen
		public var towerDamage: Number = 10;
		//De attack speed van de toren --> cooldown verlaagt rapper
		public var towerASPD: Number = 1;
		//Voor de toren op een target te locken
		private var lockedOn: Boolean = false;
		//De gelockde toren
		private var lockedEnemy: EnemyTemplate;
		//De schietmodus
		private var targetMode: int = 2;
		
		//Constructor
		public function BasicTower(map : Map, x : int, y : int, height : int ) {
			super(map, x, y , height);
			this.placeable = false;
			this.passable = false;
		}
		
		override public function added():void {
			//De image van de toren inladen
			super.added();
			image = new Image(Assets.BASICTOWER);
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			addGraphic(image);
			//Het centrum zetten al centrum van de image
			image.centerOrigin();

		}
		
		override public function update():void {
			//Vars
			
			//End vars
			
			
			//Test Purposes
			
			//End test purposes
			
			
			
			//De cooldown van de toren verlagen als hij hoger dan 0 is
			if(this.towerCD > 0)
				this.towerCD -= this.towerASPD * FP.elapsed;
			

				
			//Als hij nog gelocked is --> schieten op het gelocked target.
			if (lockedOn == true) {
				shoot(lockedEnemy.x, lockedEnemy.y, lockedEnemy.speed, lockedEnemy.angle);
				if (FP.distance(this.x, this.y, lockedEnemy.x, lockedEnemy.y) >= this.towerRange || lockedEnemy.isDead())
					this.lockedOn = false;
			}
			//Anders een nieuwe target zoeken.
			else
				searchNewTarget(this.targetMode);
		}
			
		
		
		//Functie die een nieuwe target zoekt.
		private function searchNewTarget(mode : int): void {
			//WIP TARGET MODES 0: FIRST 1: LAST(Not working yet) 2: CLOSEST (Works on targetting but stays locked on);
			var searchMap: Map = Map.map;

			
			//Als de modus op 0 (First) staat
			if(mode == 0) {
				//Alle enemies afgaan en de eerste enemy in range zoeken.
				for (var i: int = 0; i < searchMap.enemyList.length && !lockedOn; i++) {
					//Als we hem gevonden hebben --> Locked op true zetten en de lockedEnemy koppelen.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						this.lockedOn = true;
						this.lockedEnemy = searchMap.enemyList[i];
					}

				}
			}

			//Als de modus op 1 (Last) staat
			else if(mode == 1) {
				//Alle enemies afgaan en de laatste enemy in range zoeken.
				for (i = searchMap.enemyList.length - 1; !lockedOn &&  i >= 0; i--) {
					//Als we hem gevonden hebben --> Locked op true zetten en de lockedEnemy koppelen.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						this.lockedOn = true;
						this.lockedEnemy = searchMap.enemyList[i];
					}

				}
			}

			//Als de modus op 2 (Closest) staat
			else if (mode == 2) {
				//Vars
				var closest: EnemyTemplate;
				var closestDistance : Number;
				//End vars


				//Alle enemies afgaan en controleren wie de dichtste afstand heeft van de toren en die selecteren
				for (i = 0; i < searchMap.enemyList.length; i++) {
					//Als de huidigge enemy in range van de toren ligt gaan kijken naar zijn distance.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						//Initialiseren van closests
						if (closest == null){
							closest = searchMap.enemyList[i];
							closestDistance = FP.distance(this.x, this.y, closest.x, closest.y);
						}

						//Anders de distance van de huidige toren in range vergelijken met de laatste gevonden distance.
						//Als het lager is --> selecteren
						if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < closestDistance) {
							closest = searchMap.enemyList[i];
							closestDistance = FP.distance(this.x, this.y, closest.x, closest.y);
						}
						 
					}
				}

				//Na de loop niet locken --> moet maar 1 keer schieten.
				if(closest != null) {
					shoot(closest.x, closest.y, closest.speed, closest.angle);
					//Closest resetten.
					closest = null;
				}
			}	
		}
				

		
		
		//Een functie die 1 kogel schiet gebasseerd op de positie, snelheid en de hoek van een enemy.
		private function shoot(x : int, y : int, objectSpeed : int, objectAngle : Number):void {	
			//Vars
			var distance: Number;
			var time: Number;
			var newx: Number;
			var newy: Number;
			var i: int;
			var precision: int = 5;
			//End vars

			//De afstand berekenen tussen tower en enemy
			distance = FP.distance(this.x, this.y, x, y);
			//De tijd berekenen hoe lang de bal er over zal doen
			time = distance / ballSpeed;
			
			
			
			//De verwachte x en y waarden verhogen a.d.h.v. enemyHoek * enemySpeed * de tijd die de bal er over moet doen
			for (i = 0; i < precision; i++) {
				//newx en newy resetten en we gebruiken newx en newy zodat we de orginele positie kunnen behouden
				newx = x;
				newy = y;
				
				//De orginele x en y waarden verhogen met de berekende tijd
				newx +=  objectSpeed * Math.cos(objectAngle) * time;
				newy += objectSpeed * Math.sin(objectAngle) * time;


				//De distance van deze plaats berekenen
				distance = FP.distance(this.x, this.y, newx, newy);
				//Hier weer de tijd van berekenen
				time = distance / ballSpeed;
				//Des te vaker we dit doen des te nauwkeuriger
			}
			
			//De orginele positie verhogen met de snelheid * de gesampelde tijd
			x += ((objectSpeed) * (Math.cos(objectAngle))) * time;
			y += ((objectSpeed) * (Math.sin(objectAngle))) * time;
			

			//Volgen van target, (immage draaien)
			//Als het object zich rechts van ons bevind 
			if(x >= this.x)
				image.angle = ((Math.atan((y - this.y) / (x - this.x))) * FP.DEG);
			//Als het object zich links van ons bevind
			else
				image.angle = 180 + ((Math.atan((y - this.y) / (x - this.x))) * FP.DEG);


			//Schiet gedeelte
			//Als de toren van zijn cooldown af is mag hij schieten
			if (this.towerCD <= 0) {
				world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1));
				//Cooldown resetten
				this.towerCD = 60;
			}
		}
	}

}