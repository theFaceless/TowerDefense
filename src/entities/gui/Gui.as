package entities.gui 
{
	import entities.map.Map;
	import entities.towers.Tower;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
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
		
		public static var guiTowerSelectedOverlay:GuiTowerSelectedOverlay;
		public static var guiMinimap: GuiMinimap;
		public static var guiOverlay: GuiOverlay;
		public static var guiOverlayTowerOptions: GuiOverlayTowerOptions;
		
		public static var customCursor: CustomCursor;
		
		public static var lastSelectedTileX: int;
		public static var lastSelectedTileY: int;
		
		/**
		 * Call this method to initiliaze the GUI
		 */
		public static function initWithMap(): void {
			
			lastSelectedTileX = -1;
			lastSelectedTileY = -1;
			
			FP.console.enable();
			FP.console.visible = false;
			debugEnabled = false;
			
			guiTowerSelectedOverlay = new GuiTowerSelectedOverlay();
			FP.world.add(guiTowerSelectedOverlay);
			
			guiMinimap = new GuiMinimap();
			FP.world.add(guiMinimap);
			
			guiOverlayTowerOptions = new GuiOverlayTowerOptions();
			FP.world.add(guiOverlayTowerOptions);
			
			//initialize the cursor
			if (useCustomCursor)
			{
				customCursor = new CustomCursor();
				FP.world.add(customCursor);
			}
			
		}
		
		public static function doNotSelectNextFrame(): void {
			guiTowerSelectedOverlay.doNotSelectNextFrame();
		}
		
		/**
		 * triggered when a button has been clicked on the small menu
		 * @param	idString the String-identifier of the clicked button
		 */
		public static function eventHandler(idString: String): void
		{
			//DEBUG LINE
			trace (idString);
			
			if (idString == "GuiButtonAddTower") {
				FP.world.add(new GuiNewTowerOverlay(funcP));
			}
			else if (idString == "AddTower") {
				
				var tileX: int = (Input.mouseX + FP.camera.x) / References.TILESIZE;
				var tileY: int = (Input.mouseY + FP.camera.y) / References.TILESIZE;
				
				Map.map.placeTower(tileX, tileY);
				
				doNotSelectNextFrame();
				
			}
			else if (idString == "TowerSelected") {
				lastSelectedTileX = (Input.mouseX + FP.camera.x) / References.TILESIZE;
				lastSelectedTileY = (Input.mouseY + FP.camera.y) / References.TILESIZE;
				guiOverlayTowerOptions.show();
			}
			else if (idString == "TowerDeselected") {
				lastSelectedTileX = -1;
				lastSelectedTileY = -1;
				guiOverlayTowerOptions.hide();
			}
			else if (idString == "ToggleDebug") {
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
			else if (idString == "MinimapAdded") {
				guiOverlay = new GuiOverlay(eventHandler, guiMinimap.getSizeX(), References.GUIBORDERSIZE, References.GUIBUTTONAREAHEIGHT);
				FP.world.add(guiOverlay);
			}
			else if (idString == "GuiButtonUpgradeTower") {
				if (lastSelectedTileX >= 0 && lastSelectedTileY >= 0) {
					(Map.map.getGroundTile(lastSelectedTileX, lastSelectedTileY) as Tower).towerUpgrade();
				}
			}
			
		}
		
		public static function mapCanGetInput(): Boolean {
			if (Input.mouseX < References.GUIBORDERSIZE)
				return false;
			else if (lastSelectedTileX < 0 && Input.mouseX > FP.width - References.GUIBORDERSIZE)
				return false;
			else if (lastSelectedTileX >= 0 && Input.mouseX > FP.width - guiOverlayTowerOptions.width)
				return false;
			else if (Input.mouseY < References.GUIBORDERSIZE)
				return false;
			else if (lastSelectedTileY < 0 && Input.mouseY > FP.height - 2 * References.GUIBORDERSIZE - References.GUIBUTTONAREAHEIGHT)
				return false;
			else if (Input.mouseX < guiMinimap.getSizeX() && Input.mouseY > FP.height - guiMinimap.getSizeY())
				return false;
			else
				return true;
		}
		
	}

}