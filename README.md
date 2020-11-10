# DAngel
D bindings and wrapper for AngelScript with support for D strings.

Do note this is still work in progress and there's currently issues with D calling conventions breaking with angelscript (will be working on patching angelscript to support D calling conventions)

This library also depends on a patched C binding to angelscript that you will need to compile first, you can find that [here](https://github.com/KitsunebiGames/angelscriptc) you will also need the [patched AngelScript with D ABI support](https://github.com/KitsunebiGames/angelscript-ddecl) (GCC only right now!) 

# Using the binding
First compile AngelScript, the patched [AngelScript with D ABI support](https://github.com/KitsunebiGames/angelscript-ddecl) the [patched c bindings](https://github.com/KitsunebiGames/angelscriptc) **AS DYNAMIC LIBRARIES** and install the libraries to your system's library path (or whatever the heck you do on Windows)

Then put the libraries somewhere that the D linker will be able to find them, in my case that's `/usr/lib` and `/usr/include`. You may want to ship the libraries with your application.

Once you have that sorted, just compile your application with dub and it _should_ link to the libraries, hopefully...

# Using D strings
To enable D string support register the D string subsystem in angelscript like this:
```d
    import as.addons.str : registerDStrings;
    ScriptEngine engine = ScriptEngine.create();
    engine.registerDStrings();

    // Register all your other stuff and execute your scripts.
```

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

# There's parts of the API missing!
I know, there's also a lot of places where I haven't done any error handling yet that will just fail silently. It will be fixed with time.

# Why does everything assert?
This binding is meant to be used for gamedev so I'd prefer to avoid having a bunch of exceptions thrown and checking status IDs is imho pretty ugly.  
Therefore this library prefers if you fix bugs during debug builds and have minimal error checking in release builds.