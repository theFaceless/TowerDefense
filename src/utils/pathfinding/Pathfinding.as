package utils.pathfinding 
{
	import entities.GroundTile;
	import entities.towers.Tower;
	
	/**
	 * @author Axel Faes
	 */
	public class Pathfinding 
	{
		/**
		 * finds the smallest element in a node record list
		*/
		private static function smallestElement(open:Vector.<NodeRecord>):NodeRecord {
			var smallest:NodeRecord = open[0];
			for each(var m:NodeRecord in open) {
				if (m.costSoFar < smallest.costSoFar) {
					smallest = m;
				}
			}
			return smallest;
		}
		
		/**
		 * get all connections from a specific tile
		 */ 
		private static function getConnections(current:NodeRecord):Vector.<Connection>{
			var open:Vector.<Connection> = new Vector.<Connection>;
			
			var cur:GroundTile = current.node.getLeftTile();
			if (cur && (Math.abs(cur.groundHeight-current.node.groundHeight)<=1) && cur.passable) {
				var con:Connection = new Connection();
				con.fromNode = current;
				con.toNode = current.node.getLeftTile();
				open.push(con);
			}
			
			cur = current.node.getRightTile();
			if (cur && (Math.abs(cur.groundHeight-current.node.groundHeight)<=1) && cur.passable) {
				var con1:Connection = new Connection();
				con1.fromNode = current;
				con1.toNode = current.node.getRightTile();
				open.push(con1);
			}
			
			cur = current.node.getTopTile();
			if (cur && (Math.abs(cur.groundHeight-current.node.groundHeight)<=1) && cur.passable) {
				var con2:Connection = new Connection();
				con2.fromNode = current;
				con2.toNode = current.node.getTopTile();
				open.push(con2);
			}
			
			cur = current.node.getBottomTile();
			if (cur && (Math.abs(cur.groundHeight-current.node.groundHeight)<=1) && cur.passable) {
				var con3:Connection = new Connection();
				con3.fromNode = current;
				con3.toNode = current.node.getBottomTile();
				open.push(con3);
			}
			
			return open;
		}
		
		/**
		 * get all connections from a specific tile
		 */ 
		private static function getCollecConnections(current:NodeRecord, collec:Collection):Vector.<Connection>{
			var open:Vector.<Connection> = new Vector.<Connection>;
			
			makeConnection(current, current.node.getLeftTile(),open, collec);
			makeConnection(current, current.node.getRightTile(),open, collec);
			makeConnection(current, current.node.getTopTile(),open,collec);
			makeConnection(current, current.node.getBottomTile(),open, collec);
			
			return open;
		}
		
		/**
		 * remove an specific element from a vector
		 */
		public static function removeElem(open:Vector.<NodeRecord>, current:NodeRecord):void {
			for (var i:int = 0; i < open.length; i++) {
				if (open[i] == current) {
					open.splice(i, 1);
					break;
				}
			}
		}
		
		public static function makeConnection(current:NodeRecord, node:GroundTile,open:Vector.<Connection>, collec:Collection):void {
			if (node) {
				var dis:int = Math.abs(node.groundHeight - current.node.groundHeight);
				var passab:Boolean = (collec.otherPassable ? true : node.passable);
				var isTower:Boolean = (node.isTower && !node.passable);
				if (passab) {
					passab = (collec.elemHeightDo) ? collec.elemHeight[3 + node.groundHeight] : true;
				}
				if (dis <= collec.maxHeightDif && (passab||isTower)) {
					var con:Connection = new Connection();
					con.fromNode = current;
					con.toNode = node;
					con.cost = collec.basic + collec.random * Math.random();
					if (collec.heightDo) {
						con.cost += collec.height[3 + node.groundHeight];
					}
					if (collec.towerTile >= 0 && isTower) {
						con.cost += collec.towerTile;
					}
					open.push(con);
				}
			}
		}
		
		/**
		 * remove an specific element from a vector
		 */
		public static function find(open:Vector.<NodeRecord>, current:GroundTile):NodeRecord {
			var found:NodeRecord = null;
			for (var i:int = 0; i < open.length; i++) {
				if (open[i].node == current) {
					found = open[i];
					break;
				}
			}
			return found;
		}
		
		/**
		 * remove an specific element from a vector
		 */
		public static function contains(open:Vector.<NodeRecord>, current:GroundTile):Boolean {
			var found:Boolean = false;
			for (var i:int = 0; i < open.length; i++) {
				if (open[i].node == current) {
					found = true;
					break;
				}
			}
			return found;
		}
		 
		/**
		 * Function to calculate the dijkstra path
		 */
		public static function pathDijkstra(begin:GroundTile, end:GroundTile, collec:Collection=null):Path {
			var startrecord:NodeRecord;
			startrecord = new NodeRecord();
			startrecord.node = begin;
			
			var open:Vector.<NodeRecord> = new Vector.<NodeRecord>;
			open.push(startrecord);
			var closed:Vector.<NodeRecord> = new Vector.<NodeRecord>;
			
			var current:NodeRecord;
			
			while (open.length > 0) {
				current = smallestElement(open);
				
				if (current.node == end) {
					break;
				}
				
				var connections:Vector.<Connection>;
				if (collec) {
					connections = getCollecConnections(current, collec);
				}
				else {
					connections = getConnections(current);
				}
				
				for each(var connection:Connection in connections) {
					var endNode:GroundTile = connection.toNode;
					var endNodeCost:int = current.costSoFar + connection.cost;
					var endNodeRecord:NodeRecord;
					
					if (contains(closed, endNode)) {
						continue
					}
					
					else if (contains(open, endNode)) {
						endNodeRecord = find(open, endNode);
						
						if (endNodeRecord.costSoFar <= endNodeCost) {
							continue;
						}
					}
					else {
						endNodeRecord = new NodeRecord();
						endNodeRecord.node = endNode;
					}

					endNodeRecord.costSoFar = endNodeCost
					endNodeRecord.connection = connection
					
					if (!contains(open, endNode)) {
						open.push(endNodeRecord);
					}
				}
				
				removeElem(open, current);
				closed.push(current);
			}	
			
			if (current.node != end) {
				return null;
			}
			else {
				var path:Path = new Path();
				
				while (current.node != begin) {
					path.path.push(current.node);
					current = current.connection.fromNode;
				}

				path.path.reverse();
			
				return path;
			}
		}
		
		public static function heuristicEst(tile:GroundTile, end:GroundTile):Number {
			return 10*(Math.abs(tile.gridX - end.gridX) + Math.abs(tile.gridY - end.gridY));
		}
		
		/**
		 * Function to calculate the dijkstra path
		 */
		public static function pathAstar(begin:GroundTile, end:GroundTile):Path {
			var startrecord:NodeRecord;
			startrecord = new NodeRecord();
			startrecord.node = begin;
			
			startrecord.estimatedTotalCost = heuristicEst(begin, end);
			
			var open:Vector.<NodeRecord> = new Vector.<NodeRecord>;
			open.push(startrecord);
			var closed:Vector.<NodeRecord> = new Vector.<NodeRecord>;
			
			var current:NodeRecord;
			
			while (open.length > 0) {
				current = smallestElement(open);
				
				if (current.node == end) {
					break;
				}
				
				var connections:Vector.<Connection> = getConnections(current);
				
				for each(var connection:Connection in connections) {
					var endNode:GroundTile = connection.toNode;
					var endNodeCost:int = current.costSoFar + connection.cost;
					var endNodeHeuristic:int = 0;
					var endNodeRecord:NodeRecord;
					
					if (contains(closed, endNode)) {
						endNodeRecord = find(closed, endNode);
						if (endNodeRecord.costSoFar <= endNodeCost) {
							continue;
						}
						removeElem(closed, endNodeRecord);
						
						endNodeHeuristic = connection.cost - endNodeRecord.costSoFar;
					}
					
					else if (contains(open, endNode)) {
						endNodeRecord = find(open, endNode);
						
						if (endNodeRecord.costSoFar <= endNodeCost) {
							continue;
						}
						endNodeHeuristic = connection.cost - endNodeRecord.costSoFar;
					}
					else {
						endNodeRecord = new NodeRecord();
						endNodeRecord.node = endNode;
						
						endNodeHeuristic = heuristicEst(endNode, end);
					}

					endNodeRecord.costSoFar = endNodeCost
					endNodeRecord.connection = connection
					
					endNodeRecord.estimatedTotalCost = endNodeCost + endNodeHeuristic;
					
					if (!contains(open, endNode)) {
						open.push(endNodeRecord);
					}
				}
				
				removeElem(open, current);
				closed.push(current);
			}	
			
			if (current.node != end) {
				return null;
			}
			else {
				var path:Path = new Path();
				
				while (current.node != begin) {
					path.path.push(current.node);
					current = current.connection.fromNode;
				}

				path.path.reverse();
			
				return path;
			}
		}
		
	}

}