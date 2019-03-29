# Conventions

In here are defined the guidelines and conventions for this Godot project.

## File Hierarchy

as more files are added, file paths should become more granular,
(eg: audio/boss1 could contain 10 different sfx and 2 music files where the root,
  audio/ contains 4 music files for other parts of the game)

| Path | Contains | File Types |
| --- | --- | --- |
| audio/ | sound effects (sfx), music, or other audio files | `wav`, `opus`, etc) |
| game-objects/ | scene objects or nodes that are not the "map", "level", or scene itself | `tscn` |
| images/ | sprites or other images for the game | any img files (`png`, `jpg`, `tiff`, etc) |
| scenes/ | the scenes that are composed of other scenes or game objects | `tscn` |
| scripts/ | scripts for Node(s) | `gd` |
| scripts/globals/ | auto-load global scripts | `gd` |

note: Godot will generate `.import` files and they need to be in same $PWD as its associated file / asset (don't move these around yourself)

## File Names

?? snake_case, PascalCase, Pascal Spaced, ??

## Naming Conventions in GDScript

snake_case for everything within a script:
- local, member, or global variables
- functions or methods

except,

PascalCase for classes or `scene` objects loaded within a script (eg: `const MyCoolNode = preload('res://my_cool_node.gd')`)

CAPS_LOCK for enum values

follow the other conventions listed here https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_styleguide.html
