package entities.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Wout Coenen
	 */
	public class GuiOverlayTowerOptions extends Entity {
		
		private var image: Image;
		
		public function GuiOverlayTowerOptions() {
			super();
		}
		
		override public function added(): void {
			image = new Image(Assets.GUISELECTIONOVERLAY);
			image.centerOrigin();
			image.visible = false;
			graphic = image;
			setHitbox(image.width, image.height, image.width / 2, image.height / 2);
			image.scrollX = 0;
			image.scrollY = 0;
			x = FP.width - image.width / 2;
			y = image.height / 2;
		}
		
		public function show(): void {
			image.visible = true;
		}
		
		public function hide(): void {
			image.visible = false;
		}
		
	}

}