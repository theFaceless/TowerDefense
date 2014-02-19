package entities.gui 
{
	import entities.upgrades.Upgrade;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	
	/**
	 * ...
	 * @author Wout Coenen
	 */
	public class GuiButtonUpgradeTower extends GuiButton {
		
		private var upgradeFunction: Function;
		private var upgrade: Upgrade;
		
		public function GuiButtonUpgradeTower(eventFunction: Function, posX: int, posY: int, idString: String, image: Image, imageHover: Image, upgradeFunction: Function, upgrade: Upgrade) 
		{
		
			super(eventFunction, posX, posY);
			
			this.idString = idString;
			this.image = image;
			this.imagePressed = imageHover;
			this.upgradeFunction = upgradeFunction;
			this.upgrade = upgrade;
			
		}
		
		/**
		 * Sets the image and the idString (for event handling)
		 */
		override public function added(): void
		{
			graphic = image;
			sizeX = Gui.guiOverlayTowerOptions.image.width - 2 * References.GUIBORDERSIZE;
			sizeY = References.GUIUPGRADEBUTTONHEIGHT;
			image.centerOrigin();
			image.scrollX = 0;
			image.scrollY = 0;
			setHitbox(sizeX, sizeY, sizeX/2, sizeY/2);
			
			imagePressed.centerOrigin();
			imagePressed.scrollX = 0;
			imagePressed.scrollY = 0;
			
		}
		
		/**
		 * changes the image of the button when the mouse hovers over it
		 */
		override public function onSelect(): void
		{
			graphic = imagePressed;
			image.centerOrigin();
		}
		
		/**
		 * changes back the image when the mouse leaves the button
		 */
		override public function onDeselect(): void
		{
			graphic = image;
			image.centerOrigin();
		}
		
		override public function onClicked(): void {
			upgradeFunction(upgrade);
			Gui.guiOverlayTowerOptions.show();
		}
		
	}

}