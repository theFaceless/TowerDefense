package entities.towers 
{
	import entities.map.Map;
	import entities.upgrades.Upgrade;
	import net.flashpunk.graphics.Image;
	import entities.projectiles.BasicBall;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class TripleShotTower extends Tower {

		
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
			this.targetMode = 0;
		}
		
		override public function getUpgrades(): Array {
			upgradeList = new Array();
			upgradeList.push(new Upgrade("Triple Laser Tower", 100, "An upgraded version of the Laser Tower which shoots 3 projectiles instead of 1.", new Image(Assets.TRIPLELASERTOWER), this.towerRange, this.towerDamage, this.towerASPD, this.towerHealth)); 
			return upgradeList;
		}
		
		override public function shootProjectile():void 
		{
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle + 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle - 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}
	
	

}