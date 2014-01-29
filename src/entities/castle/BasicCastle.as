package entities.castle 
{
	import entities.testenemy.EnemyTemplate;
	import entities.testenemy.FirstEnemy;
	import entities.towers.TowerTemplate;
	import net.flashpunk.Entity;
	import entities.map.Map;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	import utils.pathfinding.Path;
	import utils.pathfinding.Pathfinding;

	import entities.GroundTile;
	
	/**
	 * ...
	 * @author Axel Faes
	 */
	public class BasicCastle extends TowerTemplate
	{
		private var image:Image;
		
		private var health:Number = 2000;
		public var destroyed:Boolean = false;
		
		public function BasicCastle(map : Map, x : int = 0, y : int = 0, groundHeight : int = 0, health : int = 2000) 
		{
			super(map, x, y, groundHeight, 2, 2);
			this.isPowerSource = true;
			this.isConnectedToPower = true;
			this.powerRange = 400;
			this.health = health;
			placeable = false;
			
			type = "castle";
		}
		
		public function contains(x:int, y:int):Boolean {
			if (gridX <= x && x <= gridX + 2) {
				if (gridY >= y && y <= gridY + 2) {
					return true;
				}
			}
			return false;
		}
		
		public function takeDamage(dam:int):void {
			this.health -= dam;
			if (health <= 0) {
				destroyed = true;
			}
		}
		
		override public function added():void {
			super.added();
			this.image = new Image(Assets.CASTLE);
			image.originX = 20;
			image.originY = 20;
			addGraphic(image);
		}
		
		override public function update():void {
			
		}		
		
	}

}