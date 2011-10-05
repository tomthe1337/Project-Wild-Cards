package  
{
	import org.flixel.*;
	
	public class IntroState extends FlxState 
	{
		private var storyText:FlxText;
		private var scrollSpeed:int;
		
		public function IntroState():void 
		{
			FlxG.bgColor = 0xff000000;
			storyText = new FlxText(0, FlxG.height+20, FlxG.width,
			"You are running for some reason.\n\n\n"+
			"There are things to attack and dodge.\n\n" +
			"Jump from building to building.\n\n"+
			"Use the arrow keys.\n\n\n\n" +
			"GOOD LUCK !");
			storyText.setFormat(null, 32, 0xFFffffff, "center");
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