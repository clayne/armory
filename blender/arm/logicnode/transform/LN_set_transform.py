import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class SetTransformNode(ArmLogicTreeNode):
    """Set transform node"""
    bl_idname = 'LNSetTransformNode'
    bl_label = 'Set Transform'
    bl_icon = 'NONE'

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmNodeSocketObject', 'Object')
        self.add_input('NodeSocketShader', 'Transform')
        self.add_output('ArmNodeSocketAction', 'Out')

add_node(SetTransformNode, category=MODULE_AS_CATEGORY)
