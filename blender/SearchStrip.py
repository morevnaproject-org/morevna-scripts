#===========  MODIFY PARAMETERS HERE =================

search_string="94778"

#=====================================================

import bpy

seq=bpy.data.scenes[0].sequence_editor.sequences_all
for i in seq:
    if i.type != 'MetaSequence'
        if i.filepath.find(search_string)!=-1:
        i.select(true)
