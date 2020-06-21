-- ALittle Generate Lua And Do Not Edit This Line!
module("AUIPlugin", package.seeall)

local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


assert(ALittle.Quad, " extends class:ALittle.Quad is nil")
AUICodeCursor = Lua.Class(ALittle.Quad, "AUIPlugin.AUICodeCursor")

function AUICodeCursor:Ctor(ctrl_sys, edit)
	___rawset(self, "_flash_alpha", 0)
	___rawset(self, "_flash_dir", 0.05)
	___rawset(self, "_it_line", 1)
	___rawset(self, "_it_char", 0)
	___rawset(self, "_edit", edit)
end

function AUICodeCursor.__getter:line()
	return self._it_line
end

function AUICodeCursor.__getter:char()
	return self._it_char
end

function AUICodeCursor:Show(x, y)
	if self._loop == nil then
		self._loop = ALittle.LoopFunction(Lua.Bind(self.Update, self), -1, 1, 1)
	end
	if not A_LoopSystem:HasUpdater(self._loop) then
		A_LoopSystem:AddUpdater(self._loop)
	end
	self.visible = true
end

function AUICodeCursor:CalcSelectWord()
	local line = self._edit.line_list[self._it_line]
	if line == nil then
		return nil, nil
	end
	local count = line.char_count
	while count > 0 and line.char_list[count].width <= 0 do
		count = count - 1
	end
	local it_end = self._it_char
	local i = self._it_char + 1
	while true do
		if not(i <= count) then break end
		local char = line.char_list[i].char
		local byte = ALittle.String_Byte(char, 1)
		local check = byte >= 65 and byte <= 90 or byte >= 97 and byte <= 122 or byte == 95
		if not check then
			break
		end
		it_end = i
		i = i+(1)
	end
	local it_start = self._it_char
	local i = self._it_char
	while true do
		if not(i >= 1) then break end
		local char = line.char_list[i].char
		local byte = ALittle.String_Byte(char, 1)
		local check = byte >= 65 and byte <= 90 or byte >= 97 and byte <= 122 or byte == 95
		it_start = i
		if not check then
			break
		end
		i = i+(-1)
	end
	if it_start == it_end then
		return nil, nil
	end
	return it_start, it_end
end

function AUICodeCursor:SetOffsetXY(x, y, show)
	if self._edit.line_count <= 0 then
		self._it_line = 1
		self._it_char = 0
	else
		self._it_line, self._it_char = self._edit:CalcLineAndChar(x, y)
	end
	self.y = (self._it_line - 1) * self._edit.line_height
	local line = self._edit.line_list[self._it_line]
	if line == nil or self._it_char == 0 then
		self.x = 0
	else
		local char = line.char_list[self._it_char]
		self.x = char.pre_width + char.width
	end
	if show == nil or show then
		self:Show()
	end
end

function AUICodeCursor:SetLineChar(it_line, it_char, show)
	self._it_line = it_line
	self._it_char = it_char
	self.y = (self._it_line - 1) * self._edit.line_height
	local line = self._edit.line_list[self._it_line]
	if line == nil or self._it_char <= 0 then
		self.x = 0
	else
		self.x = line.char_list[self._it_char].pre_width + line.char_list[self._it_char].width
	end
	if show == nil or show then
		self:Show()
	end
end

function AUICodeCursor:OffsetUp()
	if self._it_line <= 1 then
		return
	end
	local it_line = self._it_line - 1
	local line = self._edit.line_list[it_line]
	if line == nil then
		return
	end
	local it_char = line.char_count
	while it_char > 0 and line.char_list[it_char].width <= 0 do
		it_char = it_char - 1
	end
	if self._it_char < it_char then
		it_char = self._it_char
	end
	self:SetLineChar(it_line, it_char, false)
end

function AUICodeCursor:OffsetDown()
	if self._it_line >= self._edit.line_count then
		return
	end
	local it_line = self._it_line + 1
	local line = self._edit.line_list[it_line]
	if line == nil then
		return
	end
	local it_char = line.char_count
	while it_char > 0 and line.char_list[it_char].width <= 0 do
		it_char = it_char - 1
	end
	if self._it_char < it_char then
		it_char = self._it_char
	end
	self:SetLineChar(it_line, it_char, false)
end

