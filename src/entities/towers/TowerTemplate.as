package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class TowerTemplate extends GroundTile 
	{
		
		public var powerRange : Number = 200;
		public var isPowerSource : Boolean = false;
		public var isConnectedToPower : Boolean = false;
		
		public function TowerTemplate(map : Map, x : int, y : int, height : int, tileWidth : int = 1, tileHeight : int = 1 )  
		{
			super(map, x, y, height, tileWidth , tileHeight);
		}
		
		override public function added():void 
		{
			super.added();
			Map.map.refreshPowerGrid();
		}
		
		/**
		 * refreshes this towers power status
		 */
		public function updatePowerConnectedRec():void
		{
			if (isConnectedToPower == true) return;
			isConnectedToPower = true;
			
			for each (var t : TowerTemplate in map.buildingList) {
				if (isBuidlingInRange(t)) {
					t.updatePowerConnectedRec();
				}
			}
		}
		
		/**
		 * returns true if the given building is in powerrange of this building
		 */
		public function isBuidlingInRange(building : TowerTemplate) : Boolean {
			//_____________________BEST LINE CODE OF THE WHOLE PROJECT_____________________
			return FP.distance(x, y, building.x, building.y) <= (powerRange >= building.powerRange ? powerRange : building.powerRange);
		}
		
		/**
		 * returns true if the given coordinate is in powerrange of this building
		 */
		public function isCoordinateInRange(xpos : int, ypos : int) : Boolean {
			return FP.distance(x, y, xpos, ypos) <= powerRange;
		}
		
		override public function render():void 
		{
			super.render();
		}
		
	}

}