package entities.towers 
{
	import entities.map.Map;
	import entities.projectiles.LaserBolt;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class LaserTower extends BasicTower 
	{
		public function LaserTower(map:Map, x:int, y:int, height:int) 
		{
			super(map, x, y, height);
			this.placeable = false;
			this.passable = false;
		}
		
		override public function added():void 
		{
			super.added();
			this.image = new Image(Assets.LASERTOWER);
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			this.addGraphic(this.image);
			//Het centrum zetten al centrum van de image
			this.image.centerOrigin();
			this.ballSpeed = 1000;
			this.towerDamage = 5;
			this.ballDurability = 3.
			this.towerASPD = 60;
			this.targetMode = 1;
		}
		
		override protected function towerUpgrade():void 
		{
			
		}
		
		override public function shootProjectile():void 
		{	
			world.add(new LaserBolt((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}

}