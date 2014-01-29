package entities.towers 
{
	import entities.GroundTile;
	import entities.map.Map;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class TowerTemplate extends GroundTile 
	{
		
		public var powerRange : Number = 200;
		
		public function TowerTemplate(map : Map, x : int, y : int, height : int, tileWidth : int = 1, tileHeight : int = 1 )  
		{
			super(map, x, y, height, tileWidth , tileHeight);
		}
		
	}

}