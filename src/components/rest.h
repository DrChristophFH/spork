#pragma once

#include <emscripten/fetch.h>

#include <iostream>
#include <string>
#include <vector>

#include "imgui.h"
#include "imgui_stdlib.h"
#include "imgui_ext/imgui_templated.h"

class HttpClient {
 public:
  HttpClient() : url("https://jsonplaceholder.typicode.com/posts"), responseText("") {}

  static void OnSuccess(emscripten_fetch_t *fetch) {
    HttpClient *client = static_cast<HttpClient *>(fetch->userData);
    client->responseText = std::string(fetch->data, fetch->numBytes);
    emscripten_fetch_close(fetch);
  }

  static void OnError(emscripten_fetch_t *fetch) {
    HttpClient *client = static_cast<HttpClient *>(fetch->userData);
    client->responseText = "Request failed!";
    emscripten_fetch_close(fetch);
  }

  void SendRequest() {
    emscripten_fetch_attr_t attr;
    emscripten_fetch_attr_init(&attr);
    strncpy(attr.requestMethod, method.c_str(), sizeof(attr.requestMethod));

    attr.requestData = method == "POST" ? postData.c_str() : nullptr;
    attr.requestDataSize = method == "POST" ? postData.size() : 0;

    attr.attributes = EMSCRIPTEN_FETCH_LOAD_TO_MEMORY;

    attr.onsuccess = OnSuccess;
    attr.onerror = OnError;

    attr.userData = this;

    emscripten_fetch(&attr, url.c_str());
  }

  void RenderUI() {
    ImGui::Begin("REST Client");

    ImGui::InputText("URL", &url);

    ImGui::RadioButton("GET", &method, Method::GET);
    ImGui::RadioButton("POST", &method, Method::POST);
    ImGui::RadioButton("PUT", &method, Method::PUT);
    ImGui::RadioButton("DELETE", &method, Method::DELETE);

    ImGui::TextWrapped("Response:");
    ImGui::InputTextMultiline("##response", &responseText, ImVec2(-FLT_MIN, 100), ImGuiInputTextFlags_ReadOnly);

    ImGui::End();
  }

  bool shouldShow = true;

 private:
  struct Method {
    inline static const std::string GET = "GET";
    inline static const std::string POST = "POST";
    inline static const std::string PUT = "PUT";
    inline static const std::string DELETE = "DELETE";
  };

  std::string url;
  std::string postData;
  std::string responseText;
  std::string method = Method::GET;
};
