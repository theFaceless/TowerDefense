package entities.spawners 
{
	import entities.testenemy.Bomber;
	import entities.testenemy.EnemyTemplate;
	import entities.testenemy.FirstEnemy;
	import entities.testenemy.Goblin;
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
		private var intervalW:Number = 0;
		private var intervalCounter:Number = 0;
		private var intervalWave:Number;
		
		
		private var xEnd:int, yEnd:int;
		
		private var image:Image;
		
		private var isPath:Boolean;
		private var path:Path;
		
		private var started:Boolean = false;
		
		private var waveQueue: Vector.<Vector.<spawnBluePrint>> = new Vector.<Vector.<spawnBluePrint>>;
		private var currentWave:int = 0;
		private var maxWave:int = 0;
		
		public function BasicSpawner(map : Map, x : int = 0, y : int = 0, groundHeight : int = 0, interval:Number = 1, maxinterval:Number = 3,  maxwave:int = 0) 
		{
			super(map, x, y, groundHeight);
			
			this.interval = interval;
			this.intervalWave = maxinterval;
			
			for (var i:int = 0; i < maxwave; i++) {
				waveQueue.push(new Vector.<spawnBluePrint>());
			}
			
			maxWave = maxwave;
			
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
				//isPath = updatePath();
				started = true;
			}


			intervalW += FP.elapsed;
			this.intervalCounter += FP.elapsed;
			
			if (this.intervalCounter >= this.interval) {
				spawn();
			}
			
			if (this.intervalW >= this.intervalWave) {
				if (waveQueue.length >= currentWave) {
					if (waveQueue[currentWave].length == 0 && currentWave < maxWave) {
						this.intervalW = 0;
						currentWave ++;
					}
				}
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
					var enemy:EnemyTemplate = getEnemyType(blueprint.type);
					if (enemy) {
						enemy.level = blueprint.level;
						FP.world.add(enemy);
					}
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
		public function getEnemyType(type:String) : EnemyTemplate {
			var enemy:EnemyTemplate;
			switch (type) {
				case "goblin":
					enemy = new Goblin(map, gridX , gridY, xEnd, yEnd);
					break;
				case "bomber":
					enemy = new Bomber(map, gridX, gridY, xEnd, yEnd);
			}
			return enemy;
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
	}

}