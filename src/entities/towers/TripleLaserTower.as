package entities.towers 
{
	import entities.map.Map;
	import entities.projectiles.LaserBolt;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class TripleLaserTower extends Tower 
	{
		
		public function TripleLaserTower(map:Map, x:int, y:int, height:int) 
		{
			super(map, x, y, height);
			this.placeable = false;
			this.passable = false;
			this.towerASPD = 8000;
			this.targetMode = 1;
		}
			
		override public function added():void 
		{
			super.added();
			this.image = new Image(Assets.TRIPLELASERTOWER);
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			this.addGraphic(this.image);
			//Het centrum zetten al centrum van de image
			this.image.centerOrigin();
			this.targetMode = 0;
		}
	
		override public function getUpgrades(): Array {
			upgradeList = new Array();
			return upgradeList;
		}
		
		override public function shootProjectile():void 
		{
			world.add(new LaserBolt((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new LaserBolt((image.scaledWidth / 2), this.x, this.y, image.angle + 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new LaserBolt((image.scaledWidth / 2), this.x, this.y, image.angle - 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}

}