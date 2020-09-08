import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket
from arm.logicnode.arm_nodes import *

class CallFunctionNode(ArmLogicTreeNode):
    """Call Haxe function node"""
    bl_idname = 'LNCallFunctionNode'
    bl_label = 'Call Function'
    bl_icon = 'NONE'
    min_inputs = 3

    def __init__(self):
        array_nodes[str(id(self))] = self

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('NodeSocketShader', 'Trait/Any')
        self.add_input('NodeSocketString', 'Function')
        self.add_output('ArmNodeSocketAction', 'Out')
        self.add_output('NodeSocketShader', 'Result')

    def draw_buttons(self, context, layout):
        row = layout.row(align=True)
        op = row.operator('arm.node_add_input', text='Add Arg', icon='PLUS', emboss=True)
        op.node_index = str(id(self))
        op.socket_type = 'NodeSocketShader'
        op.name_format = "Arg {0}"
        op.index_name_offset = -2
        op2 = row.operator('arm.node_remove_input', text='', icon='X', emboss=True)
        op2.node_index = str(id(self))

add_node(CallFunctionNode, category=MODULE_AS_CATEGORY, section='function')
