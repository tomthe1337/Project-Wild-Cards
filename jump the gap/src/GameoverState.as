package  
{
	import org.flixel.*;
	
	public class GameoverState extends FlxState 
	{
		private var storyText:FlxText;
		private var scrollSpeed:int;
		
		public function GameoverState():void 
		{
			storyText = new FlxText(0, FlxG.height+20, FlxG.width,
			"You are falling into an unknown world.\n\n\n"+
			"There are many trials ahead.\n\n" +
			"You can't stay here forever...\n\n"+
			"The only way is forward.\n\n\n\n" +
			"GOOD LUCK !");
			storyText.setFormat(null, 32, 0xFF000000, "center");
			add(storyText);
			scrollSpeed = -100;
		}
		override public function update():void
		{
			storyText.velocity.y = scrollSpeed;
			if (FlxG.keys.justReleased("ENTER")) {
				FlxG.fade(0xff000000, 1, goPlayState);
			}
			if (storyText.y < -400) {
				FlxG.fade(0xff000000, 1, goPlayState);
			}
			super.update();
		}
		
		private function goPlayState():void
		{
			FlxG.switchState(new PlayState());
			
		}
	}
}