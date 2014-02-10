package entities.map 
{
	import entities.GroundTile;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class Rubble extends GroundTile 
	{
		
		public function Rubble(map : Map, x : int = 0, y : int = 0, groundHeight : int = 0)
		{
			super(map, x, y, groundHeight);
			this.passable = false;
		}
		
		override public function added():void 
		{
			super.added();
			var rock : Image = new Image(Assets.RUBBLE);
			makeShadow(rock, 0, 0);
			addGraphic(rock);
			rock.centerOrigin();
			//rock.color = 0x1f1f1f * (groundHeight + 2);
			this.passable = false;
			this.placeable = false;
		}
		
	}

}