-- ALittle Generate Lua And Do Not Edit This Line!
module("Lua", package.seeall)

local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


SocketStatus = {
	SS_IDLE = 0,
	SS_CONNECTING = 1,
	SS_CONNECTED = 2,
}

local __MAX_ID = 0
local __SOCKET_MAP = {}
ISocket = Lua.Class(nil, "Lua.ISocket")

function ISocket:Ctor(disconnected_callback)
	__MAX_ID = __MAX_ID + 1
	___rawset(self, "_id", __MAX_ID)
	___rawset(self, "_status", SocketStatus.SS_IDLE)
	___rawset(self, "_disconnected_callback", disconnected_callback)
	___rawset(self, "_socket", A_LuaSocketSchedule._socket)
end

function ISocket:IsConnected()
	return self._status == SocketStatus.SS_CONNECTED
end

function ISocket:IsConnecting()
	return self._status == SocketStatus.SS_CONNECTING
end

function ISocket:Connect(ip, port)
local ___COROUTINE = coroutine.running()
	if self:IsConnecting() then
		return "已经正在连接"
	end
	if self:IsConnected() then
		return "已经连接，请先关闭连接"
	end
	self._status = SocketStatus.SS_CONNECTING
	socket.connect(self._socket, self._id, ip, port)
	self._connect_thread = ___COROUTINE
	__SOCKET_MAP[self._id] = self
	return coroutine.yield()
end

function ISocket:Close()
	socket.close(self._socket, self._id)
	__SOCKET_MAP[self._id] = nil
	self._status = SocketStatus.SS_IDLE
	if self._connect_thread ~= nil then
		local result, error = ALittle.Coroutine.Resume(self._connect_thread, "closed")
		if result ~= true then
			ALittle.Error(error)
		end
		self._connect_thread = nil
	end
	if self._read_thread ~= nil then
		local result, error = ALittle.Coroutine.Resume(self._read_thread, "closed")
		if result ~= true then
			ALittle.Error(error)
		end
		self._read_thread = nil
	end
end

function ISocket.__setter:disconnect_callback(disconnected_callback)
	self._disconnected_callback = disconnected_callback
end

function ISocket:WriteMessage(full_name, protobuf_msg, protobuf_binary, protobuf_size)
	return "not implement"
end

function ISocket:ReadMessage()
local ___COROUTINE = coroutine.running()
	return "not implement", nil
end

function ISocket:HandleMessage(msg)
end

function ISocket:ReadStruct(T)
local ___COROUTINE = coroutine.running()
	local error, msg = self:ReadMessage()
	if error ~= nil then
		return error, nil
	end
	local content = protobuf.message_jsonencode(msg)
	local result, object = Lua.TCall(json.decode, content)
	if result ~= nil then
		return result, nil
	end
	return nil, object
end

