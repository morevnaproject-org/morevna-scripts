import bpy

def create_constraint(bone_name, target_bone_name, rig):
    bone = rig.pose.bones[bone_name]
    constraint = bone.constraints.new('COPY_TRANSFORMS')
    constraint.target = rig
    constraint.subtarget = target_bone_name
    rig.data.bones[bone_name].select = True
    return (bone_name, constraint)


# TODO: get if we have current action
# bpy.ops.nla.action_pushdown(channel_index=5)

#bpy.ops.action.copy()
#bpy.context.scene.objects.active.animation_data.action.fcurves[0].keyframe_points.select

# Enable layers
bpy.context.object.data.layers[2] = True
bpy.context.object.data.layers[18] = True
bpy.context.object.data.layers[1] = True
bpy.context.object.data.layers[17] = True
#bpy.context.object.data.layers[29] = True

rig = bpy.context.scene.objects.active

#if rig.animation_data != None :
#    rig.animation_data.action


for bone in rig.data.bones:
    bone.select = False
#   bpy.ops.armature.select_all(action='DESELECT')

const=[]
for suffix in [".L", ".R"]:
    const.append(create_constraint("upper_arm.fk"+suffix, "MCH-upper_arm.ik"+suffix, rig))
    const.append(create_constraint("forearm.fk"+suffix, "MCH-forearm.ik"+suffix, rig))
    const.append(create_constraint("hand.fk"+suffix, "hand.ik"+suffix, rig))

a=rig.animation_data.action

bpy.ops.nla.bake(frame_start=a.frame_range[0], frame_end=a.frame_range[1], only_selected=True, visual_keying=True, use_current_action=True)

# Remove constraints
for c in const:
    rig.pose.bones[c[0]].constraints.remove(c[1])

# Switch rig to FK
#bpy.context.object.pose.bones["hand.ik.R"]["fk_ik"] = 0
#bpy.context.object.pose.bones["hand.ik.L"]["fk_ik"] = 0