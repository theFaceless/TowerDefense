package entities.towers 
{
	import entities.map.Map;
	import entities.projectiles.BasicBall;
	import entities.projectiles.FireBeam;
	import entities.upgrades.Upgrade;
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
		
		
		override public function getUpgrades(): Array {
			upgradeList = new Array();
			upgradeList.push(new Upgrade("Fire Tower", 400,  "The Fire Tower is basicly a giant flamethrower.", new Image(Assets.FIRETOWER), 150, 5, 3000, 100));
			upgradeList.push(new Upgrade("Laser Tower", 150, "The Laser Tower is a tower which shoots powerfull lasers.", new Image(Assets.LASERTOWER), this.towerRange, 5, 60, 100));
			upgradeList.push(new Upgrade("Triple Shot Tower", 250, "The Triple Shot Tower is an upgraded Basic Tower with 3 barrels.", new Image(Assets.TRIPLESHOTTOWER), this.towerRange, this.towerDamage * 3, this.towerASPD, 100));
			return upgradeList;
		}
		
		//Override -> Custom bullet
		override public function shootProjectile():void 
		{
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
	}

}