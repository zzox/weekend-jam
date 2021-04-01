package display;

import flixel.group.FlxGroup;

class Store extends FlxGroup {
    var scene:PlayState;
    public function new (scene:PlayState) {
        super();

        this.scene = scene;
    }
}
