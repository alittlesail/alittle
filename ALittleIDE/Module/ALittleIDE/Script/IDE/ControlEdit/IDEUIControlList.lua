-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ALittleIDE == nil then _G.ALittleIDE = {} end
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs
local ___all_struct = ALittle.GetAllStruct()

ALittle.RegStruct(-1807692147, "ALittleIDE.IDEControlFileSearchInfo", {
name = "ALittleIDE.IDEControlFileSearchInfo", ns_name = "ALittleIDE", rl_name = "IDEControlFileSearchInfo", hash_code = -1807692147,
name_list = {"list","count","index","name"},
type_list = {"List<ALittleIDE.IDEControlTreeLogic>","int","int","string"},
option_map = {}
})
ALittle.RegStruct(1715346212, "ALittle.Event", {
name = "ALittle.Event", ns_name = "ALittle", rl_name = "Event", hash_code = 1715346212,
name_list = {"target"},
type_list = {"ALittle.EventDispatcher"},
option_map = {}
})
ALittle.RegStruct(-427855371, "ALittleIDE.IDEControlModuleInfo", {
name = "ALittleIDE.IDEControlModuleInfo", ns_name = "ALittleIDE", rl_name = "IDEControlModuleInfo", hash_code = -427855371,
name_list = {"module_name","root_path"},
type_list = {"string","string"},
option_map = {}
})

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ALittleIDE.IDEUIControlList = Lua.Class(ALittle.DisplayLayout, "ALittleIDE.IDEUIControlList")

function ALittleIDE.IDEUIControlList:Ctor(ctrl_sys)
	___rawset(self, "_group", {})
end

function ALittleIDE.IDEUIControlList:TCtor()
	ALittleIDE.g_IDEProject:AddEventListener(___all_struct[-975432877], self, self.HandleProjectOpen)
	ALittleIDE.g_IDEProject:AddEventListener(___all_struct[-332308624], self, self.HandleProjectClose)
end

function ALittleIDE.IDEUIControlList:HandleProjectClose(event)
	self._control_scroll_screen:RemoveAllChild()
end

function ALittleIDE.IDEUIControlList:HandleProjectOpen(event)
	local module_map = ALittleIDE.g_IDEProject.project.config:GetConfig("control_module", {})
	module_map[event.name] = nil
	local ui = ALittleIDE.IDEUIManager(event.name)
	ALittleIDE.g_IDEProject.project.ui[event.name] = ui
	local info = {}
	info.ui = ui
	info.module_name = event.name
	info.name = "ui"
	info.path = ALittle.File_BaseFilePath() .. "Module/" .. event.name .. "/UI"
	info.module_path = ALittle.File_BaseFilePath() .. "Module/" .. event.name .. "/"
	info.group = self._group
	info.root = true
	self._control_scroll_screen:AddChild(ALittleIDE.IDEControlTree(ALittleIDE.g_Control, info))
	for index, module in ___pairs(module_map) do
		info = {}
		info.ui = ALittleIDE.IDEUIManager(module.module_name)
		info.module_name = module.module_name
		info.name = ALittle.File_GetFileNameByPath(module.root_path)
		info.path = module.root_path
		info.module_path = ALittle.File_GetFilePathByPath(module.root_path) .. "/"
		info.group = self._group
		info.root = true
		ALittleIDE.g_IDEProject.project.ui[module.module_name] = info.ui
		ui.control:RegisterPlugin(module.module_name, info.ui.control)
		local tree = ALittleIDE.IDEControlTree(ALittleIDE.g_Control, info)
		self._control_scroll_screen:AddChild(tree)
	end
end

function ALittleIDE.IDEUIControlList:GetControlTree(module)
	for index, child in ___ipairs(self._control_scroll_screen.childs) do
		if child.user_info.module_name == module then
			return child
		end
	end
	return nil
end

function ALittleIDE.IDEUIControlList.__getter:scroll_screen()
	return self._control_scroll_screen
end

function ALittleIDE.IDEUIControlList:AddModule(name)
	local ui_manager = ALittleIDE.g_IDEProject:GetUIManager(nil)
	if ui_manager == nil then
		return
	end
	for index, tree in ___ipairs(self._control_scroll_screen.childs) do
		if tree.user_info.module_name == name then
			return
		end
	end
	local module_map = ALittleIDE.g_IDEProject.project.config:GetConfig("control_module", {})
	local module_info = {}
	module_info.module_name = name
	module_info.root_path = ALittle.File_BaseFilePath() .. "Module/" .. name .. "/UI"
	module_map[name] = module_info
	ALittleIDE.g_IDEProject.project.config:SetConfig("control_module", module_map)
	local info = {}
	info.module_name = name
	info.name = "ui"
	info.path = module_info.root_path
	info.module_path = ALittle.File_BaseFilePath() .. "Module/" .. name .. "/"
	info.group = self._group
	info.root = true
	info.ui = ALittleIDE.IDEUIManager(name)
	ALittleIDE.g_IDEProject.project.ui[name] = info.ui
	ui_manager.control:RegisterPlugin(name, info.ui.control)
	local tree = ALittleIDE.IDEControlTree(ALittleIDE.g_Control, info)
	self._control_scroll_screen:AddChild(tree)
