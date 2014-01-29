package utils.pathfinding 
{
	/**
	 * ...
	 * @author Axel Faes
	 */
	public class Collection 
	{
		public var heightDo:Boolean = false;
		public var height:Vector.<int> = new Vector.<int>;
		public var elemHeightDo:Boolean = false;
		public var elemHeight:Vector.<Boolean> = new Vector.<Boolean>;
		
		public var maxHeightDif:int = 1;
		public var towerTile:int = 9999;
		public var otherPassable:Boolean = false;
		
		public var basic:int = 10;
		public var random:int = 15;
		
		public function Collection() 
		{
			
		}
		
	}

}