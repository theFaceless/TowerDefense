package entities 
{
	import entities.map.Map;
	import entities.towers.TowerTemplate;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class GridOverlay extends Entity 
	{
		public var image : Image;
		
		public function GridOverlay() 
		{
		}
		
		override public function added():void 
		{
			x = 0;
			y = 0;
			image = Image.createRect(Map.map.mapWidth * References.TILESIZE, Map.map.mapHeight * References.TILESIZE, 0xFFFFFF, 0.0);
			
		}
		
		public function refresh():void
		{			
			//we clear the old map
			image._bitmap.bitmapData.fillRect(new Rectangle(0, 0, Map.map.mapWidth * References.TILESIZE, Map.map.mapHeight * References.TILESIZE), 0x00000000);
			
			for each (var t1 : TowerTemplate in Map.map.buildingList) {
				for each (var t2 : TowerTemplate in Map.map.buildingList) {
					if (t1 != t2 && t1.isBuidlingInRange(t2)) {
						Draw.linePlusCustom(image._bitmap.bitmapData,
						t1.x + FP.camera.x + (t1.tileWidth-1) * References.TILESIZE/2,
						t1.y + FP.camera.y + (t1.tileHeight-1) * References.TILESIZE/2,
						t2.x + FP.camera.x + (t2.tileWidth-1) * References.TILESIZE/2,
						t2.y + FP.camera.y + (t2.tileHeight-1) * References.TILESIZE/2,
						(t2.isConnectedToPower ? 0x33FF33 : 0xFF3333), //color, red when not connected, green if connected
						0.6, 5);
						//Draw.linePlusCustom(image._bitmap.bitmapData, t1.x, t1.y, t2.x, t2.y, 0, 1.0, 1);
					}
				}
			}
			this.graphic = image;
		}
		
		override public function update():void 
		{
			super.update();
		}
		
	}

}