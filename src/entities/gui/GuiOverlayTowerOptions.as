package entities.gui 
{
	import entities.map.Map;
	import entities.towers.Tower;
	import entities.upgrades.Upgrade;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Wout Coenen
	 */
	public class GuiOverlayTowerOptions extends Entity {
		
		public var image: Image;
		private var upgradeButtons: Vector.<GuiButtonUpgradeTower> = new Vector.<GuiButtonUpgradeTower>;
		
		public function GuiOverlayTowerOptions() {
			super();
		}
		
		override public function added(): void {
			image = new Image(Assets.GUISELECTIONOVERLAY);
			image.centerOrigin();
			image.visible = false;
			graphic = image;
			setHitbox(image.width, image.height, image.width / 2, image.height / 2);
			image.scrollX = 0;
			image.scrollY = 0;
			x = FP.width - image.width / 2;
			y = image.height / 2;
			layer = References.GUILAYER;
		}
		
		public function show(): void {
			
			image.visible = true;
			
			var i: int;
			
			//clear the upgradeButtons
			for (i = 0; i < upgradeButtons.length; i++) {
				FP.world.remove(upgradeButtons[i]);
			}
			upgradeButtons = new Vector.<GuiButtonUpgradeTower>();
			
			var tileX: int = Gui.lastSelectedTileX
			var tileY: int = Gui.lastSelectedTileY;
			
			if (tileX < 0 || tileY < 0)
				return;
			
			if (!(Map.map.getGroundTile(tileX, tileY) is Tower))
				return;
			
			for (i = 0; i < upgradeButtons.length; i++) {
				FP.world.remove(upgradeButtons[i]);
				upgradeButtons.pop();
			}
			
			var upgradeList: Array = (Map.map.getGroundTile(tileX, tileY) as Tower).getUpgrades();
			var currentPosition: int = FP.height - (References.GUIBUTTONAREAHEIGHT + References.GUIBORDERSIZE * 2);
			var currentUpgrade: Upgrade;
			for (i = 0; i < upgradeList.length ; i++) {
				currentUpgrade = (upgradeList[i] as Upgrade);
				currentPosition -= References.GUIUPGRADEBUTTONHEIGHT + References.GUIBORDERSIZE;
				upgradeButtons.push(new GuiButtonUpgradeTower(Gui.eventHandler,
														FP.width - image.width / 2,
														currentPosition + References.GUIUPGRADEBUTTONHEIGHT / 2,
														"upgrade:" + currentUpgrade.name,
														currentUpgrade.image, currentUpgrade.image,
														(Map.map.getGroundTile(Gui.lastSelectedTileX, Gui.lastSelectedTileY) as Tower).towerUpgrade,
														upgradeList[i]));
				FP.world.add(upgradeButtons[upgradeButtons.length-1]);
			}
			
		}
		
		public function hide(): void {
			image.visible = false;
			var i: int;
			for (i = upgradeButtons.length - 1; i >= 0; i--) {
				FP.world.remove(upgradeButtons[i]);
			}
		}
		
		public function getWidth(): int {
			return image.width;
		}
		
	}

}