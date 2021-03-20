package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class PlayState extends FlxState {
	override public function create() {
        super.create();

        FlxG.mouse.visible = false;

        camera.pixelPerfectRender = true;
        FlxG.scaleMode = new PixelPerfectScaleMode();

        bgColor = 0xff151515;

		var player = new Player(120, 120);
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
