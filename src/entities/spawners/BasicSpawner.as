package entities.spawners 
{
	import entities.testenemy.EnemyTemplate;
	import entities.testenemy.FirstEnemy;
	import net.flashpunk.Entity;
	import entities.map.Map;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.pathfinding.Collection;
	
	import utils.pathfinding.Path;
	import utils.pathfinding.Pathfinding;

	import entities.GroundTile;
		
	import entities.castle.BasicCastle;
		
	/**
	 * ...
	 * @author Axel Faes
	 */
	public class BasicSpawner extends GroundTile
	{
		private var interval:Number;
		private var intervalCounter:Number = 0;
		
		private var xEnd:int, yEnd:int;
		
		private var image:Image;
		
		private var isPath:Boolean;
		private var path:Path;
		
		private var started:Boolean = false;
		
		public function BasicSpawner(map : Map, x : int = 0, y : int = 0, groundHeight : int = 0, interval:Number = 1) 
		{
			super(map, x, y, groundHeight);
			
			this.interval = interval;
			passable = false;
			placeable = false;
		}
		
		
		/**
		 * checks if endposition is the given x and y
		 */
		public function hasEndLoc(x:int, y:int):Boolean {
			return (x == xEnd && y == yEnd);
		}
		
		
		override public function added():void {
			super.added();
			this.image = new Image(Assets.SPAWNER);
			image.centerOrigin();
			addGraphic(image);
		}
		
		override public function update():void {
			if (!started) {
				changeTarget();
				isPath = updatePath();
				started = true;
			}
			
			this.intervalCounter += FP.elapsed;
			
			if (this.intervalCounter >= this.interval) {
				spawn();
			}
		}
		
		public function spawn():void {
			this.intervalCounter = 0;

			if (isPath) {
				var p:Path = new Path();
				p.path = path.path;
				
				var enemy:EnemyTemplate = new FirstEnemy(map, p, gridX , gridY,xEnd, yEnd);
				FP.world.add(enemy);
			}
		}
		
		public function changeTarget():void {
			var enemyList : Array = new Array();
			// Then, we populate the array with all existing Enemy objects!
			FP.world.getClass(BasicCastle, enemyList);
			// Finally, we can loop through the array and call each Enemy's die() function.
			var closest:BasicCastle;
			var changed:Boolean = false;
			var dis:int = 0;
			
			for each (var enemy:BasicCastle in enemyList) {
				if (!enemy.destroyed ) {
					if (!changed) {
						closest = enemy;
						dis = Math.abs(this.gridX - closest.gridX) + Math.abs(this.gridY - closest.gridY)
						changed = true;
					}
					else if (dis >= Math.abs(this.gridX-enemy.gridX) + Math.abs(this.gridY-enemy.gridY)) {
						changed = true;
						dis = Math.abs(this.gridX - enemy.gridX) + Math.abs(this.gridY - enemy.gridY);
						closest = enemy;
					}
				}
			}
			
			if (changed) {
				xEnd = closest.gridX;
				yEnd = closest.gridY;
			}
		}
		
		/**
		 * check if a object is over the path
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function checkPath(x:int, y:int):Boolean {
			return path.containsPoint(x, y);
		}
		
		public function updatePath():Boolean {
			var status:Boolean = false;
			
			var collec:Collection = new Collection();
			var p:Path = Pathfinding.pathDijkstra(map.getGroundTile(this.gridX, this.gridY), map.getGroundTile(xEnd,yEnd), collec);
			
			if (p) {
				path = p;
				status = true;
			}
			
			isPath = status;
			return status;
		}
		
	}

}