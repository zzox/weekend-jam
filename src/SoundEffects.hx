// class where we add all sounds at the beginning of each loop, play them and then clear them.
import flixel.system.FlxSound;
import flixel.FlxG;

typedef Sound = {
    var name:String;
    var volume:Float;
    var sample:String;
} 

class SoundEffects {
    var sounds:Array<Sound>;
    var dict:Map<String, String> = [
        'small-player-bullet' => AssetPaths.player_bullet__wav,
        'small-player-ball' => AssetPaths.player_ball__wav,
        'small-enemy-bullet' => AssetPaths.enemy_bullet__wav,
        'small-enemy-ball' => AssetPaths.enemy_ball__wav,
        'explode-small' => AssetPaths.explosion_small__wav,
        'explode-medium' => AssetPaths.explosion_medium__wav
    ];

    public function new () {
        sounds = [];
    }

    public function add (name:String, volume:Float) {
        for (sound in sounds) {
            if (sound.name == name) {
                return;
            }
        }

        sounds.push({ name: name, volume: volume, sample: dict[name] });
    }

    public function playAll () {
        trace(sounds);
        sounds.map((sound:Sound) -> FlxG.sound.play(sound.sample, sound.volume));
    }
}
