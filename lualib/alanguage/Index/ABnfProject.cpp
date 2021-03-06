﻿
#include "ABnfProject.h"
#include "ABnfFactory.h"
#include "ABnfFile.h"
#include "../Model/ABnfRuleInfo.h"

void ABnfProject::Start(const std::string& abnf_buffer)
{
	std::string error;
    m_abnf.Load(abnf_buffer, &RefFactory(), error);
	m_abnf_ui.Load(abnf_buffer, &RefFactory(), error);

	if (m_thread == nullptr)
	{
		// 设置为继续执行
		m_run = true;
		// 创建线程，并开始执行
		m_thread = new std::thread(ABnfProject::Run, this);
	}
}

void ABnfProject::Stop()
{
    if (m_thread != nullptr)
    {
        // 解开锁
        {
            std::unique_lock<std::mutex> lock(m_input_lock);
            m_run = false;
            m_cv.notify_all();
        }
        // 等待线程正常结束
        m_thread->join();
        // 删除线程对象
        delete m_thread;
        m_thread = nullptr;

        // 开始执行
        while (!m_inputs.empty())
        {
            m_inputs.front()();
            m_inputs.pop_front();
        }
    }

    for (auto& pair : m_file_map)
        delete pair.second;
    m_file_map.clear();

    ClearImpl();
}

int ABnfProject::PollOne(lua_State* L)
{
    std::unique_lock<std::mutex> lock(m_output_lock);

    if (m_outputs.empty())
    {
        lua_pushnil(L);
        return 1;
    }
     
    const int result = m_outputs.front()(L);
    m_outputs.pop_front();
    return result;
}

// 添加
void ABnfProject::Add(const std::function<void()>& fun)
{
    if (m_thread == nullptr) return;

    // 把日志添加到列表
    std::unique_lock<std::mutex> lock(m_input_lock);
    m_inputs.emplace_back(std::move(fun));
    m_cv.notify_one();
}

int ABnfProject::QueryRuleColor(lua_State* L) const
{
    lua_newtable(L);
    for (const auto& pair : m_abnf_ui.GetRuleSet())
    {
        if (!pair.second->has_color) continue;
        lua_newtable(L);
        lua_pushnumber(L, pair.second->red / 255.0);
        lua_setfield(L, -2, "red");
        lua_pushnumber(L, pair.second->green / 255.0);
        lua_setfield(L, -2, "green");
        lua_pushnumber(L, pair.second->blue / 255.0);
        lua_setfield(L, -2, "blue");

        lua_rawseti(L, -2, pair.second->rule_id);
    }
    return 1;
}

ABnfFile* ABnfProject::GetFile(const std::string& full_path)
{
    const auto it = m_file_map.find(full_path);
    if (it == m_file_map.end()) return nullptr;
    return it->second;
}

void ABnfProject::UpdateFile(const std::string& module_path, const std::string& full_path, int version)
{
    if (!m_run) return;

    // 打开文件
    FILE* file = nullptr;
#ifdef _WIN32
    fopen_s(&file, full_path.c_str(), "rb");
#else
    file = fopen(full_path.c_str(), "rb");
#endif
    if (file == nullptr) return;

    std::vector<char> out;
    char buffer[1024];
    while (true)
    {
        const size_t read_size = fread(buffer, 1, sizeof(buffer), file);
        if (read_size == 0) break;
        for (size_t i = 0; i < read_size; ++i)
            out.push_back(buffer[i]);
    }

    fclose(file);

    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end())
    {
        auto* abnf_file = RefFactory().CreateFile(this, module_path, full_path, out.data(), out.size());
        m_file_map[full_path] = abnf_file;
        abnf_file->AnalysisText(version);
    }
    else
    {
        it->second->SetText(out.data(), out.size());
        it->second->AnalysisText(version);
    }
}

void ABnfProject::TempFile(const std::string& module_path, const std::string& full_path, const std::string& text, int version)
{
    if (!m_run) return;

    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end())
    {
        const auto file = RefFactory().CreateFile(this, module_path, full_path, text.data(), text.size());
        m_file_map[full_path] = file;
        file->AnalysisText(version);
    }
    else
    {
        it->second->SetText(text.data(), text.size());
        it->second->AnalysisText(version);
    }
}

