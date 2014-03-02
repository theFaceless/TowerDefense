package worlds 
{
	import entities.gui.MenuSelection;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class MainMenu extends World 
	{
		public var menuSelection : MenuSelection;
		
		public function MainMenu() 
		{
			
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x2E872C;
			menuSelection = new MenuSelection();
			add(menuSelection);
			
			
			var logo : Entity = new Entity(0, 0, new Text("AWESOME LOGO"));
			(logo.graphic as Text).size += 32;
			(logo.graphic as Image).centerOrigin();
			
			logo.x = FP.halfWidth;
			logo.y = (logo.graphic as Image).height / 2 + 10;
			
			add(logo);
			menuSelection.x = FP.halfWidth - menuSelection.image.width / 2;
			menuSelection.y = FP.height - menuSelection.image.height;
			
		}
		
	}

}