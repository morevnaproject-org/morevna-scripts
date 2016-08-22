#===========  MODIFY PARAMETERS HERE =================

search_string="rea-mix-2016-05-13"

#=====================================================

import bpy

seq=bpy.data.scenes[0].sequence_editor.sequences_all
for i in seq:
    #print(i.type)
    if i.type == 'SOUND' or i.type == 'MOVIE':
        if i.filepath.find(search_string)!=-1:
            i.select = True
    if i.type=='IMAGE':
        if i.directory.find(search_string)!=-1:
            i.select = True