function ISocket:ReadUint8()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readuint8(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadInt8()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readint8(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadUint16()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readuint16(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadInt16()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readint16(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadUint32()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readuint32(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadInt32()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readint32(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadUint64()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readuint64(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadInt64()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readint64(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadFloat()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readfloat(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadDouble()
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readdouble(self._socket, self._id)
	return coroutine.yield()
end

function ISocket:ReadBinary(len)
local ___COROUTINE = coroutine.running()
	if not self:IsConnected() then
		return "还未连接成功", 0
	end
	if self._read_thread ~= nil then
		return "已经正在读取", 0
	end
	self._read_thread = ___COROUTINE
	socket.readbinary(self._socket, self._id, len)
	return coroutine.yield()
end

function ISocket:ReadProtobuf(full_name, len)
local ___COROUTINE = coroutine.running()
	local error, binary_value = self:ReadBinary(len)
	if error ~= nil then
		return error, nil
	end
	local protobuf_msg = A_LuaSocketSchedule:CreateMessage(full_name)
	if protobuf_msg == nil then
		return "CreateMessage(" .. full_name .. ") failed", nil
	end
	if not protobuf.message_parsefromarray(protobuf_msg, binary_value, len) then
		return "message_parsefromarray failed, full_name:" .. full_name, nil
	end
	return nil, protobuf_msg
end

function ISocket:ReceiveMessage()
	while self:IsConnected() do
		local error, protobuf_msg = self:ReadMessage()
		if error ~= nil then
			ALittle.Log(error)
			break
		end
		self:HandleMessage(protobuf_msg)
	end
end
ISocket.ReceiveMessage = Lua.CoWrap(ISocket.ReceiveMessage)

function ISocket:WriteUint8(value)
	if not self:IsConnected() then
		return
	end
	socket.writeuint8(self._socket, self._id, value)
end

function ISocket:WriteInt8(value)
	if not self:IsConnected() then
		return
	end
	socket.writeint8(self._socket, self._id, value)
end

function ISocket:WriteUint16(value)
	if not self:IsConnected() then
		return
	end
	socket.writeuint16(self._socket, self._id, value)
end

function ISocket:WriteInt16(value)
	if not self:IsConnected() then
		return
	end
	socket.writeint16(self._socket, self._id, value)
end

function ISocket:WriteUint32(value)
	if not self:IsConnected() then
		return
	end
	socket.writeuint32(self._socket, self._id, value)
end

function ISocket:WriteInt32(value)
	if not self:IsConnected() then
		return
	end
	socket.writeint32(self._socket, self._id, value)
end

function ISocket:WriteUint64(value)
	if not self:IsConnected() then
		return
	end
	socket.writeuint64(self._socket, self._id, value)
end

function ISocket:WriteInt64(value)
	if not self:IsConnected() then
		return
	end
	socket.writeint64(self._socket, self._id, value)
end

function ISocket:WriteFloat(value)
	if not self:IsConnected() then
		return
	end
	socket.writefloat(self._socket, self._id, value)
end

function ISocket:WriteDouble(value)
	if not self:IsConnected() then
		return
	end
	socket.writedouble(self._socket, self._id, value)
end

function ISocket:WriteBinary(buffer, size)
	if not self:IsConnected() then
		return
	end
	socket.writebinary(self._socket, self._id, buffer, size)
end

function ISocket:SendMessage(msg)
	local descriptor = protobuf.message_getdescriptor(msg)
	local full_name = protobuf.messagedescriptor_fullname(descriptor)
	local msg_size = protobuf.message_getbytesize(msg)
	local binary_value = memory.create(msg_size)
	local error = nil
	local result = protobuf.message_serializetoarray(msg, binary_value, msg_size)
	if result then
		error = self:WriteMessage(full_name, msg, binary_value, msg_size)
	else
		error = "message_serializetoarray failed"
	end
	memory.free(binary_value)
	return error
end

function ISocket:SendStruct(T, full_name, msg)
	local protobuf_json = json.encode(msg)
	local protobuf_msg = A_LuaSocketSchedule:CreateMessage(full_name)
	if protobuf_msg == nil then
		return "CreateMessage failed"
	end
	local error = protobuf.message_jsondecode(protobuf_msg, protobuf_json)
	if error ~= nil then
		return error
	end
	local msg_size = protobuf.message_getbytesize(protobuf_msg)
	local binary_value = memory.create(msg_size)
	local result = protobuf.message_serializetoarray(protobuf_msg, binary_value, msg_size)
	if result then
		error = self:WriteMessage(full_name, protobuf_msg, binary_value, msg_size)
	else
		error = "message_serializetoarray failed"
	end
	memory.free(binary_value)
	return error
end

function ISocket.HandleConnectFailed(id)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	__SOCKET_MAP[id] = nil
	socket._status = SocketStatus.SS_IDLE
	local result, error = ALittle.Coroutine.Resume(socket._connect_thread, "connect failed")
	if result ~= true then
		ALittle.Error(error)
	end
	socket._connect_thread = nil
end

function ISocket.HandleConnectSucceed(id)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	socket._status = SocketStatus.SS_CONNECTED
	local result, error = ALittle.Coroutine.Resume(socket._connect_thread, nil)
	if result ~= true then
		ALittle.Error(error)
	end
	socket._connect_thread = nil
end

function ISocket.HandleDisconnected(id)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	__SOCKET_MAP[id] = nil
	socket._status = SocketStatus.SS_IDLE
	if socket._read_thread ~= nil then
		local result, error = ALittle.Coroutine.Resume(socket._read_thread, "disconnected")
		if result ~= true then
			ALittle.Error(error)
		end
		socket._read_thread = nil
	end
	if socket._disconnected_callback ~= nil then
		socket._disconnected_callback(socket)
	end
end

function ISocket.HandleReadInt(id, value)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	if socket._read_thread ~= nil then
		local thread = socket._read_thread
		socket._read_thread = nil
		local result, error = ALittle.Coroutine.Resume(thread, nil, value)
		if result ~= true then
			ALittle.Error(error)
		end
	end
end

function ISocket.HandleReadDouble(id, value)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	if socket._read_thread ~= nil then
		local thread = socket._read_thread
		socket._read_thread = nil
		local result, error = ALittle.Coroutine.Resume(thread, nil, value)
		if result ~= true then
			ALittle.Error(error)
		end
	end
end

function ISocket.HandleReadProtobuf(id, value)
	local socket = __SOCKET_MAP[id]
	if socket == nil then
		return
	end
	if socket._read_thread ~= nil then
		local thread = socket._read_thread
		socket._read_thread = nil
		local result, error = ALittle.Coroutine.Resume(thread, nil, value)
		if result ~= true then
			ALittle.Error(error)
		end
	end
end

