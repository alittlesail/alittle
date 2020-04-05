{
if (typeof JavaScript === "undefined") JavaScript = {};


if (ALittle.IDisplayObject === undefined) throw new Error(" extends class:ALittle.IDisplayObject is undefined");
JavaScript.JDisplayObject = JavaScript.Class(ALittle.IDisplayObject, {
	Ctor : function() {
		this._scale = new PIXI.Point(1, 1);
		this._pivot = new PIXI.Point(0, 0);
		this._clip = false;
		this._visible = true;
	},
	get native() {
		return this._native;
	},
	SetX : function(value) {
		this._native.x = value;
	},
	SetY : function(value) {
		this._native.y = value;
	},
	SetScaleX : function(value) {
		this._scale.x = value;
		this._native.scale = this._scale;
	},
	SetScaleY : function(value) {
		this._scale.y = value;
		this._native.scale = this._scale;
	},
	SetCenterX : function(value) {
		this._pivot.x = value;
		this._native.pivot = this._pivot;
	},
	SetCenterY : function(value) {
		this._pivot.y = value;
		this._native.pivot = this._pivot;
	},
	SetAngle : function(value) {
		this._native.rotation = value;
	},
	SetWidth : function(value) {
		this._native.width = value;
	},
	SetHeight : function(value) {
		this._native.height = value;
	},
	SetVisible : function(value) {
		this._visible = value;
		this._native.visible = value && !this._clip;
	},
	SetClip : function(value) {
		this._clip = value;
		this._native.visible = value && this._visible;
	},
	SetAlpha : function(value) {
		this._native.alpha = value;
	},
	SetRed : function(value) {
	},
	SetGreen : function(value) {
	},
	SetBlue : function(value) {
	},
	RemoveChild : function(value) {
	},
	AddChild : function(value) {
	},
	AddChildBefore : function(value1, value2) {
	},
	RemoveAllChild : function() {
	},
	SetFont : function(path, size) {
	},
	ClearTexture : function() {
	},
	SetTexture : function(texture) {
	},
	SetTextureCoord : function(t, b, l, r) {
	},
	SetFlip : function(value) {
	},
	SetRowColCount : function(row_count, col_count) {
	},
	SetRowColIndex : function(row, col) {
	},
	NeedDraw : function() {
	},
	SetText : function(value) {
	},
	SetBold : function(value) {
	},
	SetItalic : function(value) {
	},
	SetUnderline : function(value) {
	},
	SetDeleteline : function(value) {
	},
	SetOutline : function(value) {
	},
	GetRealWidth : function() {
		return 0;
	},
	GetRealHeight : function() {
		return 0;
	},
	GetFontHeight : function() {
		return 0;
	},
	SetHAlign : function(value) {
	},
	SetVAlign : function(value) {
	},
	SetCursorAlpha : function(value) {
	},
	GetLineWidth : function(value) {
		return 0;
	},
	GetLineCount : function() {
		return 0;
	},
	GetScrollOffset : function() {
		return 0;
	},
	IsDefaultText : function() {
		return false;
	},
	SetDefaultText : function(defaultv, value) {
	},
	SetDefaultTextAlpha : function(value) {
	},
	GetCursorX : function() {
		return 0;
	},
	GetCursorY : function() {
		return 0;
	},
	GetText : function() {
		return undefined;
	},
	SetCursorToEnd : function() {
	},
	SetCursorToHome : function() {
	},
	ShowCursor : function(value) {
	},
	ClickCursor : function(x, y) {
	},
	ClickWordCursor : function(x, y) {
		return false;
	},
	SelectAll : function() {
	},
	GetSelectText : function() {
		return undefined;
	},
	InsertText : function(value) {
		return false;
	},
	CursorOffsetLR : function(value) {
	},
	SelectCursorOffsetLR : function(value) {
	},
	CursorOffsetUD : function(value) {
	},
	SelectCursorOffsetUD : function(value) {
	},
	DeleteText : function(value) {
		return false;
	},
	DeleteSelectText : function() {
		return false;
	},
	DragCursorBegin : function() {
	},
	DragCursor : function(x, y) {
	},
	SetCursorRed : function(value) {
	},
	SetCursorGreen : function(value) {
	},
	SetCursorBlue : function(value) {
	},
	SetPasswordMode : function(value) {
	},
	CursorOffset : function(value) {
	},
	SelectCursorOffset : function(value) {
	},
	SetTexUV : function(index, u, v) {
	},
	SetPosXY : function(index, x, y) {
	},
	SetLeftSize : function(value) {
	},
	SetRightSize : function(value) {
	},
	SetTopSize : function(value) {
	},
	SetBottomSize : function(value) {
	},
	CutTextByWidth : function(remain_width, text, total_width) {
		return 0;
	},
	ClearCutWidthCache : function() {
	},
	GetCutWidthListCount : function() {
		return 0;
	},
	GetCutWidthByIndex : function(index) {
		return 0;
	},
	CalcTextWidth : function(value) {
		return 0;
	},
}, "JavaScript.JDisplayObject");

if (JavaScript.JDisplayObject === undefined) throw new Error(" extends class:JavaScript.JDisplayObject is undefined");
JavaScript.JDisplayObjects = JavaScript.Class(JavaScript.JDisplayObject, {
	Ctor : function() {
		this._native = new PIXI.Container();
	},
	RemoveChild : function(value) {
		this._native.removeChild(value._native);
	},
	AddChild : function(value) {
		this._native.addChild(value._native);
	},
	AddChildBefore : function(back, value) {
		let index = this._native.getChildAt(value._native);
		this._native.addChildAt(value._native, index - 1);
	},
	RemoveAllChild : function() {
		this._native.removeChildren(0);
	},
}, "JavaScript.JDisplayObjects");

if (ALittle.IDisplaySystem === undefined) throw new Error(" extends class:ALittle.IDisplaySystem is undefined");
JavaScript.JDisplaySystem = JavaScript.Class(ALittle.IDisplaySystem, {
	Ctor : function() {
		this._layer = new PIXI.Container();
		this._special_layer = new PIXI.Container();
	},
	AddToStage : function(stage) {
		this._layer.width = stage.width;
		this._layer.height = stage.height;
		this._special_layer.width = stage.width;
		this._special_layer.height = stage.height;
		stage.addChild(this._layer);
		stage.addChild(this._special_layer);
	},
	AddSpecialChild : function(value) {
		this._special_layer.addChild(value.native);
	},
	AddChild : function(value) {
		this._layer.addChild(value.native);
	},
	AddChildBefore : function(back, value) {
		let index = this._layer.getChildAt(value.native);
		this._layer.addChildAt(value.native, index - 1);
	},
	RemoveChild : function(value) {
		this._layer.removeChild(value.native);
	},
	RemoveAllChild : function() {
		this._layer.removeChildren(0);
		this._special_layer.removeChildren(0);
	},
}, "JavaScript.JDisplaySystem");

window.A_JDisplaySystem = ALittle.NewObject(JavaScript.JDisplaySystem);
if (JavaScript.JDisplayObject === undefined) throw new Error(" extends class:JavaScript.JDisplayObject is undefined");
JavaScript.JQuad = JavaScript.Class(JavaScript.JDisplayObject, {
	Ctor : function() {
		this._native = new PIXI.Graphics();
		this._red = 255;
		this._green = 255;
		this._blue = 255;
		this._color = this._red * 65536 + this._green * 256 + this._blue;
		this._alpha = 1;
		this._width = 0;
		this._height = 0;
	},
	Draw : function() {
		this._native.clear();
		this._native.beginFill(this._color, this._alpha);
		this._native.drawRect(0, 0, this._width, this._height);
		this._native.endFill();
	},
	SetWidth : function(value) {
		this._width = value;
		this.Draw();
	},
	SetHeight : function(value) {
		this._height = value;
		this.Draw();
	},
	SetRed : function(value) {
		this._red = Math.floor(value * 255);
		this._color = this._red * 65536 + this._green * 256 + this._blue;
		this.Draw();
	},
	SetGreen : function(value) {
		this._green = Math.floor(value * 255);
		this._color = this._red * 65536 + this._green * 256 + this._blue;
		this.Draw();
	},
	SetBlue : function(value) {
		this._blue = Math.floor(value * 255);
		this._color = this._red * 65536 + this._green * 256 + this._blue;
		this.Draw();
	},
	SetAlpha : function(value) {
		this._alpha = value;
		this.Draw();
	},
}, "JavaScript.JQuad");

if (JavaScript.JDisplayObject === undefined) throw new Error(" extends class:JavaScript.JDisplayObject is undefined");
JavaScript.JImage = JavaScript.Class(JavaScript.JDisplayObject, {
	Ctor : function() {
		this._native = new PIXI.Sprite();
	},
	ClearTexture : function() {
		this._native.texture = undefined;
	},
	SetTexture : function(texture) {
		this._native.texture = texture.native;
	},
	SetTextureCoord : function(t, b, l, r) {
	},
}, "JavaScript.JImage");

if (JavaScript.JDisplayObject === undefined) throw new Error(" extends class:JavaScript.JDisplayObject is undefined");
JavaScript.JGrid9Image = JavaScript.Class(JavaScript.JDisplayObject, {
	Ctor : function() {
		this._native = new PIXI.Sprite();
	},
	ClearTexture : function() {
		this._native.texture = undefined;
	},
	SetTexture : function(texture) {
		this._native.texture = texture.native;
	},
	SetTextureCoord : function(t, b, l, r) {
	},
	SetLeftSize : function(value) {
	},
	SetRightSize : function(value) {
	},
	SetTopSize : function(value) {
	},
	SetBottomSize : function(value) {
	},
}, "JavaScript.JGrid9Image");

if (JavaScript.JDisplayObject === undefined) throw new Error(" extends class:JavaScript.JDisplayObject is undefined");
JavaScript.JText = JavaScript.Class(JavaScript.JDisplayObject, {
	Ctor : function() {
		this._native = new PIXI.Text();
		this._style = new PIXI.TextStyle();
		this._real_width = 0;
		this._real_height = 0;
		this._red = 255;
		this._green = 255;
		this._blue = 255;
		this._style.fill = "#" + ((this._red * 65536 + this._green * 256 + this._blue).toString(16));
		this._text = "";
	},
	SetText : function(value) {
		this._text = value;
		this._native.text = value;
		let m = PIXI.TextMetrics.measureText(this._text, this._style);
		this._real_width = m.width;
		this._real_height = m.height;
	},
	SetFont : function(path, size) {
		this._style.fontFamily = path;
		this._style.fontSize = size;
		this._native.style = this._style;
		let m = PIXI.TextMetrics.measureText(this._text, this._style);
		this._real_width = m.width;
		this._real_height = m.height;
	},
	SetRed : function(value) {
		this._red = Math.floor(value * 255);
		this._style.fill = "#" + ((this._red * 65536 + this._green * 256 + this._blue).toString(16));
		this._native.style = this._style;
	},
	SetGreen : function(value) {
		this._green = Math.floor(value * 255);
		this._style.fill = "#" + ((this._red * 65536 + this._green * 256 + this._blue).toString(16));
		this._native.style = this._style;
	},
	SetBlue : function(value) {
		this._blue = Math.floor(value * 255);
		this._style.fill = "#" + ((this._red * 65536 + this._green * 256 + this._blue).toString(16));
		this._native.style = this._style;
	},
	GetRealWidth : function() {
		return this._real_width;
	},
	GetRealHeight : function() {
		return this._real_height;
	},
}, "JavaScript.JText");

let __TEXTURELOADER_MAXID = 0;
if (ALittle.ITexture === undefined) throw new Error(" extends class:ALittle.ITexture is undefined");
JavaScript.JTexture = JavaScript.Class(ALittle.ITexture, {
	Ctor : function(texture, width, height) {
		this._texture = texture;
		this._width = width;
		this._height = height;
	},
	Clear : function() {
		this._texture = undefined;
	},
	get native() {
		return this._texture;
	},
	GetTexture : function() {
		return this;
	},
	GetWidth : function() {
		return 0;
	},
	GetHeight : function() {
		return 0;
	},
}, "JavaScript.JTexture");

if (ALittle.ITextureLoader === undefined) throw new Error(" extends class:ALittle.ITextureLoader is undefined");
JavaScript.JTextureLoader = JavaScript.Class(ALittle.ITextureLoader, {
	Ctor : function() {
		++ __TEXTURELOADER_MAXID;
		this._id = __TEXTURELOADER_MAXID;
		this._load_failed = false;
	},
	SetPath : function(big_path, altas, big_width, big_height, crypt_mode) {
		this._file_path = big_path;
		this._atlas_info = altas;
		this._width = big_width;
		this._height = big_height;
		this._altas = altas;
	},
	Start : function() {
		let real_path = undefined;
		let altas_list = ALittle.String_Split(this._altas, ";");
		let ___OBJECT_1 = altas_list;
		for (let index = 1; index <= ___OBJECT_1.length; ++index) {
			let altas = ___OBJECT_1[index - 1];
			if (altas === undefined) break;
			let split = ALittle.String_Split(altas, ",");
			if (split[1 - 1] !== undefined) {
				real_path = split[1 - 1];
			}
		}
		if (real_path === undefined) {
			this.HandleLoadFailed();
			return;
		}
		let loader = new PIXI.Loader();
		loader.onError.add(this.HandleLoadFailed.bind(this));
		loader.add(this._file_path, real_path).load(this.HandleLoadSucceed.bind(this));
	},
	GetID : function() {
		return this._id;
	},
	GetPath : function() {
		return this._file_path;
	},
	HandleLoadSucceed : function(loader, resources) {
		if (this._load_failed) {
			return;
		}
		let resource = resources[this._file_path];
		if (resource === undefined || resource.texture === undefined) {
			this.HandleLoadFailed();
			return;
		}
		let func = window["__ALITTLEAPI_TextureLoadSucceed"];
		if (func === undefined) {
			return;
		}
		func(this, ALittle.NewObject(JavaScript.JTexture, resource.texture, this._width, this._height));
	},
	HandleLoadFailed : function() {
		if (this._load_failed) {
			return;
		}
		this._load_failed = true;
		let func = window["__ALITTLEAPI_TextureLoadFailed"];
		if (func === undefined) {
			return;
		}
		func(this);
	},
}, "JavaScript.JTextureLoader");

if (ALittle.ITextureCutLoader === undefined) throw new Error(" extends class:ALittle.ITextureCutLoader is undefined");
JavaScript.JTextureCutLoader = JavaScript.Class(ALittle.ITextureCutLoader, {
	Ctor : function() {
		++ __TEXTURELOADER_MAXID;
		this._id = __TEXTURELOADER_MAXID;
	},
	SetPath : function(path, max_width, max_height) {
	},
	Start : function() {
	},
	GetID : function() {
		return this._id;
	},
	GetPath : function() {
		return undefined;
	},
	GetMaxWidth : function() {
		return undefined;
	},
	GetMaxHeight : function() {
		return undefined;
	},
}, "JavaScript.JTextureCutLoader");

}