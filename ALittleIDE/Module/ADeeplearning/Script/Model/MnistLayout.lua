-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs
local ___all_struct = ALittle.GetAllStruct()

ALittle.RegStruct(-1479093282, "ALittle.UIEvent", {
name = "ALittle.UIEvent", ns_name = "ALittle", rl_name = "UIEvent", hash_code = -1479093282,
name_list = {"target"},
type_list = {"ALittle.DisplayObject"},
option_map = {}
})
ALittle.RegStruct(958494922, "ALittle.UIChangedEvent", {
name = "ALittle.UIChangedEvent", ns_name = "ALittle", rl_name = "UIChangedEvent", hash_code = 958494922,
name_list = {"target"},
type_list = {"ALittle.DisplayObject"},
option_map = {}
})

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.MnistTrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.MnistTrainLayout")

function ADeeplearning.MnistTrainLayout:TCtor()
	self._model = deeplearning.DeeplearningMnistCNNModel()
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/mnist-cnn.model"
	self._model:SetTrainDataPath(ADeeplearning.g_ModuleBasePath .. "Data/train-images.idx3-ubyte", ADeeplearning.g_ModuleBasePath .. "Data/train-labels.idx1-ubyte")
end

function ADeeplearning.MnistTrainLayout.__getter:model()
	return self._model
end

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.MnistLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.MnistLayout")

function ADeeplearning.MnistLayout:Ctor()
	___rawset(self, "_loaded", false)
end

function ADeeplearning.MnistLayout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/mnist-cnn.model"
	self._model = deeplearning.DeeplearningMnistCNNModel()
	local load_path
	if ALittle.File_GetFileAttr(self._model_path) ~= nil then
		load_path = self._model_path
	end
	self._board:SetPan(5, 0xFFFFFFFF)
	self._board:SetDrawSize(ALittle.Math_Floor(self._board.width), ALittle.Math_Floor(self._board.height), 0xFF000000)
	self._result_text.text = "识别结果"
end

function ADeeplearning.MnistLayout:HandleTrainChanged(event)
	self._model:Load(self._model_path)
end

function ADeeplearning.MnistLayout:HandleDrawChanged(event)
	if deeplearning.GetNumberOfGraph() > 0 then
		g_AUITool:ShowNotice("提示", "当前有图正在计算，请稍后再试")
		return
	end
	if not self._loaded then
		self._model:Load(self._model_path)
		self._loaded = true
	end
	local address = carp.GetCarpSurfaceAddress(self._board.surface)
	local result = self._model:Output(address)
	self._result_text.text = "识别结果:" .. result
end

function ADeeplearning.MnistLayout:HandleClearClick(event)
	self._result_text.text = "识别结果"
	self._board:ClearContent(0xFF000000)
end

end