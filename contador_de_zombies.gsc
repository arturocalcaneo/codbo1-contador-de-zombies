#include maps\_utility;
#include common_scripts\utility;

init()
{
    if ( GetDvar( #"zombiemode" ) == "1" )
        level thread onplayerconnect();
}

onplayerconnect()
{
    for (;;)
    {
        level waittill( "connected", player ); 
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    self thread ZombieCounter();
}

ZombieCounter()
{
    hud = NewHudElem();
    hud1 = NewHudElem();

    // Configuración para el texto "Zombies Restantes:"
    hud1.horzAlign = "center";
    hud1.alignX = "center";
    hud1.vertAlign = "bottom";
    hud1.alignY = "bottom";
    hud1.y = -20;
    hud1.x = -10;
    hud1.foreground = 1;
    hud1.fontscale = 1.2;
    hud1.alpha = 1;
    hud1.color = (1, 1, 1);
    hud1 SetText("Zombies Restantes:");
    
    // Configuración para el número
    hud.horzAlign = "center";
    hud.alignX = "center";
    hud.vertAlign = "bottom";
    hud.alignY = "bottom";
    hud.y = -19;
    hud.x = 45;
    hud.foreground = 1;
    hud.fontscale = 1.2;
    hud.alpha = 1;
    hud.color = (1, 0, 0);
    hud SetValue(0);
    
    while (true)
    {
        hud SetValue(get_enemy_count() + level.zombie_total);
        wait (0.05);
    }
}

get_enemy_count()
{
    enemies = [];
    valid_enemies = [];
    enemies = GetAiSpeciesArray( "axis", "all" );
    for( i = 0; i < enemies.size; i++ )
    {
        if ( is_true( enemies[i].ignore_enemy_count ) )
        {
            continue;
        }

        if( isDefined( enemies[i].animname ) )
        {
            valid_enemies = array_add( valid_enemies, enemies[i] );
        }
    }
    return valid_enemies.size;
}