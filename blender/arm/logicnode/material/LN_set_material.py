import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class SetMaterialNode(ArmLogicTreeNode):
    """Set material node"""
    bl_idname = 'LNSetMaterialNode'
    bl_label = 'Set Material'
    bl_icon = 'NONE'

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmNodeSocketObject', 'Object')
        self.add_input('NodeSocketShader', 'Material')
        self.add_output('ArmNodeSocketAction', 'Out')

add_node(SetMaterialNode, category=MODULE_AS_CATEGORY)
