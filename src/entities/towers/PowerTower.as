package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class PowerTower extends GroundTile 
	{
		
		public function PowerTower(map : Map, x : int, y : int, height : int )
		{
			super(map, x, y, height, 1 , 1);
		}
		
	}

}