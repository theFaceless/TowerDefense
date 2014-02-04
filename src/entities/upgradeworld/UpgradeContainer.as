package entities.upgradeworld 
{
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class UpgradeContainer extends Entity 
	{
		
		public var upgrades : Dictionary;
		public var layeramounts : Array;
		
		public function UpgradeContainer() 
		{
		}
		
		override public function added():void 
		{
			instantiateTree();
		}
		
		public function getGraphic(g : String):Class
		{
			switch(g) {
				case "TrippleShot":
					return Assets.TRIPLESHOTTOWER;
				case "FlameThrower":
					return Assets.FIRETOWER;
				case "LaserTower":
					return Assets.LASERTOWER;
				case "TrippleLaser":
					return Assets.TRIPLELASERTOWER;
				case "BasicTower":
				default:
					return Assets.BASICTOWER;
			}
		}
		
		public function instantiateTree():void
		{
			upgrades = new Dictionary(false);
			layeramounts = new Array(0);
			
			var xml : XML = FP.getXML(Assets.XML_UPGRADES);
			
			for each (var upgrade : XML in xml.upgrade) {
				
				var layer : int = 0;
				var name : String = upgrade.@name;
				var type : int = parseInt(upgrade.@type);	
				var reqarr : Array = new Array(0);
				for each (var req : XML in upgrade.requirement) {
					var t : UpgradeBox = (upgrades[parseInt(req.@id)] as UpgradeBox);
					reqarr.push(t);
					trace(upgrades[req.@id]);
					layer = layer > t.upgradeLayer ? layer : t.upgradeLayer + 1;
				}
				
				if (layeramounts.length <= layer) layeramounts.push(0);
				else layeramounts[layer]++;
				
				var box : UpgradeBox = new UpgradeBox( FP.halfWidth*0.5 + layeramounts[layer]*125, FP.height - 50 - 70*layer, name, "", reqarr, type, getGraphic(upgrade.@graphic));		
				box.upgradeLayer = layer;
				upgrades[parseInt(upgrade.@id)] = box; 
				world.add(box);
			}
			
		}
		
	}

}