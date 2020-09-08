import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class ResumeActionNode(ArmLogicTreeNode):
    """Resume action node"""
    bl_idname = 'LNResumeActionNode'
    bl_label = 'Resume Action'
    bl_icon = 'NONE'

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmNodeSocketObject', 'Object')
        self.add_output('ArmNodeSocketAction', 'Out')

add_node(ResumeActionNode, category=MODULE_AS_CATEGORY)
