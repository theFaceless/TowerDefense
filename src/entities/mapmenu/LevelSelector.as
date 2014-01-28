package entities.mapmenu 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import worlds.LevelMapWorld;
	import worlds.TestWorld;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class LevelSelector extends Entity 
	{
		
		public var level : Class;
		public var image : Spritemap;
		
		
		public function LevelSelector(x:Number, y:Number, level : Class) 
		{
			super(x, y);
			this.level = level;
			setHitbox(30, 30);
		}
		
		override public function added():void 
		{
			super.added();
			image = new Spritemap(Assets.VLAG, 30, 30);
			image.add("wapperunselected", [0, 1, 2, 3], 4, true);
			image.add("wapperselected", [4, 5, 6, 7], 4, true);
			image.play("wapperunselected", false, 0);
			addGraphic(image);
			
		}
		
		override public function update():void 
		{
			if (collidePoint(x, y, Input.mouseX + FP.camera.x, Input.mouseY + FP.camera.y )) {
				image.play("wapperselected", false, image.frame);
				if (Input.mouseReleased) {
					FP.world = new TestWorld(level);
				}
			} else {
				image.play("wapperunselected", false, image.frame);
			}
			
		}
		
	}

}