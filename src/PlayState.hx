package;

import display.HUD;
import flixel.tweens.FlxEase;
import actors.Player;
import actors.Enemy;
import data.Enemies;
import data.Structures;
import data.Waves;
import data.Weapons;
import display.Background;
import display.Explosion;
import display.Store;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Projectile;
import openfl.utils.Assets;

enum GameState {
    Playing;
    MainMenu;
    Store;
    GameOver;
}

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 100;
    static inline final PROJ_POOL_SIZE = 1000;
    static inline final EXPLOSION_POOL_SIZE = 20;
    public static inline final PLAYER_START_X = 77;
    static inline final PLAYER_START_Y = 200;
    static inline final PLAYER_RESPAWN_Y = 300;
    static inline final TRANSITION_TIME = 3.0;

    public var gameState:GameState;

    var background:Background;
    public var player:Null<Player>;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;

    public var worldIndex:Int;
    var waveIndex:Int;
    var subwaveIndex:Int;
    var gameTime:Float;
    public var points:Int;

    public var livingEnemies:Int;
    var subwavesDone:Bool;
    var levelComplete:Bool;

    var ambientSound:FlxSound;
    var waveSound:FlxSound;
    var loopTime:Float = 0.0;

    var hud:HUD;
    var gameOverBanner:FlxGroup;

    var store:Store;

    override public function create() {
        super.create();

        // PROD: remove this vvv
        // requires `-debug` flag
        FlxG.debugger.visible = true;
        FlxG.debugger.drawDebug = true;

        FlxG.mouse.visible = false;

        camera.pixelPerfectRender = true;
        FlxG.scaleMode = new PixelPerfectScaleMode();

        bgColor = 0xff151515;

        background = new Background();
        add(background);

        store = new Store(this);
        store.visible = false;
        add(store);

        player = new Player(PLAYER_START_X, PLAYER_START_Y, this);
        add(player);
        add(player.horizontalFlames);
        add(player.verticalFlames);

        enemies = new FlxTypedGroup<Enemy>(ENEMY_POOL_SIZE);
        for (_ in 0...ENEMY_POOL_SIZE) {
            var enemy = new Enemy(this);
            enemy.kill();
            enemies.add(enemy);
        }
        add(enemies);

        projectiles = new FlxTypedGroup<Projectile>(PROJ_POOL_SIZE);
        for (_ in 0...PROJ_POOL_SIZE) {
            var proj = new Projectile();
            proj.kill();
            projectiles.add(proj);
        }
        add(projectiles);

        explosions = new FlxTypedGroup<Explosion>(EXPLOSION_POOL_SIZE);
        for (_ in 0...EXPLOSION_POOL_SIZE) {
            var explo = new Explosion();
            explo.kill();
            explosions.add(explo);
        }
        add(explosions);

        hud = new HUD(this);
        hud.visible = false;
        add(hud);

        // GAME OVER BANNER
        var textBytes = Assets.getText(AssetPaths.pixel3x5__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.pixel3x5__png, XMLData);

        gameOverBanner = new FlxGroup();
        var goBg = new FlxSprite(0, 112);
        goBg.makeGraphic(160, 13, 0xff211640);
        gameOverBanner.add(goBg);

        var goText = new FlxBitmapText(fontAngelCode);
        goText.setPosition(40, 110);
        goText.text = 'G A M E  O V E R';
        gameOverBanner.add(goText);

        gameOverBanner.visible = false;
        add(gameOverBanner);

        gameState = MainMenu;
        ambientSound = FlxG.sound.play(AssetPaths.amb1__wav, 1.0, true);

        worldIndex = 0;
        points = 0;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        var anyKey:Bool = false;
        if (FlxG.keys.anyJustPressed([SPACE, TAB, Z, X])) {
            anyKey = true;
        }

        if (gameState == Playing) {
            FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
            FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);

            loopTime += elapsed;

            handleEnemySpawn(elapsed);

            handlePoints();
        } else if (gameState == MainMenu) {
            if (anyKey) {
                startLevel();
            }
        } else if (gameState == GameOver) {
            if (anyKey) {
                FlxG.switchState(new PlayState());
            }
        }
    }

    function startLevel () {
        waveIndex = 0;
        subwaveIndex = 0;
        gameTime = -TRANSITION_TIME;

        livingEnemies = 0;
        subwavesDone = false;

        // move to function to change according to powerups AND bpm
        player.weapons[0].reloadTime = Waves.convertBeatsToSeconds(1, Waves.data[worldIndex].bpm);
        player.weapons[1].reloadTime = Waves.convertBeatsToSeconds(2, Waves.data[worldIndex].bpm);

        gameState = Playing;

        tweenPlayerToCenter();

        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            // TODO: play song from the level
            waveSound = FlxG.sound.play(AssetPaths.int1__wav, 1, true);
            waveSound.onComplete = () -> loopTime = 0;
        });
        hud.visible = true;
    }

    function winLevel () {
        hud.winBg.visible = true;
        hud.winText.visible = true;

        tweenPlayerToCenter();
    }

    // TODO: show score in banner
    public function gameOver () {
        player = null;
        FlxTween.tween(waveSound, { volume: 0.0 }, TRANSITION_TIME);
        gameOverBanner.visible = true;

        new FlxTimer().start(1.5, (_:FlxTimer) -> {
            // show score
            // TODO: check high score?
            hud.visible = false;
        });

        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            gameState = GameOver;
            // TODO: game over music? or silence?
            ambientSound = FlxG.sound.play(AssetPaths.amb1__wav, 1.0, true);
        });
    }

    function generateStore () {
        // first, we generate the items
        // we show what bgs we have, if we have them
    }

    function handleEnemySpawn (elapsed:Float) {
        gameTime += elapsed;

        var world = Waves.data[worldIndex];
        // if we haven't released all the subwaves, we check times here
        if (subwavesDone) {
            // start the next wave if there's no enemies left.
            // we have a negative gametime to start the next wave at the exact time the music loops.
            if (livingEnemies == 0) {
                subwavesDone = false;
                waveIndex++;
                subwaveIndex = 0;

                var loopLength = waveSound.length / 1000;
                gameTime = -(loopLength - loopTime);
                // if it's too short (less than a beat) we add a new loop.
                // WARN: Not 100% tested so a potential problem area.
                if (gameTime > -(Waves.convertBeatsToSeconds(1, world.bpm))) {
                    gameTime -= loopTime;
                }

                if (waveIndex == world.waves.length) {
                    gameState = Store;
                    winLevel();
                }
            }
        } else {
            var subwaveItem = world.waves[waveIndex][subwaveIndex];
            if (gameTime > Waves.convertBeatsToSeconds(subwaveItem.beats - 1, world.bpm)) {
                var enemyShape:Array<Int> = Structures.getStructure(subwaveItem.shape, subwaveItem.quantity);

                for (xPos in enemyShape) {
                    createEnemy(xPos, -(Waves.convertBeatsToSeconds(1, world.bpm) * 30), subwaveItem.type);
                }

                subwaveIndex++;

                // check to see enemyCount if we should go to the next wave
                if (subwaveIndex == world.waves[waveIndex].length) {
                    subwavesDone = true;
                }
            }
        }
    }

    function handlePoints () {
        if (points < 0) {
            points = 0;
        }
    }

    function createEnemy (x:Int, y:Float, type:EnemyType) {
        livingEnemies++;
        var enemy = enemies.recycle(Enemy);
        enemy.start(x, y, type);
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        // TODO: don't kill enemy here, only if they've lost hitpoints
        // do we subtract or add points here?
        createExplosion(Utils.getSpriteCenter(enemy));
        enemy.kill();

        if (!player.isHurt) {
            player.damage(10, 'body');
        }
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        createExplosion(Utils.getSpriteCenter(enemy));
        points += enemy.points;
        // TODO: potentially spawn powerup
        enemy.kill();
        proj.kill();
    }

    public function shoot (x:Float, y:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];

        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, bullet);

        if (bullet.style == PlayerTwoShots) {
            var proj = projectiles.recycle(Projectile);
            proj.shoot(x, y, bullet, { flipXVel: true });        
        }
    }

    public function createExplosion (point:FlxPoint) {
        var exp = explosions.recycle(Explosion);
        exp.explode(point.x, point.y);
    }

    function tweenPlayerToCenter () {
        background.scrollTween(20);

        // TODO: transition sound
        FlxTween.tween(ambientSound, { volume: 0.0 }, TRANSITION_TIME);

        player.inControl = false;
        FlxTween.tween(player, { x: PLAYER_START_X }, TRANSITION_TIME, { ease: FlxEase.cubeOut });
        FlxTween.tween(player, { y: PLAYER_START_Y }, TRANSITION_TIME, { ease: FlxEase.cubeInOut, onComplete:
            (_:FlxTween) -> {
                hud.winBg.visible = false;
                hud.winText.visible = false;
                player.inControl = true;
            }
        });
    }

    function overlapPowerup () {
        // if we have points, we buy it.
        // if we don't, nothing happens
    }
}
