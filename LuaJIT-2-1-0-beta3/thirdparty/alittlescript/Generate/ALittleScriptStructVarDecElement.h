#ifndef _ALITTLE_ALittleScriptStructVarDecElement_H_
#define _ALITTLE_ALittleScriptStructVarDecElement_H_

#include <memory>
#include <vector>
#include <string>
#include "../../alanguage/Model/ABnfNodeElement.h"

class ALittleScriptAllTypeElement;
class ALittleScriptStructVarNameDecElement;
class ALittleScriptStringElement;

class ALittleScriptStructVarDecElement : public ABnfNodeElement
{
public:
    ALittleScriptStructVarDecElement(ABnfFactory* factory, ABnfFile* file, int line, int col, int offset, const std::string& type)
        : ABnfNodeElement(factory, file, line, col, offset, type) { }
    virtual ~ALittleScriptStructVarDecElement() { }

private:
    bool m_flag_AllType = false;
    std::shared_ptr<ALittleScriptAllTypeElement> m_cache_AllType;
public:
    std::shared_ptr<ALittleScriptAllTypeElement> GetAllType();
private:
    bool m_flag_StructVarNameDec = false;
    std::shared_ptr<ALittleScriptStructVarNameDecElement> m_cache_StructVarNameDec;
public:
    std::shared_ptr<ALittleScriptStructVarNameDecElement> GetStructVarNameDec();
private:
    bool m_flag_String = false;
    std::shared_ptr<ALittleScriptStringElement> m_cache_String;
public:
    std::shared_ptr<ALittleScriptStringElement> GetString();
};

#endif // _ALITTLE_ALittleScriptStructVarDecElement_H_
