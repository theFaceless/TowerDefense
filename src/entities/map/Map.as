package entities.map 
{
	import entities.castle.BasicCastle;
	import entities.GridOverlay;
	import entities.GroundTile;
	import entities.gui.GuilDialogue;
	import entities.mapmenu.LevelSelectMap;
	import entities.spawners.BasicSpawner;
	import entities.testenemy.EnemyTemplate;
	import entities.towers.BasicTower;
	import entities.towers.Tower;
	import entities.towers.TowerTemplate;
	import entities.towers.TripleShotTower;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.DialogueManager;
	import utils.Player;
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class Map extends Entity
	{
		public static var map : Map;
		//this vector contains all the groundtiles	
		public var mapData : Vector.<GroundTile>;
		//the width of the map
		public var mapWidth : int = 0;
		//the height of the map
		public var mapHeight : int = 0;
		//a list of all the enemies, update once every frame
		public var enemyList : Vector.<EnemyTemplate> = new Vector.<EnemyTemplate>;
		//a list of all the spawners, update once every frame
		public var spawnerList: Vector.<BasicSpawner> = new Vector.<BasicSpawner>;
		//a list of all the castles, update once every frame
		public var castleList: Vector.<BasicCastle> = new Vector.<BasicCastle>;
		//a list of all the buildings, update once every frame
		public var buildingList : Vector.<TowerTemplate> = new Vector.<TowerTemplate>;
		//the overly that shows the grid
		public var gridOverlay : GridOverlay;
		//Player
		public var player: Player = new Player();
		
		//the level that will be loaded
		private var level : Class;
		
		//whether or not we are in a dialogue, if so, don't do frigging anything!
		public var isInDialogue : Boolean = false;
		
		//the dialogueManager, this controls all the gui flow in a game
		private var dialogueManager : DialogueManager;
		
		//the dialogue of the current map
		public var dialogue : Class;
		
		public function Map(level : Class, dialogue : Class)
		{
			map = this;
			this.level = level;
			this.dialogue = dialogue;			
		}
		
		override public function added():void 
		{
			name = "map";
			gridOverlay = new GridOverlay();
			world.add(gridOverlay);
			initializeMap();
			
			dialogueManager = new DialogueManager(dialogue);
			
			//world.add(new GuilDialogue(null, "We have breaking news! Modern social-economic studies have proven that Axel Faes is indeed, very, very gay.", "CNN", new Image(Assets.CNN), 0));
			
			/*
			//test code for spawner
			var tile : GroundTile = getGroundTile(4, 4);
			var spawner : BasicSpawner = new BasicSpawner(this, 4, 4, tile.groundHeight, 1, 19, 19);
			
			setGroundTile(4, 4, spawner);
			world.add(spawner);
			world.remove(tile);
			
			//test code for castle
			tile = getGroundTile(14, 16);
			var castle : BasicCastle = new BasicCastle(this, 14, 16, tile.groundHeight, 2000);
			
			replaceGroundTile(14, 16, castle);
			world.add(castle);*/
			
		}
		
		/**
		 * initializes the map
		 */
		public function initializeMap():void
		{
			parseMap(level);
			
			world.getClass(EnemyTemplate, enemyList);
			world.getClass(BasicSpawner, spawnerList);
			world.getClass(BasicCastle, castleList);
			world.getClass(TowerTemplate, buildingList);
		}
		
		public function parseMap(map : Class):void
		{
			
			//the xml file that is being parsed
			var xml : XML = FP.getXML(map);
			
			//we setup the width and height of the map
			this.mapWidth = parseInt(xml.@width) / 40;
			this.mapHeight = parseInt(xml.@height) / 40;
			
			//we make the spawnerlist, we need this one now to make the enemies
			spawnerList = new Vector.<BasicSpawner>;
			
			//we initialize the mapdata
			mapData = new Vector.<GroundTile>(mapWidth * mapHeight);		
			
			//for each tile in the xml file
			for each (var tile : XML in xml.MapData.tile) {
				//we get the x and y coordinates
				var tilex : int = parseInt(tile.@x);
				var tiley : int = parseInt(tile.@y);
				
				//we create a new groundtile
				var groundTile : GroundTile = new GroundTile(this, tilex, tiley, parseInt(tile.@id));
				
				//and put them in the array
				mapData[tilex + tiley * mapWidth] = groundTile;	
			}
			
			//we add the rubble
			for each (var rubble : XML in xml.Objects.Rubble) {
				tilex = parseInt(rubble.@x) / 40;
				tiley = parseInt(rubble.@y) / 40;
				var oldtile : GroundTile = getGroundTile(tilex, tiley);
				var rubbletile : Rubble = new Rubble(this, tilex, tiley, oldtile.groundHeight);
				replaceGroundTile(tilex, tiley, rubbletile);
			}
			
			//we add the spawners
			for each (var spawner : XML in xml.Objects.Spawner) {
				tilex = parseInt(spawner.@x) / 40;
				tiley = parseInt(spawner.@y) / 40;
				oldtile = getGroundTile(tilex, tiley);
				var spawnertile : BasicSpawner = new BasicSpawner(this, tilex, tiley, oldtile.groundHeight, parseInt(spawner.@Interval));
				spawnerList.push(spawnertile);
				replaceGroundTile(tilex, tiley, spawnertile);
			}
			
			//we add the castle
			for each (var castle : XML in xml.Objects.Castle) {
				tilex = parseInt(castle.@x) / 40;
				tiley = parseInt(castle.@y) / 40;
				oldtile = getGroundTile(tilex, tiley);
				var castleTile : BasicCastle = new BasicCastle(this, tilex, tiley, oldtile.groundHeight, parseInt(castle.@Health));
				replaceGroundTile(tilex, tiley, castleTile);
			}
			
			for each (var enemy : XML in xml.Wave.Enemy) {
				spawnertile = spawnerList[parseInt(enemy.@spawner)];
				spawnertile.addEnemies(enemy.@type, parseInt(enemy.@amount), parseInt(enemy.@level), parseInt(enemy.@wave));
			}
			
			//now we add all maps to the world
			for (var i : int = 0 ; i < mapWidth * mapHeight ; i++) {
				FP.world.add(mapData[i] as Entity);
			}
			
		}
		
		override public function update():void 
		{
			super.update();
			enemyList = new Vector.<EnemyTemplate>();
			spawnerList = new Vector.<BasicSpawner>();
			castleList = new Vector.<BasicCastle>();
			buildingList = new Vector.<TowerTemplate>();
			
			world.getClass(EnemyTemplate, enemyList);
			world.getClass(BasicSpawner, spawnerList);
			world.getClass(BasicCastle, castleList);
			world.getClass(TowerTemplate, buildingList);
			
			
			//here we move the flashpunk camera
			
			if (Input.check(Key.RIGHT)) {
				FP.camera.x += References.SCROLLSPEED * FP.elapsed;
			}
			if (Input.check(Key.LEFT)) {
				FP.camera.x -= References.SCROLLSPEED * FP.elapsed;
			}
			if (Input.check(Key.UP)) {
				FP.camera.y -= References.SCROLLSPEED * FP.elapsed;
			}
			if (Input.check(Key.DOWN)) {
				FP.camera.y += References.SCROLLSPEED * FP.elapsed;
			}
			
			clampCamera();
			updateQueues();
			
		}
		
		//moves the camera so it is within the allowed boundaries
		public function clampCamera():void
		{
			if ( FP.camera.x > mapWidth * References.TILESIZE - 800 + 7) FP.camera.x = mapWidth * References.TILESIZE - 800 + 7;
			if (FP.camera.x < -7) FP.camera.x = -7;
			if (FP.camera.y < -7) FP.camera.y = -7;
			if ( FP.camera.y > mapHeight * References.TILESIZE - 600 + 64) FP.camera.y = mapHeight * References.TILESIZE - 600 + 64;
			
		}
		
		public function addTower(x : int, y : int):void
		{
				var tile : GroundTile = getGroundTile(x, y);
				
				var tempTower  : BasicTower = new BasicTower(this, x, y, tile.groundHeight);	
				
				//FP.world.remove(tile);
				
				FP.world.add(tempTower);
				
				replaceGroundTile(x, y, tempTower);
		}
		/**
		 * refreshes the powergrid of the map and all the towers
		 */
		public function refreshPowerGrid():void
		{
			world.getClass(TowerTemplate, buildingList);
			gridOverlay.clearImage();
			for each (var t : TowerTemplate in buildingList) {
				t.isConnectedToPower = false;
			}
			for each(t in buildingList) {
				if (t.isPowerSource) {
					t.updatePowerConnectedRec(null, true);
				}
			}
		}
		
		public function upgradeTower(oldTower : Tower, newTower : Tower):void 
		{	
			FP.world.remove(oldTower);
			FP.world.add(newTower);
			setGroundTile(oldTower.gridX, oldTower.gridY, newTower);
			
			
			
		}
		
		/**
		 * returns the groundtile at the given position
		 */
		public function getGroundTile(x : int, y : int):GroundTile
		{
			if (x < 0 || y < 0 || x >= mapWidth || y >= mapHeight) return null;
			return mapData[x + y * mapWidth];
		}
		
		//sets the groundtile on a position to a new groundtile
		public function setGroundTile(x : int, y : int, tile : GroundTile) : void
		{
			mapData[x + y * mapWidth] = tile;
		}
		
		//sets the groundtile on a position to a new groundtile and removes the old groundtile
		public function replaceGroundTile(x : int, y : int, tile : GroundTile) : void
		{
			for (var i : int = 0 ; i < tile.tileWidth ; i++) {
				for (var k : int = 0 ; k < tile.tileHeight ; k++) {
					FP.world.remove(mapData[(x + i) + (y +k) * mapWidth]);
					mapData[(x + i) + (y +k) * mapWidth] = tile;
				}
			}
		}
		
		/***********************************************************************************/
		/*****************PATH CHECKING CODE (Wout Coenen)**********************************/
		/***********************************************************************************/
		
		private var enemyQueue: Vector.<EnemyTemplate> = new Vector.<EnemyTemplate>;
		private var spawnerQueue: Vector.<BasicSpawner> = new Vector.<BasicSpawner>;
		
		public function addEnemyToQueue(enemy: EnemyTemplate): void {
			enemy.stopEnemy();
			enemyQueue.push(enemy);
			//we remove doubles in the queue
			var i:int;
			var j: int;
			for (i = 0; i < enemyQueue.length - 1; i++){
				for (j = i + 1; j < enemyQueue.length; j++){
					if (enemyQueue[i] === enemyQueue[j]){
						enemyQueue.splice(j, 1);
					}
				}
			}
		}
		public function addSpawnerToQueue(spawner: BasicSpawner): void {
			spawnerQueue.push(spawner);
			//we remove doubles in the queue
			var i:int;
			var j: int;
			for (i = 0; i < spawnerQueue.length - 1; i++){
				for (j = i + 1; j < spawnerQueue.length; j++){
					if (spawnerQueue[i] === spawnerQueue[j]){
						spawnerQueue.splice(j, 1);
					}
				}
			}
		}
		
		public function updateQueues(): void {
			
			//do {
				
				if (spawnerQueue.length > 0) {
					spawnerQueue[spawnerQueue.length - 1].updatePath();
					spawnerQueue.pop();
				}
				else if (enemyQueue.length > 0) {
					enemyQueue[enemyQueue.length - 1].updatePath();
					enemyQueue.pop();
				
				}
				
			//}while (FP.elapsed < 0.01);
			
		}
		
		public function placeTower(tileX: int, tileY: int): void {
			if (map.getGroundTile(tileX, tileY).placeable){
				addTower(tileX, tileY);
				for each (var enemy: EnemyTemplate in enemyList) {
					if (enemy.checkPath(tileX, tileY))
						addEnemyToQueue(enemy);
				}
				for each (var spawner: BasicSpawner in spawnerList) {
					if (spawner.checkPath(tileX, tileY))
						addSpawnerToQueue(spawner);
				}
			}
		}
		
	}

}