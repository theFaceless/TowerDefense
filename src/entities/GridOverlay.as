package entities 
{
	import entities.map.Map;
	import entities.towers.TowerTemplate;
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
		}
		
		public function refresh():void
		{
			//we fetch all the towers that exist
			var towerList : Vector.<TowerTemplate>;
			towerList = new Vector.<TowerTemplate>();
			
			world.getClass(TowerTemplate, towerList);
			
			image = Image.createRect(Map.map.mapWidth * References.TILESIZE, Map.map.mapHeight * References.TILESIZE, 0xFFFFFF, 0.0);
			
			trace("x ", FP.camera.x, " y ", FP.camera.y);
			for each (var t1 : TowerTemplate in towerList) {
				for each (var t2 : TowerTemplate in towerList) {
					if (t1 != t2 && t1.isBuidlingInRange(t2)) {
						Draw.linePlusCustom(image._bitmap.bitmapData,
						t1.x + FP.camera.x + (t1.tileWidth-1) * References.TILESIZE/2,
						t1.y + FP.camera.y + (t1.tileHeight-1) * References.TILESIZE/2,
						t2.x + FP.camera.x + (t2.tileWidth-1) * References.TILESIZE/2,
						t2.y + FP.camera.y + (t2.tileHeight-1) * References.TILESIZE/2,
						0x333333, 0.6, 1);
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