function AUICodeCursor:OffsetLeft()
	if self._it_char > 0 then
		self:SetLineChar(self._it_line, self._it_char - 1, false)
		return
	end
	if self._it_line > 1 then
		local it_line = self._it_line - 1
		local line = self._edit.line_list[it_line]
		local it_char = line.char_count
		while it_char > 0 and line.char_list[it_char].width <= 0 do
			it_char = it_char - 1
		end
		self:SetLineChar(it_line, it_char, false)
		return
	end
	self:SetLineChar(1, 0, false)
end

function AUICodeCursor:OffsetRight()
	if self._edit.line_count <= 0 then
		return
	end
	local line = self._edit.line_list[self._it_line]
	local count = line.char_count
	while count > 0 and line.char_list[count].width <= 0 do
		count = count - 1
	end
	if self._it_char < count then
		self:SetLineChar(self._it_line, self._it_char + 1, false)
		return
	end
	if self._it_line >= self._edit.line_count then
		return
	end
	self:SetLineChar(self._it_line + 1, 0, false)
end

function AUICodeCursor:OffsetHome()
	if self._it_char <= 0 then
		return
	end
	local line = self._edit.line_list[self._it_line]
	if line == nil then
		return
	end
	local it_char = 1
	while it_char <= line.char_count do
		local char = line.char_list[it_char]
		if char.char ~= " " and char.char ~= "\t" then
			break
		end
		it_char = it_char + 1
	end
	if self._it_char == it_char - 1 then
		self:SetLineChar(self._it_line, 0, false)
	else
		self:SetLineChar(self._it_line, it_char - 1, false)
	end
end

function AUICodeCursor:OffsetEnd()
	local line = self._edit.line_list[self._it_line]
	if line == nil then
		return
	end
	local count = line.char_count
	while count > 0 and line.char_list[count].width <= 0 do
		count = count - 1
	end
	if self._it_char < count then
		self:SetLineChar(self._it_line, count, false)
	end
end

function AUICodeCursor:DeleteLeft()
	if self._it_char > 0 then
		local line = self._edit.line_list[self._it_line]
		if line == nil then
			return false
		end
		local char = line.char_list[self._it_char]
		if char.text ~= nil then
			line.container:RemoveChild(char.text)
		end
		line.char_count = line.char_count - (1)
		ALittle.List_Remove(line.char_list, self._it_char)
		local i = self._it_char
		while true do
			if not(i < line.char_count) then break end
			line.char_list[i].pre_width = line.char_list[i].pre_width - (char.width)
			if line.char_list[i].text ~= nil then
				line.char_list[i].text.x = line.char_list[i].text.x - (char.width)
			end
			i = i+(1)
		end
		self:SetLineChar(self._it_line, self._it_char - 1)
		local last_char = line.char_list[line.char_count]
		if last_char ~= nil then
			line.container.width = last_char.pre_width + last_char.width
		else
			line.container.width = 0
		end
		local rejust = true
		for index, line_info in ___ipairs(self._edit.line_list) do
			if line_info.container.width > line.container.width then
				rejust = false
				break
			end
		end
		if rejust then
			self._edit.container.width = line.container.width
			self._edit:RejustScrollBar()
		end
		return true
	end
	if self._it_line <= 1 then
		return false
	end
	local pre_line = self._edit.line_list[self._it_line - 1]
	if pre_line == nil then
		return false
	end
	local cur_line = self._edit.line_list[self._it_line]
	if cur_line == nil then
		return false
	end
	local it_char = pre_line.char_count
	while it_char > 0 and pre_line.char_list[it_char].width <= 0 do
		pre_line.char_count = pre_line.char_count - (1)
		pre_line.char_list[it_char] = nil
		it_char = it_char - (1)
	end
	local new_it_line = self._it_line - 1
	local new_it_char = it_char
	local pre_width = 0.0
	if pre_line.char_count > 0 then
		local last_char = pre_line.char_list[pre_line.char_count]
		pre_width = last_char.pre_width + last_char.width
	end
	local i = 1
	while true do
		if not(i <= cur_line.char_count) then break end
		local char = cur_line.char_list[i]
		char.pre_width = pre_width
		if char.text ~= nil then
			char.text.x = pre_width
			pre_line.container:AddChild(char.text)
		elseif char.width > 0 then
			pre_line.container:CreateAndAdd(char)
		end
		pre_width = pre_width + (char.width)
		pre_line.char_count = pre_line.char_count + (1)
		pre_line.char_list[pre_line.char_count] = char
		i = i+(1)
	end
	pre_line.container.width = pre_width
	self._edit.code_linear:RemoveChild(cur_line.container)
	self._edit.line_count = self._edit.line_count - (1)
	ALittle.List_Remove(self._edit.line_list, self._it_line)
	self:SetLineChar(new_it_line, new_it_char)
	if self._edit.container.width < pre_line.container.width then
		self._edit.container.width = pre_line.container.width
		self._edit:RejustScrollBar()
	end
	return true
