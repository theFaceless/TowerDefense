package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	import entities.projectiles.LaserBolt;
	import entities.upgrades.Upgrade;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class LaserTower extends Tower
	{
		public function LaserTower(map:Map, x:int, y:int, height:int) 
		{
			super(map, x, y, height);
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
		
		override public function getUpgrades(): Array {
			upgradeList = new Array();
			upgradeList.push(new Upgrade("Triple Laser Tower", 200, "An upgraded version of the Laser Tower which shoots 3 projectiles instead of 1.", new Image(Assets.TRIPLELASERTOWER), this.towerRange, this.towerDamage, this.towerASPD, this.towerHealth)); 
			return upgradeList;
		}
		
		override public function shootProjectile():void 
		{	
			world.add(new LaserBolt((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}

}