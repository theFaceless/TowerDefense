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
	public class TripleShotTower extends BasicTower 
	{
		private var angle: Number;
		private var lockedOn: Boolean = false;
		//De gelockde toren
		private var lockedEnemy: EnemyTemplate;
		//De schietmodus
		private var targetMode: int = 0;
		public function TripleShotTower(map:Map, x:int, y:int, height:int) 
		{
			super(map, x, y, height);
			this.placeable = false;
			this.passable = false;
		}
			
		override public function added():void 
		{
			super.added();
			this.image = new Image(Assets.TRIPLESHOTTOWER);
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			this.addGraphic(this.image);
			//Het centrum zetten al centrum van de image
			this.image.centerOrigin();
		}
		
		override protected function towerUpgrade():void 
		{
			
		}
		
		override public function shoot(x : int, y : int, objectSpeed : int, objectAngle : Number):void {	
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
				world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle + 30, ballSpeed, this.towerDamage, this.groundHeight + 1));
				world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle - 30, ballSpeed, this.towerDamage, this.groundHeight + 1));
				//Cooldown resetten
				this.towerCD = 60;
			}
		}
		
	}

}