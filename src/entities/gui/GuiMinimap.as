package entities.gui 
{
	import entities.GroundTile;
	import entities.map.Map;
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class GuiMinimap extends Entity
	{
		public var image : Image;
		private var scaling: int = 4;
		
		public function GuiMinimap() 
		{
		}
		
		override public function added():void 
		{
			
			makeMap();
			
			//add overlay for current position
			FP.world.add(new GuiMinimapCameraOverlay(scaling));
			
		}
		
		override public function update():void 
		{
			//we make the minimap draggable
			if (Input.mouseDown) {
				if (Input.mouseX >= x && Input.mouseX <= x + image.scaledWidth) {
					if (Input.mouseY >= y && Input.mouseY <= y + image.scaledHeight) {
						//we put the camera in the right spot
						FP.camera.x = Input.mouseX * 40 / 4 - FP.halfWidth;
						FP.camera.y = (Input.mouseY - y) * 40 / 4 - FP.halfHeight; 
						//and clamp the camera so it doesn't go out of bounds
						if (FP.camera.x < 0) FP.camera.x = 0;
						if (FP.camera.y < 0) FP.camera.y = 0;
						if (FP.camera.x > Map.map.mapWidth * References.TILESIZE - FP.width) FP.camera.x = Map.map.mapWidth * References.TILESIZE - FP.width;
						if (FP.camera.y > Map.map.mapHeight * References.TILESIZE - FP.height) FP.camera.y = Map.map.mapHeight * References.TILESIZE - FP.height;
					}
				}
			}
		}
		
		public function makeMap():void
		{
			layer = References.GUILAYER;
			var data : BitmapData = new BitmapData(Gui.map.mapWidth, Gui.map.mapHeight, false, 0xFF000000);
			var tile : GroundTile;
			for (var i : int = 0 ; i < Gui.map.mapWidth ; i++) {
				for (var k : int = 0 ; k < Gui.map.mapHeight ; k++) {
					tile = Gui.map.getGroundTile(i, k);
					data.setPixel(i, k, (3 + tile.groundHeight) * 0x1C1C1C);
				}
			}
			image = new Image(data);
			image.scale = scaling;
			image.scrollX = 0;
			image.scrollY = 0;
			image.alpha = 0.8;
			this.graphic = image;
			x = 0;
			y = FP.height - image.scaledHeight;
		}
		
	}

}