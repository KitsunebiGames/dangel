# DAngel
D bindings and wrapper for AngelScript with support for D strings.

Note that this library is still work in progress

This library also depends on a patched C binding to angelscript that you will need to compile first, you can find that [here](https://github.com/KitsunebiGames/angelscriptc) you will also need the [patched AngelScript with D ABI support](https://github.com/KitsunebiGames/angelscript-ddecl)

# Using the binding
First compile the patched [AngelScript with D ABI support](https://github.com/KitsunebiGames/angelscript-ddecl) and the [patched c bindings](https://github.com/KitsunebiGames/angelscriptc) and install the libraries to your system's library path, on Windows it's recommended to use precompiled static libraries, which are included on 64 bit Windows installations automatically.

Then put the libraries somewhere that the D linker will be able to find them, in my case that's `/usr/lib` and `/usr/include`. You may want to ship the libraries with your application.

Once you have that sorted, just compile your application with `dub` and it _should_ link to the libraries, hopefully...

# Using D strings
To enable D string support register the D string subsystem in angelscript like this:
```d
    import as.addons.str : registerDStrings;
    ScriptEngine engine = ScriptEngine.create();
    engine.registerDStrings();

    // Register all your other stuff and execute your scripts.
```

## Returning strings from D functions to the AngelScript VM
The strings handled by angelscript are outside the garbage collector's reach, when you pass a string to AngelScript it will be copied in to non-GC memory
To return a string from a global method use the `StringPtr` helper method to get a pointer to the GC memory containing the string, from there it will be copied out of GC memory.
```d
// Returns Hello World in 3 languages (English, Japanese and Danish)
engine.registerGlobalFunction("string &getHelloString()", 
    () { 
        return StringPtr("Hello, world!\nこんにちは世界！\nHej verden!");
    }
);
```

Note: strings in the AngelScript VM are UTF-8 and D UTF-8 text should be compatible.

# Registering D types
Currently DAngel supports registering a few D types automatically, one being **integer** enums. To register a D integer enum do the following:
```d
    enum MyEnum {
        Item1,
        Item2,
        Item3 = 42,
    }

    // After this call the enum will be available to your scripts.
    engine.registerEnum!MyEnum;
```

There's experimental and buggy support for registering D structs in `as.addons.dwrap`. I don't recommend using it currently, though.

# Why does everything assert?
This binding is meant to be used for gamedev so I'd prefer to avoid having a bunch of exceptions thrown and checking status IDs is imho pretty ugly.  
Therefore this library prefers if you fix bugs during debug builds and have minimal error checking in release builds.

# Where's the documentation?
I plan to write proper documentation with examples at some point when I get time. That might take a while to happen though. I highly recommend checking the [C++ documentation](https://www.angelcode.com/angelscript/sdk/docs/manual/index.html) as the APIs should be decently similar as well as the [Auto-generated documentation](http://dangel.dpldocs.info/as.html)
