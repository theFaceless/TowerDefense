package entities.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Pixelmask;
	
	/**
	 * ...
	 * @author Wout Coenen
	 */
	public class GuiOverlay extends Entity
	{
		
		private var sizeX: int;
		private var sizeY: int;
		private var image : Image;
		private var minimapSizeX: int;
		private var buttonCount: int;
		private var callback: Function;
		
		private var borderSize: int;
		private var buttonAreaHeight: int;
		
		public function GuiOverlay(callback: Function = null, minimapSizeX: int = 0, borderSize: int = 0, buttonAreaHeight: int = References.TILESIZE) {
			super();
			this.callback = callback;
			this.minimapSizeX = minimapSizeX;
			this.borderSize = borderSize;
			this.buttonAreaHeight = buttonAreaHeight;
			
		}
		
		override public function added() : void {
			
			image = new Image(Assets.GUIOVERLAY);
			graphic = image;
			sizeX = image.width;
			sizeY = image.height;
			x = 0;
			y = 0;
			image.scrollX = 0;
			image.scrollY = 0;
			layer = References.GUILAYER;
			setHitboxTo(new Pixelmask(Assets.GUIOVERLAY));
			
			//add buttons here
			buttonCount = 2;
			var i: int = 1;
			FP.world.add(new GuiButtonAddTower(callback, minimapSizeX + (sizeX - (minimapSizeX + borderSize)) / (buttonCount + 1) * i++,(
												sizeY - borderSize - buttonAreaHeight / 2) -1));
			FP.world.add(new GuiButtonToggleDebug(callback, minimapSizeX + (sizeX - minimapSizeX - borderSize) / (buttonCount + 1) * i++,
													sizeY - borderSize - buttonAreaHeight / 2));
			
		}
		
		override public function update(): void {
			
		}
		
	}

}