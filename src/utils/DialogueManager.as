package utils 
{
	import entities.gui.GuilDialogue;
	import entities.map.Map;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class DialogueManager 
	{
		
		//the xml file that contains all the dialogue
		public var xml : XML;
		
		//a list of all the dialogues that need to be shown or have already been shown
		public var guiDialogues : Vector.<GuilDialogue>;
		
		//this keeps track of the current Dialogue
		public var currentDialogue : int = -1;
		
		public function DialogueManager(dialoguexml : Class) 
		{
			if (dialoguexml == null) {
				Map.map.isInDialogue = false;
			} else {
				parseDialogue(dialoguexml);
				nextDialogue();
			}
		}
		
		/**
		 * this shows the next dialogue or ends the dialogue when all the dialogue has finished
		 */
		public function nextDialogue():void
		{
			if (currentDialogue >= 0) {
				FP.world.remove(guiDialogues[currentDialogue]);
			}
			currentDialogue++;
			
			if (currentDialogue >= guiDialogues.length) {
				Map.map.isInDialogue = false;
				return;
			}
			FP.world.add(guiDialogues[currentDialogue]);
		}
		
		/**
		 * this parse the given xml class file
		 * @param	dialoguexml	the xml class file to parse
		 */
		public function parseDialogue(dialoguexml : Class):void {
			guiDialogues = new Vector.<GuilDialogue>(0);
			this.xml = FP.getXML(dialoguexml);
			for each (var data : XML in xml.string) {
				
				var guiDialogue : GuilDialogue = new GuilDialogue(this, data.@text, data.@speaker, getGraphic(data.@graphic), parseInt(data.@mode));
				
				guiDialogues.push(guiDialogue);
			}
		}
		
		/**
		 * this returns a dialogue graphic from the given string
		 * @param	string	the name of the	graphic
		 * @return	the corresponding graphic
		 */
		public function getGraphic(string : String):Graphic {
			switch (string) {
				case "cnn":
					return new Image(Assets.CNN);
					break;
				default:
					return null;
					break;
			}
		}
		
	}

}