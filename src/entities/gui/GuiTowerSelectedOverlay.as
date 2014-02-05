package entities.gui 
{
	import entities.towers.Tower;
	import flash.display.GraphicsSolidFill;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import entities.map.Map;
	import net.flashpunk.utils.Key;
	
	/**
	 * overlay when a tower is selected
	 * @author Wout Coenen
	 */
	public class GuiTowerSelectedOverlay extends Entity {
    
		private var sizeX: int;
		private var sizeY: int;
		private var image : Image;
		private var tileX: int;
		private var tileY: int;
		private var clicked: Boolean;
		private var clickedBackup: Boolean;
		private var rangeCircle: Image;
		private var wasVisible: Boolean;
		
		public function GuiTowerSelectedOverlay() {
			super();
			clicked = false;
			clickedBackup = false;
		}
		
		override public function added() : void {
			image = new Image(Assets.GUIADDTOWEROVERLAY);
			addGraphic(image);
			layer = References.GUILAYER + 1;
			sizeX = image.height;
			sizeY = image.width;
			image.alpha = 0.4;
			image.color = 0xDDDDDD;
			image.centerOrigin();
			x = (Input.mouseX + FP.camera.x) - (Input.mouseX + FP.camera.x) % References.TILESIZE + 20;
			y = (Input.mouseY + FP.camera.y) - (Input.mouseY + FP.camera.y) % References.TILESIZE + 20;
			image.visible = false;
			
			tileX = (Input.mouseX + FP.camera.x) / References.TILESIZE;
			tileY = (Input.mouseY + FP.camera.y) / References.TILESIZE;
		}
    
		override public function update() : void {
			
			//check if mouse is on field or not
			if(Gui.mapCanGetInput()){
				tileX = (Input.mouseX + FP.camera.x) / References.TILESIZE;
				tileY = (Input.mouseY + FP.camera.y) / References.TILESIZE;
				
				if (Input.mousePressed){
					clicked = true;
					clickedBackup = true;
				}
				
				image.visible = Map.map.getGroundTile(tileX, tileY) is Tower;
				if (image.visible) {
					
					if (!wasVisible) {
						rangeCircle = Image.createCircle(Tower(Map.map.getGroundTile(tileX, tileY)).towerRange, 0xDDDDDD, 0.2);
						rangeCircle.centerOrigin();
						addGraphic(rangeCircle);
					}
				
					x = (Input.mouseX + FP.camera.x) - (Input.mouseX + FP.camera.x) % References.TILESIZE + 20;
					y = (Input.mouseY + FP.camera.y) - (Input.mouseY + FP.camera.y) % References.TILESIZE + 20;
					if (clicked && Input.mouseReleased) {
						clicked == false;
						Gui.eventHandler("TowerSelected");
					}
					
					wasVisible = true;
				}	
				else if (wasVisible) {
					wasVisible = false;
					(this.graphic as Graphiclist).remove(rangeCircle);
				}
				if (!image.visible && ((Input.mouseReleased && clickedBackup) || (Input.check(Key.ESCAPE)))) {
					Gui.eventHandler("TowerDeselected");
				}
			}
			else if (wasVisible) {
				wasVisible = false;
				(this.graphic as Graphiclist).remove(rangeCircle);
				image.visible = false;
			}
		}
    
		public function doNotSelectNextFrame(): void {
			clicked = false;
			clickedBackup = false;
			Gui.eventHandler("TowerDeselected");
		}
	}
}