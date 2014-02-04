package worlds 
{
	import entities.upgradeworld.UpgradeContainer;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class UpgradeTree extends World 
	{
		
		public function UpgradeTree() 
		{
			add(new UpgradeContainer);
		}
		
	}

}