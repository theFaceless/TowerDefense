package entities 
{
	import entities.map.Map;
	import entities.towers.TowerTemplate;
	import flash.display.BlendMode;
	import flash.events.KeyboardEvent;
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
			this.layer = References.GRIDLAYER;
		}
		
		public function drawLine(t1 : TowerTemplate, t2 : TowerTemplate):void
		{
			Draw.linePlusCustom(image._bitmap.bitmapData,
			t1.x + FP.camera.x + (t1.tileWidth-1) * References.TILESIZE/2,
			t1.y + FP.camera.y + (t1.tileHeight-1) * References.TILESIZE/2,
			t2.x + FP.camera.x + (t2.tileWidth-1) * References.TILESIZE/2,
			t2.y + FP.camera.y + (t2.tileHeight-1) * References.TILESIZE/2,
			(t2.isConnectedToPower ? 0xFFF31A : 0x992222), //color, red when not connected, green if connected
			0.6, 2.5);
			this.graphic = image;
		}
		
		public function clearImage():void
		{
			image._bitmap.bitmapData.fillRect(new Rectangle(0, 0, Map.map.mapWidth * References.TILESIZE, Map.map.mapHeight * References.TILESIZE), 0x00000000);
			this.graphic = image;
		}
		
		public function refresh():void
		{			
			/*//we clear the old map
			image._bitmap.bitmapData.fillRect(new Rectangle(0, 0, Map.map.mapWidth * References.TILESIZE, Map.map.mapHeight * References.TILESIZE), 0x00000000);
			
			for each (var t1 : TowerTemplate in Map.map.buildingList) {
				var closestPower : TowerTemplate = null;
				var closestNoPower : TowerTemplate = null;
				
				for each (var t2 : TowerTemplate in Map.map.buildingList) {
					//first make sure we aren't targetting ourselves
					if (t1 != t2) {
						//if this tower is connected
						if (t2.isConnectedToPower && t1.isBuidlingInRange(t2)) {
							//if we have no tower yet this tomer becomes closesttower
							if (closestPower == null) closestPower = t2;
							//else if this tower is closer we make this closestpower
							else if (FP.distance(t1.x, t1.y, t2.x, t2.y) < FP.distance(t1.x, t1.y, closestPower.x, closestPower.y)) {
								closestPower = t2;
							}
						} else if (t1.isBuidlingInRange(t2)) {
							if (closestNoPower == null) closestNoPower = t2;
							else if (FP.distance(t1.x, t1.y, t2.x, t2.y) < FP.distance(t1.x, t1.y, closestNoPower.x, closestNoPower.y)) {
								closestNoPower = t2;
							}
						}
					}
				}
				
				if (closestPower) {
					trace("drawing closest tower");
					Draw.linePlusCustom(image._bitmap.bitmapData,
					t1.x + FP.camera.x + (t1.tileWidth-1) * References.TILESIZE/2,
					t1.y + FP.camera.y + (t1.tileHeight-1) * References.TILESIZE/2,
					closestPower.x + FP.camera.x + (closestPower.tileWidth-1) * References.TILESIZE/2,
					closestPower.y + FP.camera.y + (closestPower.tileHeight-1) * References.TILESIZE/2,
					(closestPower.isConnectedToPower ? 0xFFF31A : 0x992222), //color, red when not connected, green if connected
					0.6, 2.5);
				} else if (closestNoPower) {
					Draw.linePlusCustom(image._bitmap.bitmapData,
					t1.x + FP.camera.x + (t1.tileWidth-1) * References.TILESIZE/2,
					t1.y + FP.camera.y + (t1.tileHeight-1) * References.TILESIZE/2,
					closestNoPower.x + FP.camera.x + (closestNoPower.tileWidth-1) * References.TILESIZE/2,
					closestNoPower.y + FP.camera.y + (closestNoPower.tileHeight-1) * References.TILESIZE/2,
					(closestNoPower.isConnectedToPower ? 0xFFF31A : 0x992222), //color, red when not connected, green if connected
					0.6, 2.5);
				}
				
			}
			this.graphic = image;*/
		}
		
	}

}