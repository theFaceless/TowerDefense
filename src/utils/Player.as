package utils 
{
	/**
	 * ...
	 * @author Crushski
	 */
	public class Player  {
		public static var money: int;
		
		public function Player() 
		{
			money = 1000;
		}
		
		//stroompool, addmoney, addpower, 
		
		public static function addMoney(amount:int= 0):void 
		{
			money += amount;
		}
		
		public static function useMoney(amount:int = 0):Boolean 
		{
			if ( amount > money )
				return false;
			else{
				money -= amount;
				return true;
			}
		}
	}
}
		
		
		
	

