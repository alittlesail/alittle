﻿
#ifndef _ALITTLE_ALITTLESCRIPTCLASSVARNAMEDECREFERENCE_H_
#define _ALITTLE_ALITTLESCRIPTCLASSVARNAMEDECREFERENCE_H_

#include "ALittleScriptReferenceTemplate.h"

#include "../Generate/ALittleScriptClassVarNameDecElement.h"

class ALittleScriptClassVarNameDecReference : public ALittleScriptReferenceTemplate<ALittleScriptClassVarNameDecElement>
{
public:
    ALittleScriptClassVarNameDecReference(ABnfElementPtr element) : ALittleScriptReferenceTemplate<ALittleScriptClassVarNameDecElement>(element) {}
    static ABnfReference* Create(ABnfElementPtr element) { return new ALittleScriptClassVarNameDecReference(element); }
    int QueryClassificationTag(bool& blur) override
    {
        blur = false;
        return ALittleScriptColorType::ALittleScriptVarName;
    }
};

#endif // _ALITTLE_ALITTLESCRIPTCLASSVARNAMEDECREFERENCE_H_