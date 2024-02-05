import bpy

def main():
    for i in bpy.context.scene.sequence_editor.sequences_all:
        if i.type == 'TRANSFORM':
            i.interpolation = 'BICUBIC'


main()
