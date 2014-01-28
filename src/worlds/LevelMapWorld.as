package worlds 
{
	import entities.mapmenu.LevelSelectMap;
	import entities.mapmenu.LevelSelector;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class LevelMapWorld extends World 
	{
		
		public var image : Image;
		
		public function LevelMapWorld() 
		{
			super();
		}
		
		override public function begin():void 
		{
			super.begin();
			FP.camera.x = 23;
			FP.camera.y = 325;
			add(new LevelSelectMap());
			
			//adding level buttons
			//OBSTACLE COURSE TESTLEVEL
			add(new LevelSelector(192, 521, Assets.LEVEL_OBSTACLECOURSE));
			add(new LevelSelector(345, 572, Assets.LEVEL_KINGOFTHEBIGHILL));
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed) {
				trace(FP.camera.x + Input.mouseX, " ", FP.camera.y + Input.mouseY);
			}
			if (Input.check(Key.RIGHT)) {
				FP.camera.x += References.SCROLLSPEED * FP.elapsed;
				if ( FP.camera.x > 2000 - 800) FP.camera.x = 2000 - 800;
			}
			if (Input.check(Key.LEFT)) {
				FP.camera.x -= References.SCROLLSPEED * FP.elapsed;
				if (FP.camera.x < 0) FP.camera.x = 0;
			}
			if (Input.check(Key.UP)) {
				FP.camera.y -= References.SCROLLSPEED * FP.elapsed;
				if (FP.camera.y < 0) FP.camera.y = 0;
			}
			if (Input.check(Key.DOWN)) {
				FP.camera.y += References.SCROLLSPEED * FP.elapsed;
				if ( FP.camera.y > 2000 - 600) FP.camera.y = 2000 - 600;
			}
		}
		
	}

}