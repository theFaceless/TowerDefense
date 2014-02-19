package entities.towers 
{
	import entities.map.Map;
	import entities.projectiles.FireBeam;
	import flash.display.Graphics;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class FireTower extends Tower 
	{
		
		public function FireTower(map:Map, x:int, y:int, height:int) 
		{
			super(map, x, y, height);
			this.image = new Image(Assets.FIRETOWER);
			this.towerASPD = 3000;
			this.towerRange = 150;
			
		}
		
		override public function added():void 
		{
			super.added();
			image.color = 0x1f1f1f * (groundHeight + 2);
			//De image koppellen
			this.addGraphic(this.image);
			//Het centrum zetten al centrum van de image
			this.image.centerOrigin();
			this.targetMode = 0;
		}
		
		override public function getUpgrades(): Array {
			return upgradeList;
		}
		
		override public function shootProjectile():void 
		{	
			world.add(new FireBeam((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}

}