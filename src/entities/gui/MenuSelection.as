package entities.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import worlds.LevelMapWorld;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class MenuSelection extends Entity 
	{
		
		public var image : Image = new Image(Assets.MENUSELECTION);
		public var overlay : Spritemap;
		
		public function MenuSelection() 
		{		
		}
		
		override public function update():void 
		{
			overlay.setFrame(0);
			if (Input.mouseY > y + 7) {
				if (Input.mouseX > x && Input.mouseX < x + image.width) {
					if (Input.mouseY > y + 87) {
						overlay.setFrame(3);
						if (Input.mousePressed) {
							trace("he manneke er is nog gene options screen he pie");
						}
					} else if (Input.mouseY > y + 47) {
						overlay.setFrame(2);
						if (Input.mousePressed) {
							FP.world = new LevelMapWorld();
						}
					} else if (Input.mouseY > 0) {
						overlay.setFrame(1);
						if (Input.mousePressed) {
							FP.world = new LevelMapWorld();
						}
					}
				}
			}
		}
		
		override public function added():void 
		{
			overlay = new Spritemap(Assets.MENUSELECTIONOVERLAY, 186, 134);
			addGraphic(image);
			addGraphic(overlay);
		}
		
	}

}