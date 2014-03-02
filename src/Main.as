package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.LevelMapWorld;
	import worlds.MainMenu;
	import worlds.TestWorld;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(800, 600, 30, false);
		}
		
		override public function init():void 
		{
			super.init();
			FP.world = new MainMenu();
			//FP.world = new TestWorld;
		}
	}
	
}