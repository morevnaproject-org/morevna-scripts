#===========  MODIFY PARAMETERS HERE =================

search_string="2016-07-25-rea-mix"

#=====================================================

import bpy

seq=bpy.context.scene.sequence_editor.sequences_all
for i in seq:
    #print(i.type)
    if i.type == 'SOUND':
        if i.sound.filepath.find(search_string)!=-1:
            i.select = True
    if i.type == 'MOVIE':
        if i.filepath.find(search_string)!=-1:
            i.select = True
    if i.type=='IMAGE':
        if i.directory.find(search_string)!=-1:
            i.select = True
