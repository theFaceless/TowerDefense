package entities.projectiles 
{
	import entities.testenemy.EnemyTemplate;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class FireBeam extends Projectile 
	{
		public var lifeTime: Number = 2;
		public function FireBeam(width:Number, x:int, y:int, angle:Number, speed:Number, damage:Number, givenHeight:int, givenDurability:int) 
		{
			super(width, x, y, angle, speed, damage, givenHeight, givenDurability);
			this.image = new Image(Assets.FIREBEAM);
		}
		
		override public function added():void 
		{
			super.added();
			this.addGraphic(image);
			this.image.centerOrigin();
			this.image.angle = this.projectileAngle * FP.DEG;
		}
		
		override public function update():void 
		{
			super.update();
			lifeTime -= 10 * FP.elapsed;
			if (lifeTime <= 0)
				this.die();
		}

		override public function hit(enemy:EnemyTemplate): void {
		  enemy.takeDamage(this.projectileDamage);
		}
	}

}