void ABnfProject::RemoveFile(const std::string& full_path)
{
    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end()) return;

    it->second->OnRemove();
    delete it->second;
    m_file_map.erase(it);
}

void ABnfProject::FindFile(int query_id, const std::string& text)
{
    std::vector<std::string> file_list;
    for (auto& pair : m_file_map)
    {
        if (pair.second->ContainText(text))
            file_list.push_back(pair.first);
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id, file_list](lua_State* L)->int
    {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        {
            lua_newtable(L);
            for (size_t i = 0; i < file_list.size(); ++i)
            {
                lua_pushstring(L, file_list[i].c_str());
                lua_rawseti(L, -2, static_cast<int>(i) + 1);
            }
        }
        lua_setfield(L, -2, "result");
        return 1;
    });
}

void ABnfProject::FindDefine(int query_id, const std::string& pre_input, const std::string& input)
{
    std::vector<ALanguageCompletionInfo> info_list;
    FindDefineImpl(pre_input, input, info_list);

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id, info_list](lua_State* L)->int
    {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");

        lua_newtable(L);
        for (size_t i = 0; i < info_list.size(); ++i)
        {
            const auto& complete = info_list[i];

            lua_newtable(L);
            lua_pushstring(L, complete.display.c_str());
            lua_setfield(L, -2, "display");
            if (!complete.insert.empty())
            {
                lua_pushstring(L, complete.insert.c_str());
                lua_setfield(L, -2, "insert");
            }
            if (!complete.descriptor.empty())
            {
                lua_pushstring(L, complete.descriptor.c_str());
                lua_setfield(L, -2, "descriptor");
            }
            lua_pushinteger(L, complete.tag);
            lua_setfield(L, -2, "tag");
        	
            lua_rawseti(L, -2, static_cast<int>(i) + 1);
        }
        lua_setfield(L, -2, "result");
        return 1;
    });
}

void ABnfProject::FindGoto(int query_id, const std::string& text)
{
    ALanguageGotoInfo info;
    FindGotoImpl(text, info);

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id, info](lua_State* L)->int
    {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");

        lua_newtable(L);
        lua_pushinteger(L, info.line_start + 1);
        lua_setfield(L, -2, "line_start");
        lua_pushinteger(L, info.char_start + 1);
        lua_setfield(L, -2, "char_start");
        lua_pushinteger(L, info.line_end + 1);
        lua_setfield(L, -2, "line_end");
        lua_pushinteger(L, info.char_end);
        lua_setfield(L, -2, "char_end");
        lua_pushstring(L, info.file_path.c_str());
        lua_setfield(L, -2, "file_path");
    	
        lua_setfield(L, -2, "result");
        return 1;
    });
}

void ABnfProject::UpdateText(const std::string& full_path, int version, const std::string& text)
{
    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end()) return;

    it->second->SetText(text.c_str(), text.size());
    it->second->AnalysisText(version);
}

void ABnfProject::InsertText(const std::string& full_path, int version, const std::string& text, int it_line, int it_char)
{
    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end()) return;

    it->second->InsertText(text.c_str(), text.size(), it_line, it_char);
    it->second->AnalysisText(version);
}

void ABnfProject::DeleteText(const std::string& full_path, int version, int it_line_start, int it_char_start, int it_line_end, int it_char_end)
{
    auto it = m_file_map.find(full_path);
    if (it == m_file_map.end()) return;

    it->second->DeleteText(it_line_start, it_char_start, it_line_end, it_char_end);
    it->second->AnalysisText(version);
}

void ABnfProject::QueryColor(const std::string& full_path, int query_id, int version, int line)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        const auto* list = it->second->QueryColor(version, line);
        if (list != nullptr)
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, temp = *list](lua_State* L)->int
            {
                lua_newtable(L);
                lua_pushinteger(L, query_id);
                lua_setfield(L, -2, "query_id");
                {
                    lua_newtable(L);
                    for (size_t i = 0; i < temp.size(); ++i)
                    {
                        auto& color = temp[i];
                        lua_newtable(L);
                        lua_pushinteger(L, color.line_start + 1);
                        lua_setfield(L, -2, "line_start");
                        lua_pushinteger(L, color.char_start + 1);
                        lua_setfield(L, -2, "char_start");
                        lua_pushinteger(L, color.line_end + 1);
                        lua_setfield(L, -2, "line_end");
                        lua_pushinteger(L, color.char_end);
                        lua_setfield(L, -2, "char_end");
                        lua_pushinteger(L, color.tag);
                        lua_setfield(L, -2, "tag");
                        lua_pushboolean(L, color.blur ? 1 : 0);
                        lua_setfield(L, -2, "blur");
                        lua_rawseti(L, -2, static_cast<int>(i) + 1);
                    }
                }
                lua_setfield(L, -2, "result");
                return 1;
            });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
    });
}

