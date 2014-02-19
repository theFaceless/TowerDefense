package entities.upgrades 
{
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Shadowblink
	 */
	public class Upgrade 
	{
		public var name: String;
		public var cost: int;
		public var description: String;
		public var image: Image;
		public var range: int;
		public var damage: Number;
		public var aspd: Number;
		public var health: Number;
		public function Upgrade(upgradeName: String, upgradeCost: int, upgradeDescription: String, upgradeImage: Image, upgradeRange: int, upgradeDamage: Number, upgradeASPD: Number, upgradeHealth: Number) {
			name = upgradeName;
			cost = upgradeCost;
			description = upgradeDescription;
			image = upgradeImage;
			range = upgradeRange;
			damage = upgradeDamage;
			aspd = upgradeASPD;
			health = upgradeHealth;
		}
	}

}