#pragma once

#ifndef IMGUI_DISABLE

namespace ImGui
{
    template<typename T>
    bool RadioButton(const char* label, T* v, T v_button)
    {
        bool pressed = RadioButton(label, *v == v_button);
        if (pressed)
            *v = v_button;

        return pressed;
    }
}

#endif // #ifndef IMGUI_DISABLE