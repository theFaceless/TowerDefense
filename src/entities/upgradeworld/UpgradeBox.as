package entities.upgradeworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class UpgradeBox extends Entity 
	{
		
		public static const TYPE_PASSIVE : int = 0;
		public static const TYPE_ACTIVE : int = 1;
		
		public var upgradeType : int;
		public var graphicClass : Class;
		public var upgradeName : String;
		public var upgradeLayer : int = 0;
		public var upgradeDescr : String;
		public var requirements : Array;
		
		public function UpgradeBox(x : int, y : int, upgradeName : String, upgradeDescr : String, requirements : Array, upgradeType : int, graphicClass : Class) 
		{
			this.x = x;
			this.y = y;
			this.requirements = requirements;
			this.upgradeName = upgradeName;
			this.upgradeDescr = upgradeDescr;
			this.graphicClass = graphicClass;
			this.upgradeType = upgradeType;
		}
		
		override public function render():void 
		{
			for each (var e : Entity in requirements) {
				Draw.line(x, y+15, e.x, e.y+15, 0xFF00FF, 1);
			}
			super.render();
		}
		//axel is gay
		override public function added():void 
		{
			switch (upgradeType) {
				case 0:
					addGraphic(Image.createCircle(15, 0x0724ED, 1));
					break;
				case 1:
					addGraphic(Image.createRect(30, 30, 0x0724ED, 1));
					break;
			}
			var i : Image = new Image(graphicClass);
			i.centerOrigin();
			i.x = 15;
			i.y = 15;
			addGraphic(i);
			
			var t : Text = new Text(upgradeName, 0, 0);
			t.y = 40;
			t.x = 15;
			t.centerOrigin();
			addGraphic(t);
		}
		
	}

}