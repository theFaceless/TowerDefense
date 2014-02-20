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
	 * Basic template for any enemy
	 * @author Axel Faes
	 */
	public class EnemyTemplate extends Entity
	{
		/**the graphic of the enemy*/
		public var image : Image;
		/**the speed of the enemy*/
		public var speed : int;
		/**the health of the enemy*/
		public var health : Number = 100;
		/**
		 * the direction the enemy is facing*/
		/* 0 = right
		 * 1 = up (on map)
		 * 2 = left
		 * 3 = down (on map)
		 * 5 = stopped moving
		 * 6 = idle
		 */
		private var facing : int = 6;
		/**the angle the enemy is facing*/
		public var angle : Number = 180 * FP.RAD;
		
		/**a reference to the global map*/
		private var map:Map;
		
		/**the x and y position of the enemy in the grid*/
		private var xmap : int;
		private var ymap : int;
		
		/**the current path the enemy is following*/
		private var path:Path;
		
		/**
		 * holds the endposition of the enemy
		 */
		private var endloc:Vector.<int>;
		/**
		 * checks how many pixels the enemy has moved*/
		private var tileMoved:Number = 0;
		
		/**the damage factor
		 * the amount of money the player gets from this enemy
		 * checks whether enemy is moving or not
		 * */
		protected var damage:Number = 50;
		protected var money:Number = 20;
		protected var moving:Boolean = true;
		
		/**checks whether the path needs to be changed*/
		protected var pathchanged:Boolean = false;
		private var newpath:Path;
		
		/**the level of this enemy*/
		public var level:int = 1;
		
		/**collection of attributes used for pathfinding*/
		public var collec:Collection = new Collection();
		
		/**the age of this enemy*/
		public var age:Number = 0;
		
		public function EnemyTemplate(sp:int, img:Class, map:Map,xBegin:int, yBegin:int, xEnd:int, yEnd:int, p:Path) {
			set_speed(sp);
			set_image(img);
			
			set_size(1, 1);
			
			this.map = map;
			//sets the end loc
			setEndLoc(xEnd, yEnd);
			//set the begin loc
			set_position(xBegin, yBegin);
			
			path = p;
		}
		
		override public function added():void {
			this.layer = References.ENEMYLAYER;

			usePath();	
		}
		
		/**
		 * calculate a path
		 */
		public function calcPath(x:int, y:int):Boolean {
			var status:Boolean = false;
		
			var p:Path = Pathfinding.pathDijkstra(map.getGroundTile(path.getNextX(), path.getNextY()), map.getGroundTile(x,y), collec);
			
			if (p) {
				newpath = p;
				status = true;
				pathchanged = true;
			}
			else {
				facing = 6;
			}
			
			return status;
		}
		
		/**
		 * update the character
		 */
		override public function update():void {
			move();
			updateAnimation();
		}
		
		/**
		 * updates the animation
		 */
		public function updateAnimation():void {
			age += FP.elapsed;
			image.angle = Math.sin(age*9)*7.5;
		}
		
		/**
		 * change the path we are using
		 */
		public function usePath():void {
			//change facing
			facing = path.getDirection(this.xmap, this.ymap);
		}
		
		/**
		 * move the character
		 */
		protected function move():void {
			setFacing();
			if (facing != 5 && moving) {
				var dx:Number = (this.speed * (Math.cos(this.angle))) * FP.elapsed;
				var dy:Number = (this.speed * (Math.sin(this.angle))) * FP.elapsed;
				this.x += dx;
				this.y += dy;
				tileMoved += (dx + dy);
			}
			else if (moving) {
				attack();
			}
			checkAttackTower();
			inTileRange();
		}
		
		/**
		 * calculates the damage todo
		 */
		public function getDamage():Number {
			return damage * (level+1);
		}
		
		/**
		 * check whether the enemy needs to attack the players towers
		 * if it is: do damage and if 
		 */
		public function checkAttackTower():void {
			var tile:GroundTile = map.getGroundTile(this.xmap, this.ymap);
			if (tile is Tower) {
				if (!(Tower (tile)).isDestroyed) {
					
					(Tower (tile)).giveDamage((Tower (tile)).towerHealth);
					
					this.health -= getDamage();	
					if (isDead()) {
						FP.world.remove(this);
					}
					
					if ((Tower (tile)).isDestroyed) {
						tile.passable = true;
						tile.placeable = true;
					
					
						//change pathfinding
						var enemy2: EnemyTemplate;
						for (var i:int = Map.map.enemyList.length - 1; i >= 0; i--) {
							enemy2 = Map.map.enemyList[i];
							if (!enemy2.isDead() && enemy2.checkPath(this.xmap, this.ymap)) {
								Map.map.addEnemyToQueue(enemy2);
							}
						}
					}
				}
			}
		}
		
		/**
		 * change the target location of this enemy to the closest castle
		 */
		public function changeTarget():void {
			var closest:BasicCastle;
			var changed:Boolean = false;
			var dis:int = 0;

			var enemy: BasicCastle;
			for (var i:int = Map.map.castleList.length - 1; i >= 0; i--) {
				enemy = Map.map.castleList[i];
				if (!enemy.destroyed ) {
					if (!changed) {
						closest = enemy;
						dis = Math.abs(this.xmap - closest.gridX) + Math.abs(this.ymap - closest.gridY)
						changed = true;
					}
					else if (dis >= Math.abs(this.xmap-enemy.gridX) + Math.abs(this.ymap-enemy.gridY)) {
						changed = true;
						dis = Math.abs(this.xmap - enemy.gridX) + Math.abs(this.ymap - enemy.gridY);
						closest = enemy;
					}
				}
			}
			if (changed) {
				setEndLoc(closest.gridX, closest.gridY);
			}
		}
		
		/**
		 * attack the player castle
		 * and if it is, update all the paths of enemies and spawners that have a
		 * path to this castle
		 */
		private function attack():void {
			var enemy: BasicCastle;
			for (var i:int = Map.map.castleList.length - 1; i >= 0; i--) {
				enemy = Map.map.castleList[i];
				if (enemy.contains(this.xmap, this.ymap)) {
					enemy.takeDamage(this.damage);
					break;
				}
				
			}
			
			this.health = -1;
			
			if (enemy.destroyed) {
				var enemy2: EnemyTemplate;
				for (i = Map.map.enemyList.length - 1; i >= 0; i--) {
					enemy2 = Map.map.enemyList[i];
					if (!enemy2.isDead() && enemy2.hasEndLoc(this.xmap, this.ymap)) {
						enemy2.changeTarget();
						Map.map.addEnemyToQueue(enemy2);
					}
				}
				/*
				var enemy3: BasicSpawner;
				for (i = Map.map.spawnerList.length - 1; i >= 0; i--) {
					enemy3 = Map.map.spawnerList[i];
					if (enemy3.hasEndLoc(this.xmap, this.ymap)) {
						enemy3.changeTarget();
						Map.map.addSpawnerToQueue(enemy3);
					}
				}
				*/
			}
			
			FP.world.remove(this);
		}
		
		/**
		 * checks if endposition is the given x and y
		 */
		public function hasEndLoc(x:int, y:int):Boolean {
			return (x == endloc[0] && y == endloc[1]);
		}
		
		/**
		 * 
		 * check if the pathlocation needs to be updated
		 * 
		 */
		private function inTileRange():void {
			if (Math.abs(tileMoved) >= References.TILESIZE) {
				tileMoved = 0;
				
				/**
				 * get the current location from the path 
				 */
				xmap = path.getNextX();
				ymap = path.getNextY();
				
				/**
				 * reset the x position and y-position
				 */
				this.x = References.TILESIZE * xmap + References.TILESIZE / 2;
				this.y = References.TILESIZE * ymap + References.TILESIZE / 2;
				
				if (pathchanged) {
					path = newpath;
					pathchanged = false;
				}
				
				/**
				 * get the next direction to move to
				 */
				usePath();
			}
		}
		
		/**
		 * let the enemy take damage
		 * @param	dam
		 */
		public function takeDamage(dam:Number):void {
			this.health -= dam;
			
			if (this.health <= 0) {
				Map.map.currentPlayer.addMoney(this.money);
				Map.map.updateMoney();
				FP.world.remove(this);
			}
		}
		
		/**
		 * check if the enemy is dead
		 * @return boolean that checks whether enemy is dead
		 */
		public function isDead(): Boolean {			
			if (this.health <= 0)
				return true;
			else
				return false;
		}
		
		/**
		 * select the facing direction
		 */
		private function setFacing():void {
			switch (facing) {
				case 0:
					this.angle = 0;
					break;
				case 1:
					this.angle = 90 * FP.RAD;
					break;
				case 2:
					this.angle = 180 * FP.RAD;
					break;
				case 3:
					this.angle = 270 * FP.RAD;
					break;
			}
			image.angle = this.angle;
		}
		
		/**
		 * set the original position of the enemy
		 * @param	x
		 * @param	y
		 */
		public function set_position(x:int, y:int):void {
			//swapped
			this.x = References.TILESIZE * x + References.TILESIZE / 2;
			this.y = References.TILESIZE * y + References.TILESIZE / 2;
			this.xmap = x;
			this.ymap = y;
		}
		
		/**
		 * set the enemy size
		 * @param	w
		 * @param	h
		 */
		public function set_size(w:int, h:int):void {
			this.width = References.TILESIZE * w;
			this.height = References.TILESIZE * h;
			resetImg();
		}
		
		/**
		 * check if a object is over the path
		 * @param	x
		 * @param	y
		 * @return true if the x,y is in path
		 */
		public function checkPath(x:int, y:int):Boolean {
			return path.containsPoint(x, y);
		}
		
		/**
		 * get the number of tiles still needed to be done
		 */
		public function getLength():int {
			return path.getLength();
		}
		
		/**
		 * set the speed of the enemy
		 * @param	sp
		 */
		public function set_speed(sp:int):void {
			this.speed = sp;
		}
		
		/**
		 * set the image for the enemy class
		 * @param	img
		 */
		public function set_image(img:Class):void {
			this.image = new Image(img);
			resetImg();
			this.image.smooth = true;
			this.graphic = image;
		}
		
		/**
		 * set the image size
		 */
		private function resetImg():void {
			this.image.centerOrigin();
			set_imgSize(2 / 3);
		}
		
		/**
		 * update the path
		 */
		public function updatePath():Boolean {
			moving = true;
			return calcPath(endloc[0], endloc[1]);
		}
		
		/**
		 * set the ending location of this monster
		 * @param	x
		 * @param	y
		 */
		public function setEndLoc(x:int, y:int):void {
			endloc = new Vector.<int>();
			endloc.push(x);
			endloc.push(y);
		}
		
		/**
		 * set the image size
		 * @param	nb
		 */
		public function set_imgSize(nb:Number):void {
			this.image.scaledWidth = nb * width;
			this.image.scaledHeight = nb * height;
		}
		
		/**
		 * stops the enemy from moving
		 */
		public function stopEnemy():void {
			moving = false;
		}
	}

}