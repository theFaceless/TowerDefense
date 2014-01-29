package entities.towers 
{
	import net.flashpunk.graphics.Image;
	import entities.projectiles.BasicBall;
	
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class TripleShotTower extends Tower
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
		
		override public function shootProjectile():void 
		{
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle + 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
			world.add(new BasicBall((image.scaledWidth / 2), this.x, this.y, image.angle - 30, ballSpeed, this.towerDamage, this.groundHeight + 1, ballDurability));
		}
		
	}
	
	

}