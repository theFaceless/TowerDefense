package utils 
{
	/**
	 * ...
	 * @author Crushski
	 */
	public class Player  {
		public var money: int;
		
		public function Player() 
		{
			this.money = 1000;
		}
		
		//stroompool, addmoney, addpower, 
		
		public function addMoney(amount:int):void 
		{
			this.money += amount;
		}
		
		public function useMoney(amount: int):Boolean 
		{
			if ( amount > this.money )
				return false;
			else{
				this.money -= amount;
				return true;
			}
		}
	}
}
		
		
		
	