void ABnfProject::QueryInfo(const std::string& full_path, int query_id, int version, int it_line, int it_char)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        ALanguageQuickInfo info;
        if (it->second->QueryInfo(version, it_line, it_char, info))
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, info](lua_State* L)->int
            {
                lua_newtable(L);
                lua_pushinteger(L, query_id);
                lua_setfield(L, -2, "query_id");

                {
                    lua_newtable(L);
                    lua_pushinteger(L, info.line_start + 1);
                    lua_setfield(L, -2, "line_start");
                    lua_pushinteger(L, info.char_start + 1);
                    lua_setfield(L, -2, "char_start");
                    lua_pushinteger(L, info.line_end + 1);
                    lua_setfield(L, -2, "line_end");
                    lua_pushinteger(L, info.char_end);
                    lua_setfield(L, -2, "char_end");
                    lua_pushstring(L, info.info.c_str());
                    lua_setfield(L, -2, "info");
                }

                lua_setfield(L, -2, "result");
                return 1;
            });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
        });
}

void ABnfProject::QueryGoto(const std::string& full_path, int query_id, int version, int it_line, int it_char)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        ALanguageGotoInfo info;
        if (it->second->QueryGoto(version, it_line, it_char, info))
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, info](lua_State* L)->int
                {
                    lua_newtable(L);
                    lua_pushinteger(L, query_id);
                    lua_setfield(L, -2, "query_id");

                    {
                        lua_newtable(L);
                        lua_pushinteger(L, info.line_start + 1);
                        lua_setfield(L, -2, "line_start");
                        lua_pushinteger(L, info.char_start + 1);
                        lua_setfield(L, -2, "char_start");
                        lua_pushinteger(L, info.line_end + 1);
                        lua_setfield(L, -2, "line_end");
                        lua_pushinteger(L, info.char_end);
                        lua_setfield(L, -2, "char_end");
                        lua_pushstring(L, info.file_path.c_str());
                        lua_setfield(L, -2, "file_path");
                    }

                    lua_setfield(L, -2, "result");
                    return 1;
                });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
        });
}

void ABnfProject::QueryComplete(const std::string& full_path, int query_id, int version, int it_line, int it_char)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        std::vector<ALanguageCompletionInfo> info_list;
        int line_start; int char_start; int line_end; int char_end;
        if (it->second->QueryComplete(version, it_line, it_char, info_list, line_start, char_start, line_end, char_end)
            && !info_list.empty())
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, info_list, line_start, char_start, line_end, char_end](lua_State* L)->int
                {
                    lua_newtable(L);
                    lua_pushinteger(L, query_id);
                    lua_setfield(L, -2, "query_id");

                    {
                        lua_newtable(L);
                        lua_pushinteger(L, line_start + 1);
                        lua_setfield(L, -2, "line_start");
                        lua_pushinteger(L, char_start + 1);
                        lua_setfield(L, -2, "char_start");
                        lua_pushinteger(L, line_end + 1);
                        lua_setfield(L, -2, "line_end");
                        lua_pushinteger(L, char_end);
                        lua_setfield(L, -2, "char_end");

                        lua_newtable(L);
                        for (size_t i = 0; i < info_list.size(); ++i)
                        {
                            auto& complete = info_list[i];

                            lua_newtable(L);
                            lua_pushstring(L, complete.display.c_str());
                            lua_setfield(L, -2, "display");
                            if (complete.insert.size())
                            {
                                lua_pushstring(L, complete.insert.c_str());
                                lua_setfield(L, -2, "insert");
                            }
                            if (complete.descriptor.size())
                            {
                                lua_pushstring(L, complete.descriptor.c_str());
                                lua_setfield(L, -2, "descriptor");
                            }
                            lua_pushinteger(L, complete.tag);
                            lua_setfield(L, -2, "tag");
                            lua_rawseti(L, -2, static_cast<int>(i) + 1);
                        }
                        lua_setfield(L, -2, "complete_list");
                    }

                    lua_setfield(L, -2, "result");
                    return 1;
                });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
        });
}

