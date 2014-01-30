package entities.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	
	/**
	 * temporary button for Brent
	 * @author Wout Coenen
	 */
	public class GuiButtonUpgradeTower extends GuiButton {
		
		public function GuiButtonUpgradeTower(eventFunction: Function, posX: int, posY: int) 
		{
		
			super(eventFunction, posX, posY);
		
		}
		
		/**
		 * Sets the image and the idString (for event handling)
		 */
		override public function added(): void
		{
			
			image = new Image(Assets.GUISMALLBUTTONADDTOWER);
			graphic = image;
			sizeX = image.width;
			sizeY = image.height;
			image.centerOrigin();
			image.scrollX = 0;
			image.scrollY = 0;
			mask = new Pixelmask(Assets.GUISMALLBUTTONADDTOWER, -(sizeX / 2), -(sizeY / 2));
			setHitboxTo(mask);
			
			imagePressed = new Image(Assets.GUISMALLBUTTONADDTOWER_PRESSED);
			imagePressed.centerOrigin();
			imagePressed.scrollX = 0;
			imagePressed.scrollY = 0;
			
			idString = "GuiButtonUpgradeTower";
			
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
		
	}

}