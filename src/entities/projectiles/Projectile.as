package entities.projectiles 
{
  import entities.map.Map;
  import entities.testenemy.EnemyTemplate;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Graphic;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.Mask;
  
  /**
   * ...
   * @author Shadowblink
   */
  public class Projectile extends Entity 
  {
    
    //Image var
    public var image: Image;
    //De damage van de projectile
    public var projectileDamage: Number;
    //De snelheid van de projectile
    public var projectileSpeed: Number;
    //De hoek van de projectile
    public var projectileAngle: Number;
    //De hoogte van de projectile
    public var projectileHeight: int;
    //De durability van de kogel
    public var projectileDurability: int;


    public function Projectile(width: Number, x : int, y : int, angle : Number, speed: Number, damage: Number, givenHeight: int, givenDurability: int) {
      this.layer = References.PROJECTILELAYER;
      //De speed updaten naar de gewenste speed (Nodig voor update functie)
      this.projectileSpeed = speed;
      //Doorgegeven angle is in graden, deze omvormen naar radialen en opslagen als globale variabele (Nodig voor update functie)
      this.projectileAngle = angle *= FP.RAD;
      //Doorgegeven damage toevoegen;
      this.projectileDamage = damage;
      //Doorgeven Height
      this.projectileHeight = givenHeight;
      //Doorgeven durability
      this.projectileDurability = givenDurability;
  
      //Berekende start positie a.d.h.v. berekende lengte van de 'loop' FUCKING GONIOMETRIE
      this.x = x + (width * (Math.cos(this.projectileAngle)));
      this.y = y + (width * (Math.sin(this.projectileAngle)));
    }
    


    override public function added():void {
		
    }
    


    override public function update():void {
      //Vars
      var i: int;
      var hitEnemy: EnemyTemplate;

      //Omdat de projectile constant moet bewegen moet hij met elke update via zijn hoek bewegen, goniometrische formule.
      this.x += (this.projectileSpeed * (Math.cos(this.projectileAngle))) * FP.elapsed;
      this.y += (this.projectileSpeed * (Math.sin(this.projectileAngle))) * FP.elapsed;
      

      //Als hij buiten de map is --> sterven
      if (this.x < 0 || this.x > (Map.map.mapWidth * References.TILESIZE) || this.y < 0 || this.y > (Map.map.mapHeight * References.TILESIZE))
      {
        die();
      }
      
      //Alle enemies afgaan
      for (i = 0; i < Map.map.enemyList.length; i++) {
        //Als de distance tot een enemy kleiner is als zijn straal dan heeft hij deze geraakt --> hitEnemy kopellen en uit de loop gaan
        if (FP.distance(Map.map.enemyList[i].x, Map.map.enemyList[i].y, this.x, this.y) < Map.map.enemyList[i].image.scaledWidth / 2.2) {
          hitEnemy = Map.map.enemyList[i];
          break;
        }
      }
      
      
      //Als we een enemy geraakt hebben de hit functie oproepen
      if (hitEnemy != null)
        hit(hitEnemy);
      

      //Als de groundtile niet bestaat --> out of map --> sterven, anders kijken of hij hoger is dan de grond, zo nee --> sterven   
      if (Map.map.getGroundTile((this.x / References.TILESIZE), (this.y / References.TILESIZE))== null || Map.map.getGroundTile((this.x / References.TILESIZE), (this.y / References.TILESIZE)).groundHeight > projectileHeight)
        die();

    }
    

    //Een functie die de projectile laat verdwijnen
    public function die(): void {
      FP.world.remove(this);
    }
	
	
	
    //Een functie die wordt uitgevoerd bij een enemy hit
    public function hit(enemy:EnemyTemplate): void {
      enemy.takeDamage(this.projectileDamage);
      this.projectileDurability--;
      if (this.projectileDurability == 0)
        die();
    }
    
    
  }

}