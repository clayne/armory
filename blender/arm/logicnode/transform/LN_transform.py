import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class TransformNode(ArmLogicTreeNode):
    """Transform node"""
    bl_idname = 'LNTransformNode'
    bl_label = 'Transform'
    bl_icon = 'NONE'

    def init(self, context):
        self.add_input('NodeSocketVector', 'Location')
        self.add_input('NodeSocketVector', 'Rotation')
        self.add_input('NodeSocketVector', 'Scale', default_value=[1.0, 1.0, 1.0])
        self.add_output('NodeSocketShader', 'Transform')

add_node(TransformNode, category=MODULE_AS_CATEGORY)