end

function AUICodeCursor:DeleteRight()
	local line = self._edit.line_list[self._it_line]
	if line == nil then
		return false
	end
	local count = line.char_count
	while count > 0 and line.char_list[count].width <= 0 do
		count = count - 1
	end
	if self._it_char < count then
		local char = line.char_list[self._it_char + 1]
		if char.text ~= nil then
			line.container:RemoveChild(char.text)
		end
		line.char_count = line.char_count - (1)
		ALittle.List_Remove(line.char_list, self._it_char + 1)
		local i = self._it_char + 1
		while true do
			if not(i < line.char_count) then break end
			line.char_list[i].pre_width = line.char_list[i].pre_width - (char.width)
			if line.char_list[i].text ~= nil then
				line.char_list[i].text.x = line.char_list[i].text.x - (char.width)
			end
			i = i+(1)
		end
		self:SetLineChar(self._it_line, self._it_char)
		local last_char = line.char_list[line.char_count]
		if last_char ~= nil then
			line.container.width = last_char.pre_width + last_char.width
		else
			line.container.width = 0
		end
		local rejust = true
		for index, line_info in ___ipairs(self._edit.line_list) do
			if line_info.container.width > line.container.width then
				rejust = false
				break
			end
		end
		if rejust then
			self._edit.container.width = line.container.width
			self._edit:RejustScrollBar()
		end
		return true
	end
	if self._it_line >= self._edit.line_count then
		return false
	end
	local cur_line = line
	local next_line = self._edit.line_list[self._it_line + 1]
	if next_line == nil then
		return false
	end
	local it_char = cur_line.char_count
	while it_char > 0 and (cur_line.char_list[it_char].char == "\r" or cur_line.char_list[it_char].char == "\n") do
		cur_line.char_count = cur_line.char_count - (1)
		cur_line.char_list[it_char] = nil
		it_char = it_char - (1)
	end
	local new_it_line = self._it_line
	local new_it_char = it_char
	local pre_width = 0.0
	if cur_line.char_count > 0 then
		local last_char = cur_line.char_list[cur_line.char_count]
		pre_width = last_char.pre_width + last_char.width
	end
	local i = 1
	while true do
		if not(i <= next_line.char_count) then break end
		local char = next_line.char_list[i]
		char.pre_width = pre_width
		if char.text ~= nil then
			char.text.x = pre_width
			cur_line.container:AddChild(char.text)
		elseif char.width > 0 then
			cur_line.container:CreateAndAdd(char)
		end
		pre_width = pre_width + (char.width)
		cur_line.char_count = cur_line.char_count + (1)
		cur_line.char_list[cur_line.char_count] = char
		i = i+(1)
	end
	cur_line.container.width = pre_width
	self._edit.code_linear:RemoveChild(next_line.container)
	self._edit.line_count = self._edit.line_count - (1)
	ALittle.List_Remove(self._edit.line_list, self._it_line + 1)
	self:SetLineChar(new_it_line, new_it_char)
	if self._edit.container.width < cur_line.container.width then
		self._edit.container.width = cur_line.container.width
		self._edit:RejustScrollBar()
	end
	return true
end

function AUICodeCursor:Hide()
	if self._loop ~= nil then
		self._loop:Stop()
	end
	self.visible = false
end

function AUICodeCursor:Update()
	if self.abs_visible then
		self._flash_alpha = self._flash_alpha + self._flash_dir
		if (self._flash_dir < 0 and self._flash_alpha < -0.05) or (self._flash_dir > 0 and self._flash_alpha > 1.5) then
			self._flash_dir = -self._flash_dir
		end
		self.alpha = self._flash_alpha
	end
end
