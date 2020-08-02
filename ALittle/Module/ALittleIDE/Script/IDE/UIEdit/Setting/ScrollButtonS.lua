-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ALittleIDE == nil then _G.ALittleIDE = {} end
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


assert(ALittleIDE.DisplayLayoutS, " extends class:ALittleIDE.DisplayLayoutS is nil")
ALittleIDE.ScrollButtonS = Lua.Class(ALittleIDE.DisplayLayoutS, "ALittleIDE.ScrollButtonS")

function ALittleIDE.ScrollButtonS:Ctor(user_info, tab_child, tree_logic)
	___rawset(self, "_layer_name", "ide_setting_scrollbutton")
end

function ALittleIDE.ScrollButtonS:LoadNatureBase()
	ALittleIDE.DisplayLayoutS.LoadNatureBase(self)
	self:LoadValueData("text")
	self:LoadShowTypeDataForImage("show_up")
	self:LoadShowTypeDataForImage("show_over")
	self:LoadShowTypeDataForImage("show_down")
	self:LoadShowTypeDataForImage("show_disabled")
end

function ALittleIDE.ScrollButtonS:HandleMTextFOCUSOUT(event)
	self:DefaultNoStringInputChange("text", false)
end

function ALittleIDE.ScrollButtonS:HandleShowUpFOCUSOUT(event)
	if event.target._user_data ~= nil then
		if event.target._user_data == event.target.text then
			return
		end
		event.target._user_data = event.target.text
	end
	self:RemoverToNilShowSetForImage("show_up", self._show_up.text, self._show_up_grid9.selected, false)
end

function ALittleIDE.ScrollButtonS:HandleShowUpSelect(event)
	ALittleIDE.g_IDEImageSelectDialog:SetBasePath(ALittleIDE.g_IDEProject.project.texture_path)
	local path = ALittleIDE.g_IDEImageSelectDialog:ShowSelect()
	if path == nil then
		return
	end
	self:ImagePathSelectCallback("show_up", self.HandleShowUpFOCUSOUT, nil, path)
end
ALittleIDE.ScrollButtonS.HandleShowUpSelect = Lua.CoWrap(ALittleIDE.ScrollButtonS.HandleShowUpSelect)

function ALittleIDE.ScrollButtonS:HandleShowOverFOCUSOUT(event)
	if event.target._user_data ~= nil then
		if event.target._user_data == event.target.text then
			return
		end
		event.target._user_data = event.target.text
	end
	self:RemoverToNilShowSetForImage("show_over", self._show_over.text, self._show_over_grid9.selected, false)
end

function ALittleIDE.ScrollButtonS:HandleShowOverSelect(event)
	ALittleIDE.g_IDEImageSelectDialog:SetBasePath(ALittleIDE.g_IDEProject.project.texture_path)
	local path = ALittleIDE.g_IDEImageSelectDialog:ShowSelect()
	if path == nil then
		return
	end
	self:ImagePathSelectCallback("show_over", self.HandleShowOverFOCUSOUT, nil, path)
end
ALittleIDE.ScrollButtonS.HandleShowOverSelect = Lua.CoWrap(ALittleIDE.ScrollButtonS.HandleShowOverSelect)

function ALittleIDE.ScrollButtonS:HandleShowDownFOCUSOUT(event)
	if event.target._user_data ~= nil then
		if event.target._user_data == event.target.text then
			return
		end
		event.target._user_data = event.target.text
	end
	self:RemoverToNilShowSetForImage("show_down", self._show_down.text, self._show_down_grid9.selected, false)
end

function ALittleIDE.ScrollButtonS:HandleShowDownSelect(event)
	ALittleIDE.g_IDEImageSelectDialog:SetBasePath(ALittleIDE.g_IDEProject.project.texture_path)
	local path = ALittleIDE.g_IDEImageSelectDialog:ShowSelect()
	if path == nil then
		return
	end
	self:ImagePathSelectCallback("show_down", self.HandleShowDownFOCUSOUT, nil, path)
end
ALittleIDE.ScrollButtonS.HandleShowDownSelect = Lua.CoWrap(ALittleIDE.ScrollButtonS.HandleShowDownSelect)

function ALittleIDE.ScrollButtonS:HandleShowDisabledFOCUSOUT(event)
	if event.target._user_data ~= nil then
		if event.target._user_data == event.target.text then
			return
		end
		event.target._user_data = event.target.text
	end
	self:RemoverToNilShowSetForImage("show_disabled", self._show_disabled.text, self._show_disabled_grid9.selected, false)
end

function ALittleIDE.ScrollButtonS:HandleShowDisabledSelect(event)
	ALittleIDE.g_IDEImageSelectDialog:SetBasePath(ALittleIDE.g_IDEProject.project.texture_path)
	local path = ALittleIDE.g_IDEImageSelectDialog:ShowSelect()
	if path == nil then
		return
	end
	self:ImagePathSelectCallback("show_disabled", self.HandleShowDisabledFOCUSOUT, nil, path)
end
ALittleIDE.ScrollButtonS.HandleShowDisabledSelect = Lua.CoWrap(ALittleIDE.ScrollButtonS.HandleShowDisabledSelect)

function ALittleIDE.ScrollButtonS:HandleShowTextFOCUSOUT(event)
	ALittleIDE.g_IDEAttrTextDialog:ShowDialog(self, "show_text", false)
end

function ALittleIDE.ScrollButtonS:HandleShowOverTextFOCUSOUT(event)
	ALittleIDE.g_IDEAttrTextDialog:ShowDialog(self, "show_over_text", false)
end

function ALittleIDE.ScrollButtonS:HandleShowDownTextFOCUSOUT(event)
	ALittleIDE.g_IDEAttrTextDialog:ShowDialog(self, "show_down_text", false)
end

function ALittleIDE.ScrollButtonS:HandleShowDisabledTextFOCUSOUT(event)
	ALittleIDE.g_IDEAttrTextDialog:ShowDialog(self, "show_disabled_text", false)
end

end