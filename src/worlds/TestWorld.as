package worlds 
{
	import entities.castle.BasicCastle;
	import entities.GroundTile;
	import entities.map.Map;
	import entities.mapmenu.LevelSelectMap;
	import entities.spawners.BasicSpawner;
	import entities.testenemy.FirstEnemy;
	import net.flashpunk.World;
	import utils.pathfinding.Path;
	import utils.pathfinding.Pathfinding;
	import net.flashpunk.FP;
	import entities.gui.Gui;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class TestWorld extends World 
	{
		public var map:Map;
		public var testenemy: BasicSpawner;
		public var testcastly: BasicCastle;
		
		private var level : Class;
		
		public var done:Boolean = false;
		public function TestWorld(level : Class) 
		{
			this.level = level;
			FP.camera.x = 0;
			FP.camera.y = 0;
		}
		
		override public function begin():void 
		{
			map = new Map(level);
			add(map);		

			Gui.initWithMap();
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}