void ABnfProject::QueryParamList(const std::string& full_path, int query_id, int version, int it_line, int it_char)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        std::vector<ALanguageParameterInfo> info_list;
        int line_start; int char_start; int line_end; int char_end;
        if (it->second->QueryParamList(version, it_line, it_char, info_list, line_start, char_start, line_end, char_end))
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, info_list, line_start, char_start, line_end, char_end](lua_State* L)->int
                {
                    lua_newtable(L);
                    lua_pushinteger(L, query_id);
                    lua_setfield(L, -2, "query_id");

                    {
                        lua_newtable(L);
                        lua_pushinteger(L, line_start + 1);
                        lua_setfield(L, -2, "line_start");
                        lua_pushinteger(L, char_start + 1);
                        lua_setfield(L, -2, "char_start");
                        lua_pushinteger(L, line_end + 1);
                        lua_setfield(L, -2, "line_end");
                        lua_pushinteger(L, char_end);
                        lua_setfield(L, -2, "char_end");

                        lua_newtable(L);
                        for (size_t i = 0; i < info_list.size(); ++i)
                        {
                            const auto& info = info_list[i];

                            lua_newtable(L);
                            lua_pushstring(L, info.name.c_str());
                            lua_setfield(L, -2, "name");
                            if (!info.descriptor.empty())
                            {
                                lua_pushstring(L, info.descriptor.c_str());
                                lua_setfield(L, -2, "descriptor");
                            }
                            lua_rawseti(L, -2, static_cast<int>(i) + 1);
                        }
                        lua_setfield(L, -2, "param_list");
                    }

                    lua_setfield(L, -2, "result");
                    return 1;
                });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
        });
}

void ABnfProject::QueryError(const std::string& full_path, int query_id, int version, bool force)
{
    auto it = m_file_map.find(full_path);
    if (it != m_file_map.end())
    {
        std::vector<ALanguageErrorInfo> info_list;
        if (it->second->QueryError(version, force, info_list)
            && info_list.size())
        {
            std::unique_lock<std::mutex> lock(m_output_lock);
            m_outputs.emplace_back([query_id, info_list](lua_State* L)->int
                {
                    lua_newtable(L);
                    lua_pushinteger(L, query_id);
                    lua_setfield(L, -2, "query_id");

                    {
                        lua_newtable(L);
                        for (size_t i = 0; i < info_list.size(); ++i)
                        {
                            auto& error = info_list[i];

                            lua_newtable(L);
                            lua_pushinteger(L, error.line_start + 1);
                            lua_setfield(L, -2, "line_start");
                            lua_pushinteger(L, error.char_start + 1);
                            lua_setfield(L, -2, "char_start");
                            lua_pushinteger(L, error.line_end + 1);
                            lua_setfield(L, -2, "line_end");
                            lua_pushinteger(L, error.char_end);
                            lua_setfield(L, -2, "char_end");
                            lua_pushstring(L, error.error.c_str());
                            lua_setfield(L, -2, "error");
                            lua_rawseti(L, -2, static_cast<int>(i) + 1);
                        }
                    }

                    lua_setfield(L, -2, "result");
                    return 1;
                });

            return;
        }
    }

    std::unique_lock<std::mutex> lock(m_output_lock);
    m_outputs.emplace_back([query_id](lua_State* L) -> int {
        lua_newtable(L);
        lua_pushinteger(L, query_id);
        lua_setfield(L, -2, "query_id");
        return 1;
        });
}

int ABnfProject::Run(ABnfProject* self)
{
    // 定义临时列表
    std::list<std::function<void()>> temp_list;
    while (self->m_run)
    {
        // 获取执行队列
        {
            std::unique_lock<std::mutex> lock(self->m_input_lock);
            while (self->m_run && self->m_inputs.empty())
                self->m_cv.wait(lock);
            temp_list.swap(self->m_inputs);
        }

        // 开始执行
        while (!temp_list.empty())
        {
            temp_list.front()();
            temp_list.pop_front();
        }
    }

    return 0;
}
