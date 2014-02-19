package worlds 
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Axel Faes
	 */
	public class GameEnded extends World
	{
		
		public var image : Image;
		
		
		public function GameEnded(wereld: World, won: Boolean) {
			image = FP.screen.capture();
			
			//color the image
			if (!won) {
				image.color = 0x404040;
			}
			else {
				image.color = 0xBABD42;
			}		
			
			super();
		}
		
		override public function begin():void {
			//add background
			add(new Entity(0, 0, image));
			//add gui
			add(new EndGameGUI(200, 100, 400,400));
		}
		
		override public function update():void {
			super.update();
		}
	}

}