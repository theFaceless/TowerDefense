package entities.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.DialogueManager;
	
	/**
	 * ...
	 * @author Olivier de Schaetzen
	 */
	public class GuilDialogue extends Entity 
	{
		/**
		 * the base image in which everything is placed
		 */
		public var image : Image;
		
		/**
		 * the text which is being displaced
		 */
		public var text : Text;
		
		/**
		 * the mode which is useds
		 */
		public var mode : int;
		
		/**
		 * the string of text which needs to be displayed
		 */
		public var textString : String;
		
		/**
		 * the dialogue manager
		 */
		public var dialogueManager : DialogueManager;
		
		/**
		 * a ticker used for frame timing
		 */
		private var ticker : int = 0;
		
		/**
		 * creates a new gui dialogue box
		 * @param	text	the text that is spoken
		 * @param	speaker	the person who is speaking
		 * @param	speakerImage	the mugshot of the person who is speaking
		 * @param	mode	the mode in which te text appears.0 = normal, 1 = fast, 2 = instant 
		 */
		public function GuilDialogue( dialogueManager : DialogueManager, text : String, speaker : String, speakerImage : Graphic = null, mode : int = 0) 
		{
			this.mode = mode;
			this.dialogueManager = dialogueManager;
			makeGraphic(text, speaker, speakerImage);
		}
		
		/**
		 * creates and places the graphics belonging to this dialogue box
		 */
		public function makeGraphic(dialogue : String, speaker : String, speakerImage : Graphic):void
		{
			x = 25;
			y = 25;
			this.image = new Image(Assets.GUIDIALOGUE);
			this.image.scrollX = 0;
			this.image.scrollY = 0;
			addGraphic(image);
			
			if (speakerImage) {
				speakerImage.scrollX = 0;
				speakerImage.scrollY = 0;
				speakerImage.x = 7;
				speakerImage.y = 7;
				addGraphic(speakerImage);
			}
			textString = speaker + ": " + dialogue;
			text = new Text("", 136, 10);
			text.scrollX = 0;
			text.scrollY = 0;
			
			addGraphic(text);	
		}
		
		/**
		 * we add enters to the given text when it is too wide to be displayed
		 */
		public function padEnters(text : Text):void
		{
			//if the text is too wide
			if (text.textWidth > 604) {
				
				//we loop over all the characters
				for (var i : int = text.text.length ; i >= 0; i--) {
					
					//if the character at i is a space
					if (text.text.charAt(i) == ' ') {
						//we add an enter and get rid of the space
						text.text = text.text.substring(0, i) + '\n' + text.text.substring(i + 1);
						return;
					}
					
				}
				
				//if we have found no enters, lets just add a dash and an enter
				text.text = text.text.substring(0, text.text.length - 1) + "-\n" + text.text.charAt(text.text.length - 1);
				
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			switch(mode) {
				//mode 0 : we add a character every 2 frames
				case 0:
					ticker--;
					if (ticker <= 0) {
						ticker = 2;
						text.text += textString.charAt(0);
						textString = textString.substring(1);
						padEnters(text);
					}
					break;
				//mode 1 : we add a character every frame
				case 1:
					text.text += textString.charAt(0);
					textString = textString.substring(1);
					padEnters(text);
					break;
			}
			
			if (Input.mouseReleased || Input.released(Key.ANY)) {
				dialogueManager.nextDialogue();
			}
		}
		
	}

}