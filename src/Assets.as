package  
{
	import flash.display.InteractiveObject;
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class Assets 
	{
		//----------the graphics----------
		
		//TOWER GRAPHICS
		[Embed(source = "assets/BasicTower30px.png")] public static const BASICTOWER : Class;
		[Embed(source = "assets/TripleShotTower.png")] public static const TRIPLESHOTTOWER: Class;
		[Embed(source = "assets/LaserTower20x39px.png")] public static const LASERTOWER: Class;
		
		//PROJECTILE GRAPHICS
		[Embed(source = "assets/BasicBall.png")] public static const BASICBALL : Class;
		[Embed(source = "assets/LaserBolt20px.png")] public static const LASERBOLT : Class;
		
		//ENEMEY GRAPHICS
		[Embed(source = "assets/TestEnemy.png")] public static const TestEnemy : Class;
		
		//GROUND GRAPHICS
		[Embed(source = "assets/grass.png")] public static const GRASS : Class;
		[Embed(source = "assets/rock.png")] public static const ROCK : Class;
		[Embed(source = "assets/rockgrass.png")] public static const ROCKGRASS : Class;
		[Embed(source = "assets/snow.png")] public static const SNOW : Class;
		[Embed(source = "assets/mud.png")] public static const MUD : Class;
		[Embed(source="assets/mudgrass.png")] public static const MUDGRASS : Class;
		[Embed(source = "assets/abyss.png")] public static const ABYSS : Class;
		[Embed(source = "assets/rubble.png")] public static const RUBBLE : Class;
		[Embed(source = "assets/shadow.png")] public static const SHADOW : Class;
		[Embed(source = "assets/spawner.png")] public static const SPAWNER : Class;
		[Embed(source = "assets/castle.png")] public static const CASTLE : Class;
		
		//GUI GRAPHICS
		[Embed(source = "assets/MenuTrigger.png")] public static const GUITRIGGER:Class;
		[Embed(source = "assets/MenuSmallBg.png")] public static const GUISMALLBACKGROUND : Class;
		[Embed(source = "assets/CustomCursor.png")] public static const CUSTOMCURSOR : Class;
		[Embed(source = "assets/addTowerOverlay.png")] public static const GUIADDTOWEROVERLAY : Class;
		[Embed(source = "assets/guiOverlay.png")] public static const GUIOVERLAY: Class;
		
		//GUI BUTTON GRAPHICS
		[Embed(source = "assets/MenuButtonToggleDebug.png")] public static const GUISMALLBUTTONTOGGLEDEBUG: Class;
		[Embed(source = "assets/MenuButtonToggleDebugPressed.png")] public static const GUISMALLBUTTONTOGGLEDEBUG_PRESSED: Class;
		[Embed(source = "assets/MenuButtonAddTower.png")] public static const GUISMALLBUTTONADDTOWER: Class;
		[Embed(source = "assets/MenuButtonAddTowerPressed.png")] public static const GUISMALLBUTTONADDTOWER_PRESSED: Class;
		
		//MAP GRAPHICS
		[Embed(source = "assets/map.png")] public static const MAP : Class;
		[Embed(source = "assets/vlag.png")] public static const VLAG : Class;
		
		//----------the sounds----------
		
		//----------the levels----------
		[Embed(source = "assets/levels/TestLevel.oel", mimeType = "application/octet-stream")] public static const LEVEL_TESTLEVEL : Class;
		[Embed(source = "assets/levels/obstacleCourse.oel", mimeType = "application/octet-stream")] public static const LEVEL_OBSTACLECOURSE : Class;
		[Embed(source = "assets/levels/KingOfTheBigHill.oel", mimeType = "application/octet-stream")] public static const LEVEL_KINGOFTHEBIGHILL : Class;
		
	}

}