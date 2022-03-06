#===========  MODIFY PARAMETERS HERE =================

oldpath="//sound/track-1-cosh-man.wav"
newpath="//render/sound/voice-raw-1-cosh-man.flac.wav"

#=====================================================

import bpy

def do_replace(oldpath, newpath):
    seq=bpy.context.scene.sequence_editor.sequences_all

    for i in seq:
        _replace(i, oldpath, newpath)


def _replace(i, oldpath, newpath):
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
    if i.type == 'TEXT':
        if oldpath in i.font.filepath:
            p = i.font.filepath.replace(oldpath, newpath)
            print("Replacing %s to %s ..." % (i.font.filepath, p))
            i.font.filepath=p
    if i.type=='META':
        for j in i.sequences:
            _replace(j, oldpath, newpath)


do_replace(oldpath, newpath)
