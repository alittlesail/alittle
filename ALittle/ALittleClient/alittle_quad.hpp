#ifndef ALITTLE_QUAD_INCLUDED
#define ALITTLE_QUAD_INCLUDED (1)

#include "alittle_texture.hpp"
#include "alittle_image.hpp"
#include "Carp/carp_surface.h"

extern ALittleSurfaceTexture* GetQuadTexture();
extern void ReleaseQuadTexture();

class ALittleQuad : public ALittleImage
{
public:
	ALittleQuad()
	{
		m_texture = GetQuadTexture();
		SetTextureCoord(0.1f, 0.9f, 0.1f, 0.9f);
	}
	~ALittleQuad()
	{
		ReleaseQuadTexture();
	}

	static void Bind(lua_State* l_state)
	{
		luabridge::getGlobalNamespace(l_state)
			.deriveClass<ALittleQuad, ALittleImage>("__CPPAPIQuad")
			.addConstructor<void(*)()>()
			.addFunction("SetX", &ALittleQuad::SetX)
			.addFunction("SetY", &ALittleQuad::SetY)
			.addFunction("SetWidth", &ALittleQuad::SetWidth)
			.addFunction("SetHeight", &ALittleQuad::SetHeight)
			.addFunction("SetScaleX", &ALittleQuad::SetScaleX)
			.addFunction("SetScaleY", &ALittleQuad::SetScaleY)
			.addFunction("SetCenterX", &ALittleQuad::SetCenterX)
			.addFunction("SetCenterY", &ALittleQuad::SetCenterY)
			.addFunction("SetAngle", &ALittleQuad::SetAngle)
			.addFunction("SetRed", &ALittleQuad::SetRed)
			.addFunction("SetGreen", &ALittleQuad::SetGreen)
			.addFunction("SetBlue", &ALittleQuad::SetBlue)
			.addFunction("SetAlpha", &ALittleQuad::SetAlpha)
			.addFunction("SetVisible", &ALittleQuad::SetVisible)
			.addFunction("SetClip", &ALittleQuad::SetClip)
			.endClass();
	}

#ifdef __EMSCRIPTEN__
	void SetX(float x) { ALittleImage::SetX(x); }
	void SetY(float y) { ALittleImage::SetY(y); }

	void SetWidth(float width) { ALittleImage::SetWidth(width); }
	void SetHeight(float height) { ALittleImage::SetHeight(height); }

	void SetAngle(float angle) { ALittleImage::SetAngle(angle); }

	void SetScaleX(float x) { ALittleImage::SetScaleX(x); }
	void SetScaleY(float y) { ALittleImage::SetScaleY(y); }

	void SetCenterX(float x) { ALittleImage::SetCenterX(x); }
	void SetCenterY(float y) { ALittleImage::SetCenterY(y); }

	void SetRed(float red) { ALittleImage::SetRed(red); }
	void SetGreen(float green) { ALittleImage::SetGreen(green); }
	void SetBlue(float blue) { ALittleImage::SetBlue(blue); }
	void SetAlpha(float alpha) { ALittleImage::SetAlpha(alpha); }

	void SetVisible(bool visible) { ALittleImage::SetVisible(visible); }
	void SetClip(bool clip) { ALittleImage::SetClip(clip); }
#endif
};

#endif

#ifdef ALITTLE_QUAD_IMPL
#ifndef ALITTLE_QUAD_IMPL_INCLUDE
#define ALITTLE_QUAD_IMPL_INCLUDE
struct QuadTextureInfo
{
	ALittleSurfaceTexture* texture = nullptr;
	int ref_count = 0;
};
QuadTextureInfo s_quad_texture_info;
ALittleSurfaceTexture* GetQuadTexture()
{
	if (s_quad_texture_info.texture)
	{
		s_quad_texture_info.ref_count++;
		return s_quad_texture_info.texture;
	}

	Carp_Surface* surface = Carp_CreateSurface(32, 32);
	if (surface == nullptr) return nullptr;

	for (int i = 0; i < 32; ++i)
		for (int j = 0; j < 32; ++j)
			Carp_SetSurfacePixel(surface, i, j, 0xFFFFFFFF);

	s_quad_texture_info.texture = new ALittleSurfaceTexture(surface);
	s_quad_texture_info.ref_count = 1;
	return s_quad_texture_info.texture;
}
void ReleaseQuadTexture()
{
	s_quad_texture_info.ref_count--;
	if (s_quad_texture_info.ref_count > 0) return;

	delete s_quad_texture_info.texture;
	s_quad_texture_info.texture = nullptr;
}
#endif
#endif