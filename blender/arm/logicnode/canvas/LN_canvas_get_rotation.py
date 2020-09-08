import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class CanvasGetRotationNode(ArmLogicTreeNode):
    """Get canvas element rotation"""
    bl_idname = 'LNCanvasGetRotationNode'
    bl_label = 'Canvas Get Rotation'
    bl_icon = 'NONE'

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('NodeSocketString', 'Element')
        self.add_output('ArmNodeSocketAction', 'Out')
        self.add_output('NodeSocketFloat', 'Rad')

add_node(CanvasGetRotationNode, category=MODULE_AS_CATEGORY)
