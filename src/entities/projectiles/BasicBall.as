package entities.projectiles 
{
	import net.flashpunk.graphics.Image;

	/**
	 * ...
	 * @author Shadowblink
	 */
	public class BasicBall extends Projectile
	{		
		public function BasicBall(width: Number, x : int, y : int, angle : Number, speed: Number, damage: Number, givenHeight: int, givenDurability: int) {
			super(width, x, y, angle, speed, damage, givenHeight, givenDurability);
		}
		

		override public function added():void {
			//Image koppellen aan toren
			image = new Image(Assets.BASICBALL);
			this.graphic = image;
			
			//Center van image --> center van entity
			image.centerOrigin();
		}
		
	}

}