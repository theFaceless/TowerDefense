package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class PowerTower extends Tower
	{
		
		public function PowerTower(map : Map, x : int, y : int, height : int )
		{
			super(Map.map, x, y, height);
		}
		
		
		override public function getUpgrades(): Array {
			return upgradeList;
		}
		
	}

}