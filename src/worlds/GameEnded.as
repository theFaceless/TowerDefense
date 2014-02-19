package worlds 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
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
		private var str: String = "";
		
		
		public function GameEnded(wereld: World, won: Boolean) {
			image = FP.screen.capture();
			
			//color the image
			if (!won) {
				image.color = 0x404040;
				str = "Game Over"
			}
			else {
				image.color = 0xBABD42;
				str = "Victory";
			}		
			
			super();
		}
		
		override public function begin():void {
			//add background
			add(new Entity(0, 0, image));
			//add gui
			add(new EndGameGUI(200, 100, 400, 400));
			//add text
			Text.size = 50;
			add(new Entity(400 - (str.length / 2) * 28, 150, new Text(str)));
			Text.size = 20;
			add(new Entity(230, 250, new Text("Some really fucking\n Epic Quote")));
		}
		
		override public function update():void {
			//super.update();
		}
	}

}