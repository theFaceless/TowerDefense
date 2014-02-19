package worlds 
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	
	/**
	 * @author Axel Faes
	 */
	public class EndGameGUI extends Entity {
		
		private var xlen:int, ylen:int;
		
		public function EndGameGUI(x:int, y:int, lenx:int, leny:int) {
			xlen = lenx;
			ylen = leny;
			super(x, y);
		}
		
		override public function added():void {
			var image:Image = new Image(Assets.GUIENDGAME);
			image.scaledWidth = xlen;
			image.scaledHeight = ylen;
			this.graphic = image;
		}
	}

}