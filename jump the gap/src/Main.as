package  
{	
	import org.flixel.*;
	[SWF(width = "800", height = "600", backgroundColor = "#000000")]
	
	public class Main extends FlxGame 
	{
		
		public function Main() 
		{
			super(800, 600, PlayState, 1, 60, 30, true);
		}
		
	}

}