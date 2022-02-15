strip = bpy.context.active_sequence_strip
frame = bpy.context.scene.frame_current - strip.frame_start
bpy.context.window.scene= strip.scene
bpy.ops.gpencil.paintmode_toggle()
bpy.context.scene.frame_set(frame) 
