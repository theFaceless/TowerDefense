package entities.gui 
{
	import entities.map.Map;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import entities.towers.BasicTower;
	import entities.testenemy.EnemyTemplate;
	import entities.spawners.BasicSpawner;
	
	/**
	 * main Gui-class, every other class has to call this one to interact with the GUI
	 * To add buttons to the small menu, make a new GuiButton...-class and edit the GuiSmall-class to add them to the screen
	 * @author Wout Coenen
	 */
	public class Gui
	{
		
		private static var funcP: Function = eventHandler;
		private static var useCustomCursor: Boolean = false;
		private static var debugEnabled: Boolean;
		private static var guiTowerSelectedOverlay:GuiTowerSelectedOverlay = new GuiTowerSelectedOverlay();
		
		/**
		 * Call this method to initiliaze the GUI
		 */
		public static function initWithMap(): void {
			
			//we add the minimap
			FP.world.add(new GuiMinimap());
			
			//initilize the cursor
			if (useCustomCursor)
			{
				FP.world.add(new CustomCursor());
			}
			
			FP.world.add(new GuiOverlay(eventHandler, 0, References.GUIBORDERSIZE, References.GUIBUTTONAREAHEIGHT));
			FP.world.add(guiTowerSelectedOverlay);
			
			FP.console.enable();
			FP.console.visible = false;
			debugEnabled = false;
			
		}
		
		/**
		 * triggered when a button has been clicked on the small menu
		 * @param	idString the String-identifier of the clicked button
		 */
		public static function eventHandler(idString: String): void
		{
			//DEBUG LINE
			trace (idString);
			
			if (idString == "GuiButtonAddTower")
			{
				FP.world.add(new GuiNewTowerOverlay(funcP));
			}
			else if (idString == "AddTower") {
				
				var tileX: int = (Input.mouseX + FP.camera.x) / References.TILESIZE;
				var tileY: int = (Input.mouseY + FP.camera.y) / References.TILESIZE;
				
				Map.map.placeTower(tileX, tileY);
				
				/*
				//when the the tile can be placed on
				if (Gui.map.getGroundTile(tileX, tileY).placeable) {
										
					var pathsExistFromSpawner:Boolean = true;
					var pathsExistFromEntity: Boolean = true;
					var newPathsExistFromSpawner:Boolean = true;
					var newPathsExistFromEntity: Boolean = true;
					
					//save passable flag and set to false
					var wasPassable: Boolean = Gui.map.getGroundTile(tileX, tileY).passable;
					Gui.map.getGroundTile(tileX, tileY).passable = false;
				
					var enemyList : Array = new Array();
					FP.world.getClass(EnemyTemplate, enemyList);
					var spawnerList : Array = new Array();
					FP.world.getClass(BasicSpawner, spawnerList);
					var spawner: BasicSpawner;
					var spawner2 : BasicSpawner;
					var enemy: EnemyTemplate;
					var enemy2: EnemyTemplate;
				 
					//check all spawners if the paths are still valid
					for each (spawner in spawnerList) {
						
						pathsExistFromSpawner &&= !spawner.checkPath(tileX, tileY);
					
						//if a tower doesn't have a valid path, check if there exists a (new) valid path for all towers
						if (!pathsExistFromSpawner) {
							for each (spawner2 in spawnerList) {
								if (spawner2.checkPath(tileX, tileY))
									newPathsExistFromSpawner &&= spawner2.updatePath();
								if (!newPathsExistFromSpawner)
									break;
							}
							break;
						}
					}
					
					if (newPathsExistFromSpawner) {
						
						for each (enemy in enemyList) {
							
							pathsExistFromEntity &&= !enemy.checkPath(tileX, tileY);
							
							if (!pathsExistFromEntity) {
								for each (enemy2 in enemyList) {
									if (enemy2.checkPath(tileX, tileY))
										newPathsExistFromEntity &&= enemy2.updatePath();
									if (!newPathsExistFromEntity)
										break;
								}
								break;
							}
							
						}
						
					}
				  
					Gui.map.getGroundTile(tileX, tileY).passable = wasPassable;
				  
					if (newPathsExistFromSpawner && newPathsExistFromEntity) {
						map.addTower(tileX, tileY);
						guiTowerSelectedOverlay.doNotSelectNextFrame();
					}
					else {
						for each (enemy in enemyList) {
							enemy.updatePath();
						}
						
						for each (spawner in spawnerList) {
							spawner.updatePath();
						}
					}
				}*/
			}
			else if (idString == "ToggleDebug")
			{
				if (debugEnabled)
				{
					debugEnabled = false;
					FP.console.visible = false;
				}
				else
				{
					debugEnabled = true;
					FP.console.visible = true;
				}
		
			}
			
		}
		
	}

}