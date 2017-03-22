#===========  MODIFY PARAMETERS HERE =================

oldpath="//sound/track-1-cosh-man.wav"
newpath="//render/sound/voice-raw-1-cosh-man.flac.wav"

#=====================================================

import bpy

def do_replace(oldpath, newpath):
    seq=bpy.data.scenes[0].sequence_editor.sequences_all

    for i in seq:
        if i.type == 'SOUND':
            if oldpath in i.sound.filepath:
                p = i.sound.filepath.replace(oldpath, newpath)
                print("Replacing %s to %s ..." % (i.sound.filepath, p))
                i.sound.filepath=p
        if i.type == 'MOVIE':
            if oldpath in i.filepath:
                p = i.filepath.replace(oldpath, newpath)
                print("Replacing %s to %s ..." % (i.filepath, p))
                i.filepath=p
        if i.type=='IMAGE':
            if oldpath in i.directory:
                p = i.directory.replace(oldpath, newpath)
                print("Replacing %s to %s ..." % (i.directory, p))
                i.directory=p
            for j in i.elements:
                if oldpath in j.filename:
                    p = j.filename.replace(oldpath, newpath)
                    print("Replacing %s to %s ..." % (j.filename, p))
                    j.filename=p


do_replace(oldpath, newpath)