end

function ALittleIDE.IDEUIControlList:ShowTreeItemFocus(target)
	target:ShowSelect()
	if target ~= self._control_scroll_screen then
		local parent = target.logic_parent
		while parent ~= nil and parent ~= self._control_scroll_screen do
			parent.fold = true
			parent = parent.logic_parent
		end
	end
	self._control_scroll_screen:RejustScrollBar()
	local x, y = target:LocalToGlobal(self._control_scroll_screen.container)
	local target_x = (self._control_scroll_screen.view_width - target.width / 2) / 2 - x
	local target_y = (self._control_scroll_screen.view_height - target.height) / 2 - y
	if self._tree_loop_x ~= nil then
		self._tree_loop_x:Stop()
		self._tree_loop_x = nil
	end
	if self._tree_loop_y ~= nil then
		self._tree_loop_y:Stop()
		self._tree_loop_y = nil
	end
	self._tree_loop_x = ALittle.LoopLinear(self._control_scroll_screen, "container_x", target_x, 300, 0)
	self._tree_loop_x:Start()
	self._tree_loop_y = ALittle.LoopLinear(self._control_scroll_screen, "container_y", target_y, 300, 0)
	self._tree_loop_y:Start()
end

function ALittleIDE.IDEUIControlList:HandleControlSearchClick(event)
	if self._search_info == nil or self._search_info.name ~= self._control_search_key.text then
		self._search_info = {}
		self._search_info.name = self._control_search_key.text
		self._search_info.index = 0
		self._search_info.list = {}
		for index, child in ___ipairs(self._control_scroll_screen.childs) do
			child:SearchFile(self._search_info.name, self._search_info.list)
		end
		self._search_info.count = ALittle.List_MaxN(self._search_info.list)
	end
	if self._search_info.count <= 0 then
		return
	end
	self._search_info.index = self._search_info.index + (1)
	if self._search_info.index > self._search_info.count then
		self._search_info.index = 1
	end
	local item = self._search_info.list[self._search_info.index]
	self:ShowTreeItemFocus(item)
end

function ALittleIDE.IDEUIControlList:ShowNewControl()
	if ALittleIDE.g_IDEProject.project == nil then
		g_AUITool:ShowNotice("提示", "当前没有打开的项目")
		return
	end
	if self._control_new_dialog == nil then
		self._control_new_dialog = ALittleIDE.g_Control:CreateControl("ide_new_control_dialog", self)
		A_LayerManager:AddToModal(self._control_new_dialog)
		self._control_new_type.data_list = ALittleIDE.g_IDEEnum.child_type_list
	end
	local data_list = {}
	for name, ui in ___pairs(ALittleIDE.g_IDEProject.project.ui) do
		ALittle.List_Push(data_list, name)
	end
	self._control_new_module.data_list = data_list
	self._control_new_name.text = ""
	self._control_new_dialog.visible = true
	A_UISystem.focus = self._control_new_name.show_input
end

function ALittleIDE.IDEUIControlList:HandleNewControlCancel(event)
	self._control_new_dialog.visible = false
end

function ALittleIDE.IDEUIControlList:HandleNewControlConfirm(event)
	local project = ALittleIDE.g_IDEProject.project
	if project == nil then
		g_AUITool:ShowNotice("错误", "当前没有打开的项目")
		return
	end
	local name = self._control_new_name.text
	if name == "" then
		g_AUITool:ShowNotice("错误", "请输入控件名")
		return
	end
	if ALittleIDE.IDEUtility_CheckName(name) ~= nil then
		g_AUITool:ShowNotice("错误", "控件名不合法:" .. name)
		return
	end
	local ui_manager = project.ui[self._control_new_module.text]
	if ui_manager == nil then
		g_AUITool:ShowNotice("错误", "模块不存在")
		return
	end
	if ui_manager.control_map[name] ~= nil then
		g_AUITool:ShowNotice("错误", "控件已存在:" .. name)
		return
	end
	if ALittleIDE.g_IDECenter.center.content_edit:GetTabById(ALittleIDE.IDEUITabChild, name) ~= nil then
		g_AUITool:ShowNotice("错误", "控件名已存在:" .. name)
		return
	end
	local control_type = self._control_new_type.text
	if control_type == "" then
		g_AUITool:ShowNotice("错误", "请选择控件类型")
		return
	end
	ALittleIDE.g_IDECenter.center.content_edit:StartEditControlByNew(self._control_new_module.text, name, control_type)
	self._control_new_dialog.visible = false
end

end