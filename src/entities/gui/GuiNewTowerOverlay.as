package entities.gui 
{
	import entities.towers.Tower;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import entities.map.Map;
	
	/**
	 * Selector for where to place a new tower
	 * @author Wout Coenen
	 */
	public class GuiNewTowerOverlay extends Entity {
    
		private var sizeX: int;
		private var sizeY: int;
		private var image : Image;
		private var eventFunction : Function;
		private var rangeIndicator: Image;
		
		public function GuiNewTowerOverlay(eventFunction : Function) {
			super();
			this.eventFunction = eventFunction;
		}
		
		override public function added() : void {
      
			image = new Image(Assets.GUIADDTOWEROVERLAY);
			sizeX = image.height;
			sizeY = image.width;
			image.alpha = 0.4;
			image.centerOrigin();
			x = (Input.mouseX + FP.camera.x) % References.TILESIZE + 20;
			y = (Input.mouseY + FP.camera.y) % References.TILESIZE + 20;
			layer = References.GUILAYER + 1;
			setHitbox( -(References.TILESIZE / 2), -(References.TILESIZE / 2), References.TILESIZE, References.TILESIZE);
			
			rangeIndicator = Image.createCircle((new Tower(Map.map, 0,0,0)).towerRange, 0xDDDDDD, 0.2);
			rangeIndicator.centerOrigin();
			
			addGraphic(image);
			addGraphic(rangeIndicator);
		}
    
		override public function update() : void {
      
			if (Gui.mapCanGetInput()) {
				image.visible = true;
				rangeIndicator.visible = true;
				x = (Input.mouseX + FP.camera.x) - ((Input.mouseX + FP.camera.x) % References.TILESIZE) + 20;
				y = (Input.mouseY + FP.camera.y) - ((Input.mouseY + FP.camera.y) % References.TILESIZE) + 20;
				var tileX: int = (Input.mouseX + FP.camera.x) / References.TILESIZE;
				var tileY: int = (Input.mouseY + FP.camera.y) / References.TILESIZE;
				var isPlaceable: Boolean = Map.map.getGroundTile(tileX, tileY).placeable;
				
				//change overlay color
				if (isPlaceable)
					image.color = 0x77FF77;
				else
					image.color = 0xFF7777;
				
				if (Input.mouseReleased) {
					eventFunction("AddTower");
				if (!isPlaceable)
					FP.world.remove(this);
				}
			}
			else {
				image.visible = false;
				rangeIndicator.visible = false;
			}
			
			if (Input.check(Key.ESCAPE))
			{
				FP.world.remove(this);
			}
		}
	}
}