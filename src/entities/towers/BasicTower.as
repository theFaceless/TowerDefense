package entities.towers 
{
	import entities.map.Map;
	import entities.projectiles.BasicBall;
	import entities.projectiles.FireBeam;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class BasicTower extends Tower
	{
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
		
		//Upgrade Functie
		override public function towerUpgrade():void 
		{ 
			var tempTower: FireTower = new FireTower(Map.map, this.gridX, this.gridY, this.groundHeight);
			Map.map.upgradeTower(this, tempTower);
		}
		
		//Override -> Custom bullet
		override public function shootProjectile():void 
		{
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
	}

}