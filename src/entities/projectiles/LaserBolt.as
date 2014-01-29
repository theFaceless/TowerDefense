package entities.projectiles 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class LaserBolt extends BasicBall 
	{
		
		public function LaserBolt(width:Number, x:int, y:int, angle:Number, speed:Number, damage:Number, givenHeight:int, givenDurability:int) 
		{
			super(width, x, y, angle, speed, damage, givenHeight, givenDurability);
			
		}
		
		override public function added():void 
		{
			this.image = new Image(Assets.LASERBOLT);
			this.graphic = image;
			//Center van image --> center van entity
			image.centerOrigin();
			this.image.angle = this.ballAngle * FP.DEG;
		}
		
	}

}