import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class ExpressionNode(ArmLogicTreeNode):
    """Expression node"""
    bl_idname = 'LNExpressionNode'
    bl_label = 'Expression'
    bl_icon = 'NONE'

    property0: StringProperty(name='', default='')

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_output('ArmNodeSocketAction', 'Out')
        self.add_output('NodeSocketShader', 'Result')

    def draw_buttons(self, context, layout):
        layout.prop(self, 'property0')

add_node(ExpressionNode, category=MODULE_AS_CATEGORY, section='haxe')
