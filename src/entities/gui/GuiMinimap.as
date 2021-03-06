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
			setHitbox(Map.map.mapWidth * scaling, Map.map.mapHeight * scaling, 0, 0);
			
			//add overlay for current position
			FP.world.add(new GuiMinimapCameraOverlay(scaling));
			
			Gui.eventHandler("MinimapAdded");
			
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
						Map.map.clampCamera();
					}
				}
			}
		}
		
		public function makeMap():void
		{
			layer = References.GUILAYER - 1;
			var data : BitmapData = new BitmapData(Map.map.mapWidth, Map.map.mapHeight, false, 0xFF000000);
			var tile : GroundTile;
			for (var i : int = 0 ; i < Map.map.mapWidth ; i++) {
				for (var k : int = 0 ; k < Map.map.mapHeight ; k++) {
					tile = Map.map.getGroundTile(i, k);
					data.setPixel(i, k, (3 + tile.groundHeight) * 0x1C1C1C);
				}
			}
			image = new Image(data);
			image.scale = scaling;
			image.scrollX = 0;
			image.scrollY = 0;
			this.graphic = image;
			x = 0;
			y = FP.height - image.scaledHeight;
		}
		
		public function getSizeX(): int {
			return Map.map.mapWidth * scaling;
		}
		
		public function getSizeY(): int {
			return Map.map.mapHeight * scaling;
		}

	}
}