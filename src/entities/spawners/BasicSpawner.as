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
		private var intervalEnemies:Number;
		private var intervalWave:Number;
		private var intervalCounter:Number = 0;
		
		private var xEnd:int, yEnd:int;
		
		private var image:Image;
		
		private var isPath:Boolean;
		private var path:Path;
		
		private var started:Boolean = false;
		
		private var waveQueue: Vector.<Vector.<spawnBluePrint>> = new Vector.<Vector.<spawnBluePrint>>;
		private var currentWave:int = 0;
		
		public function BasicSpawner(map : Map, x : int = 0, y : int = 0, groundHeight : int = 0, interval:Number = 1) 
		{
			super(map, x, y, groundHeight);
			
			this.interval = interval;
			this.intervalEnemies = interval;
			this.intervalWave = 3 * interval;
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
		
		/**
		 * spawns an enemy
		 */
		public function spawn():void {
			this.intervalCounter = 0;
			
			spawnWave();
		}
		
		/**
		 * spawns an enemy from the queue
		 */
		public function spawnWave():void {
			if (waveQueue.length > currentWave) {
				if (waveQueue[currentWave].length > 0) {
					
					
					var blueprint: spawnBluePrint = waveQueue[currentWave].pop();
					if (isPath) {
						var p:Path = new Path();
						p.path = path.path;
						
						var enemy:EnemyTemplate = getEnemyType(blueprint.type, p);
						enemy.level = blueprint.level;
						FP.world.add(enemy);
					}
					
					this.interval = this.intervalEnemies;
				}
				else {
					currentWave ++;
					this.interval = this.intervalWave;
				}
			}
		}
		
		/**
		 * prototype of a function that adds enemies to the map.
		 * Enemies need to spawn in the order they are added with this function (apart from the wave difference)
		 * @param	type	the type of the enemy
		 * @param	amount	the amount of enemies
		 * @param	level	the level of the enemy
		 * @param	wave	the wave it will spawn in
		 */
		public function addEnemies(type : String, amount : int, level : int, wave : int): void {
			if (waveQueue.length <= wave) {
				waveQueue.push(new Vector.<spawnBluePrint>());
			}
			
			for (var i:int = 0; i < amount; i++) {
				var blueprint: spawnBluePrint = new spawnBluePrint(type, level);
				(waveQueue[wave]).push(blueprint);
			}
		}
		
		/**
		 * return an enemy of the specified type
		 * @param	type, the type of the enemy
		 * @param	p, the path he has to follow
		 * @return the enemy
		 */
		public function getEnemyType(type:String, p:Path) : EnemyTemplate {
			return (new FirstEnemy(map, p, gridX , gridY, xEnd, yEnd));
		}
		
		/**
		 * changes the target of this specific spawner
		 */
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