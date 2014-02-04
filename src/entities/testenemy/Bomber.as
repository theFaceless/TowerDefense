package entities.testenemy 
{
	import entities.map.Map;
	import entities.towers.Tower;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.pathfinding.Collection;
	
	import utils.pathfinding.Path;
	import utils.Player;
	import utils.pathfinding.Pathfinding;
	import utils.Player;
	
	import entities.GroundTile;
	
	import entities.castle.BasicCastle;
	import entities.spawners.BasicSpawner;
	
	/**
	 * ...
	 * @author Axel Faes
	 */
	public class Bomber extends EnemyTemplate
	{
		
		public function Bomber(map:Map,xBegin:int, yBegin:int, xEnd:int, yEnd:int) 
		{
			var collec:Collection = new Collection();
			collec.random = 20;
			collec.towerTile = 50
			var p:Path = Pathfinding.pathDijkstra(map.getGroundTile(xBegin, yBegin), map.getGroundTile(xEnd,yEnd), collec);
			super(50, Assets.TestEnemy, map, xBegin, yBegin, xEnd, yEnd, p);
			
			this.collec = collec;
		}
		
	}

}