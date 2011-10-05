package  
{
	import org.flixel.*;
	
	public class MenuState extends FlxState 
	{
		private var storyText:FlxText;
		
		public function MenuState():void 
		{
			FlxG.bgColor = 0xff000000;
			storyText = new FlxText(0, FlxG.height/2, FlxG.width,
			"Press Enter");
			storyText.setFormat(null, 32, 0xFFffffff, "center");
			add(storyText);
		}
		override public function update():void
		{
			if (FlxG.keys.justReleased("ENTER")) {
				FlxG.fade(0xff000000, 1, goPlayState);
			}
			super.update();
		}
		private function goPlayState():void
		{
			FlxG.switchState(new IntroState());
			
		}
	}
}