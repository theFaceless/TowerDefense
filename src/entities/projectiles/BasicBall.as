package entities.projectiles 
{
	import entities.map.Map;
	import entities.testenemy.EnemyTemplate;
	import flash.automation.KeyboardAutomationAction;
	import flash.display.InteractiveObject;
	import flash.display.PixelSnapping;
	import flash.events.DRMCustomProperties;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import entities.gui.Gui;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class BasicBall extends Entity 
	{
		//Image var
		public var image: Image;
		//De damage van de ball
		public var ballDamage: Number;
		//De snelheid van de ball
		public var ballSpeed: Number;
		//De hoek van de ball
		public var ballAngle: Number;
		//De hoogte van de ball
		public var ballHeight: int;



		
		public function BasicBall(width: Number, x : int, y : int, angle : Number, speed: Number, damage: Number, givenHeight: int) {
			this.layer = References.PROJECTILELAYER;
			//De speed updaten naar de gewenste speed (Nodig voor update functie)
			this.ballSpeed = speed;
			//Doorgegeven angle is in graden, deze omvormen naar radialen en opslagen als globale variabele (Nodig voor update functie)
			this.ballAngle = angle *= FP.RAD;
			//Doorgegeven damage toevoegen;
			this.ballDamage = damage;
			//Doorgeven Height
			this.ballHeight = givenHeight;
	
			//Berekende start positie a.d.h.v. berekende lengte van de 'loop' FUCKING GONIOMETRIE
			this.x = x + (width * (Math.cos(this.ballAngle)));
			this.y = y + (width * (Math.sin(this.ballAngle)));
		}
		


		override public function added():void {
			//Image koppellen aan toren
			image = new Image(Assets.BASICBALL);
			this.graphic = image;
			//Center van image --> center van entity
			image.centerOrigin();
		}
		


		override public function update():void {
			//Vars
			var i: int;
			var hitEnemy: EnemyTemplate;

			//Omdat de ball constant moet bewegen moet hij met elke update via zijn hoek bewegen, goniometrische formule.
			this.x += (this.ballSpeed * (Math.cos(this.ballAngle))) * FP.elapsed;
			this.y += (this.ballSpeed * (Math.sin(this.ballAngle))) * FP.elapsed;
			

			//Als hij buiten de map is --> sterven
			if (this.x < 0 || this.x > (Map.map.mapWidth * References.TILESIZE) || this.y < 0 || this.y > (Map.map.mapHeight * References.TILESIZE))
			{
				die();
			}
			
			//Alle enemies afgaan
			for (i = 0; i < Map.map.enemyList.length; i++) {
				//Als de distance tot een enemy kleiner is als zijn straal dan heeft hij deze geraakt --> hitEnemy kopellen en uit de loop gaan
				if (FP.distance(Map.map.enemyList[i].x, Map.map.enemyList[i].y, this.x, this.y) < Map.map.enemyList[i].image.scaledWidth / 2.2) {
					hitEnemy = Map.map.enemyList[i];
					break;
				}
			}
			
			
			//Als we een enemy geraakt hebben de hit functie oproepen
			if (hitEnemy != null)
				hit(hitEnemy);
			

			//Als de groundtile niet bestaat --> out of map --> sterven, anders kijken of hij hoger is dan de grond, zo nee --> sterven		
			if (Map.map.getGroundTile((this.x / References.TILESIZE), (this.y / References.TILESIZE))== null || Map.map.getGroundTile((this.x / References.TILESIZE), (this.y / References.TILESIZE)).groundHeight > ballHeight)
				die();

		}
		

		//Een functie die de ball laat verdwijnen
		private function die(): void {
			FP.world.remove(this);
		}
		

		//Een functie die wordt uitgevoerd bij een enemy hit
		private function hit(enemy:EnemyTemplate): void {
			enemy.takeDamage(this.ballDamage);
			die();
		}
		
		
	}

}