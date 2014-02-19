package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	import entities.projectiles.BasicBall;
	import entities.testenemy.EnemyTemplate;
	import entities.upgrades.Upgrade;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.Player;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class Tower extends TowerTemplate 
	{
		public var image: Image;
		//Range van de toren
		public var towerRange: int = 200;
		//De snelheid van de bal die wordt afgevuurd
		public var ballSpeed: int = 500;
		//De fire cooldown
		public var towerCD: int = 0;
		//De damage van de projectitelen
		public var towerDamage: Number = 0.1;
		//De attack speed van de toren --> cooldown verlaagt rapper
		public var towerASPD: Number = 1;
		//Voor de toren op een target te locken
		private var lockedOn: Boolean = false;
		//De gelockde toren
		private var lockedEnemy: EnemyTemplate;
		//De schietmodus
		public var targetMode: int = 0;
		//Durability van kogel
		public var ballDurability: int = 1;
		//Toren destroyed
		public var isDestroyed : Boolean = false;
		//Health
		public var towerHealth : Number = 100;
		//
		public var powerAura: int = 200;
		//
		public var upgradeList: Array;
		
		//Constructor
		public function Tower(map : Map, x : int, y : int, height : int ) {
			super(map, x, y , height);
			this.placeable = false;
			this.passable = false;
			this.layer = References.TOWERLAYER;
			this.isTower = true;
		}
		public function  selltower(tower: BasicTower, value: Number):void 
		{	

			var ground: GroundTile = new GroundTile(Map.map ,this.gridX, this.gridY, this.groundHeight);

			Map.map.setGroundTile(this.gridX, this.gridY, ground);

			FP.world.remove(this);
	
			Player.addMoney(value * References.SELLPERCENTAGE);

		}


		
		override public function added():void {
			//De image van de toren inladen
			super.added();	
		}
		
		override public function update():void {
			//Vars
			
			
			
			//De cooldown van de toren verlagen als hij hoger dan 0 is
			if(this.towerCD > 0)
				this.towerCD -= this.towerASPD * FP.elapsed;
			

				
			//Als hij nog gelocked is --> schieten op het gelocked target.
			if (this.isConnectedToPower && !this.isDestroyed) {
				if (lockedOn == true) {
					shoot(lockedEnemy.x, lockedEnemy.y, lockedEnemy.speed, lockedEnemy.angle);
					if (FP.distance(this.x, this.y, lockedEnemy.x, lockedEnemy.y) >= this.towerRange || lockedEnemy.isDead())
						this.lockedOn = false;
				}
				//Anders een nieuwe target zoeken.
				else
					searchNewTarget(this.targetMode);
			}
		}
		
		//Upgrade functies barebone
		public function towerUpgrade(upgrade: Upgrade):void 
		{
			var tempTower: Tower;
			if (upgrade.name == "Basic Tower") {
				tempTower = new BasicTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
			else if (upgrade.name == "Fire Tower") {
				tempTower = new FireTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
			else if (upgrade.name == "Laser Tower") {
				tempTower = new LaserTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
			else if (upgrade.name == "Power Tower") {
				tempTower = new PowerTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
			else if (upgrade.name == "Triple Laser Tower") {
				tempTower = new TripleLaserTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
			else if (upgrade.name == "Triple Shot Tower") {
				tempTower = new TripleShotTower(Map.map, this.gridX, this.gridY, this.groundHeight);
				Map.map.upgradeTower(this, tempTower);
			}
		}
		
		public function getUpgrades(): Array {
			upgradeList = new Array();
			return upgradeList;
		}
		
		
		//Functie die een nieuwe target zoekt.
		public function searchNewTarget(mode : int): void {
			/*
			 * Mode 0: First target (Least amount of tiles left)
			 * Mode 1: Last target (Most amount of tiles left)
			 * Mode 2: Closest target (Closest FP.distance())
			 * Mode 3: Least HP / Weakest 
			 * Mode 4: Most HP / Strongest
			 */
			var searchMap: Map = Map.map;

			//Als de modus op 0 (First) staat
			if (mode == 0) {
				var firstLength: Number;
				var first: EnemyTemplate;
				//Alle enemies afgaan en de laatste enemy in range zoeken.
				for (i = searchMap.enemyList.length - 1; !lockedOn &&  i >= 0; i--) {
					//Als we hem gevonden hebben --> Locked op true zetten en de lockedEnemy koppelen.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange - 50) {
						
						if (first == null) {
							firstLength = searchMap.enemyList[i].getLength();
							first = searchMap.enemyList[i];
						}
						
						if (firstLength > searchMap.enemyList[i].getLength()) {
							firstLength = searchMap.enemyList[i].getLength();
							first = searchMap.enemyList[i];
						}
						
					}

				}
				if (first != null) {
					this.lockedEnemy = first;
					this.lockedOn = true;
				}
			}

			//Als de modus op 1 (Last) staat
			else if (mode == 1) {
				var last: EnemyTemplate;
				var lastLength: Number;
				//Alle enemies afgaan en de eerste enemy in range zoeken.
				for (var i: int = 0; i < searchMap.enemyList.length && !lockedOn; i++) {
					//Als we hem gevonden hebben --> Locked op true zetten en de lockedEnemy koppelen.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						
						if (last == null) {
							lastLength = searchMap.enemyList[i].getLength();
							last = searchMap.enemyList[i];
						}
						
						if (lastLength < searchMap.enemyList[i].getLength()) {
							lastLength = searchMap.enemyList[i].getLength();
							last = searchMap.enemyList[i];
						}
						
					}

				}
				if(last != null)
					shoot(last.x, last.y, last.speed, last.speed);
				last = null;
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
			// als de mode op 3 staat(minste hp).
			else if (mode == 3) {
				//Vars
				var weakest: EnemyTemplate;
				var leasthealth : Number;
				//End vars


				//Alle enemies afgaan en controleren wie de minste health heeft van de toren en die selecteren
				for (i = 0; i < searchMap.enemyList.length; i++) {
					//Als de huidigge enemy in health van de toren ligt gaan kijken naar zijn health.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						//Initialiseren van closests
						if (weakest == null){
							weakest = searchMap.enemyList[i];
							leasthealth = searchMap.enemyList[i].health;
						}

						//Anders de health van de huidige toren in range vergelijken met de laatste gevonden health.
						//Als het lager is --> selecteren
						if (searchMap.enemyList[i].health < leasthealth) {
							weakest = searchMap.enemyList[i];
							leasthealth = searchMap.enemyList[i].health;
						}
						 
					}
				}

				//Na de loop niet locken --> moet maar 1 keer schieten.
				if ( weakest != null){
					shoot(weakest.x, weakest.y, weakest.speed, weakest.angle);

				// weakest resetten.
				weakest = null;
				}
			}
			// als de mode op 4 staat(meeste hp).
			else if (mode == 4) {
				//Vars
				var strongest: EnemyTemplate;
				var mosthealth : Number;
				//End vars


				//Alle enemies afgaan en controleren wie de meeste hp heeft van de toren en die selecteren
				for (i = 0; i < searchMap.enemyList.length; i++) {
					//Als de huidigge enemy in range van de toren ligt gaan kijken naar zijn distance.
					if (FP.distance(this.x, this.y, searchMap.enemyList[i].x, searchMap.enemyList[i].y) < this.towerRange) {
						//Initialiseren van strongest
						if ( strongest == null){
							strongest = searchMap.enemyList[i];
							mosthealth = searchMap.enemyList[i].health;
						}

						//Anders de health van de huidige toren in range vergelijken met de laatste gevonden health.
						//Als het hoger is --> selecteren
						if (searchMap.enemyList[i].health > mosthealth) {
							strongest = searchMap.enemyList[i];
							mosthealth = searchMap.enemyList[i].health;
						}
						 
					}
				}

				//Na de loop niet locken --> moet maar 1 keer schieten.
				if (strongest != null){
					shoot(strongest.x, strongest.y, strongest.speed, strongest.angle);

				//strongest resetten.
				strongest = null;
				}
			}
		
		}
		
		
		//Een functie die 1 kogel schiet gebasseerd op de positie, snelheid en de hoek van een enemy.
		public function shoot(x : int, y : int, objectSpeed : int, objectAngle : Number):void {	
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
				shootProjectile();
				
				//Cooldown resetten
				this.towerCD = 60;
			}
		}
		
		public function shootProjectile():void 
		{
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
		public function giveDamage(damage : Number):void 
		{
			this.towerHealth -= damage;
			if (this.towerHealth <= 0) {
				this.isDestroyed = true;
				var temp: GroundTile = new GroundTile(Map.map, this.gridX, this.gridY, this.groundHeight);
				FP.world.add(temp);
				Map.map.setGroundTile(this.gridX, this.gridY, temp);
				FP.world.remove(this);
			}
		}
		
	}

}