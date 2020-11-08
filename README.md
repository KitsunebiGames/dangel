# DAngel
D bindings and wrapper for AngelScript with support for D strings.

Do note this is still work in progress and there's currently issues with D calling conventions breaking with angelscript (will be working on patching angelscript to support D calling conventions)

This library also depends on a patched C binding to angelscript that you will need to compile first, you can find that [here](https://github.com/KitsunebiGames/angelscriptc)

# Why?
Because I can, especially with the string support.  
I'm sorry in advance, there's some cursed GC stuff going on there and I'm not sure whether it will leak memory at some point.

# Using the binding
First compile AngelScript and the [patched c bindings](https://github.com/KitsunebiGames/angelscriptc) **AS DYNAMIC LIBRARIES** and install the libraries to your system's library path (or whatever the heck you do on Windows)

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

# My functions don't run correctly!
I know, there's some incompatibility between AngelScript and the D ABI's calling conventions, changing the calling convention to the C calling convention via `extern(C)` and marking your function as `asCDECL` should work around it temporarily.

I'll be working on making a patched version of AngelScript that supports the D calling convention unless the creator of AngelScript decides to add it themself.