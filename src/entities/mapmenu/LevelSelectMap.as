package entities.mapmenu 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class LevelSelectMap extends Entity 
	{
		public var image : Image;
		
		public function LevelSelectMap() 
		{
			
		}
		
		override public function added():void 
		{
			this.image = new Image(Assets.MAP);
			addGraphic(image);
		}
		
	}

}