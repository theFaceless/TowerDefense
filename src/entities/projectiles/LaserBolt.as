package entities.projectiles 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class LaserBolt extends Projectile 
	{
		
		public function LaserBolt(width:Number, x:int, y:int, angle:Number, speed:Number, damage:Number, givenHeight:int, givenDurability:int) 
		{
			super(width, x, y, angle, speed, damage, givenHeight, givenDurability);
		}
		
		override public function added():void 
		{
			//Image inladen
			this.image = new Image(Assets.LASERBOLT);
			//Image koppelen
			this.graphic = image;
			//Center van image --> center van entity
			image.centerOrigin();
			//Image draaien
			this.image.angle = this.projectileAngle * FP.DEG;
		}
		
	}

}