# SPORK

I don't know what spork will become, but I am sure it will achieve *something*!

For the meantime spork is a nice template to use for building a ImGui application in C++ targeting the web using Emscripten.

Don't forget to check out the [ImGui](https://github.com/ocornut/imgui) library and the [Emscripten](https://emscripten.org/) compiler (dunno leave a like or something 🤔)

## Build

Do this once when having the devcontainer running:

```bash
source emsdk_env.sh
```

And then always when you want to build:

```bash
make serve
```

This will build the project and start a python web server at `http://localhost:8000` where you can see the result.