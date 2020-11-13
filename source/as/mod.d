module as.mod;
import as.def;
import as.engine;
import as.func;
import std.string;
import as.stream;

enum ModuleCreateFlags : asEGMFlags {
    /**
        Only load the module if it exists
    */
    OnlyIfExists = asEGMFlags.asGM_ONLY_IF_EXISTS,

    /**
        Try to create the module if it doesn't exist
    */
    CreateIfNotExists = asEGMFlags.asGM_CREATE_IF_NOT_EXISTS,

    /**
        Always create the module, overwriting old modules with the same name
    */
    AlwaysCreate = asEGMFlags.asGM_ALWAYS_CREATE
}

class Module {
private:
    ScriptEngine engine;

    ~this() {
        this.engine = null;
    }

package(as):
    asIScriptModule* mod;
    
    this(ScriptEngine engine, asIScriptModule* mod) {
        this.engine = engine;
        this.mod = mod;
    }

public:

    /**
        Gets the engine this module belongs to
    */
    ScriptEngine getEngine() {
        return engine;
    }

    /**
        Sets the name of the module
    */
    void setName(string name) {
        asModule_SetName(mod, name.toStringz);
    }

    /**
        Gets the name of the module
    */
    string getName() {
        return cast(string)asModule_GetName(mod).fromStringz;
    }

    /**
        Discards the module, removing it from the engine
    */
    void discard() {
        asModule_Discard(mod);
    }

    /**
        Adds a script section to the module
    */
    void addScriptSection(string name, string code, int lineOffset = 0) {
        int err = asModule_AddScriptSection(mod, name.toStringz, code.toStringz, code.length, lineOffset);
    }

    /**
        Builds scripts
    */
    void build() {
        int err = asModule_Build(mod);
        assert(err != asERetCodes.asINVALID_CONFIGURATION, "Invalid configuration");
        assert(err != asERetCodes.asERROR, "Failed to compile script");
        assert(err != asERetCodes.asBUILD_IN_PROGRESS, "Another thread is currently building");
        assert(err != asERetCodes.asINIT_GLOBAL_VARS_FAILED, "Unable to initialize at least one global variable");
        assert(err != asERetCodes.asNOT_SUPPORTED, "Compiler support disabled");
        assert(err != asERetCodes.asMODULE_IS_IN_USE, "Code is in use and can't be removed");
    }

    /**
        Saves bytecode to a ubyte array
    */
    ubyte[] saveByteCode(bool stripdebugInfo = false) {
        BinaryStream* stream = BinaryStream.create();
        asModule_SaveByteCode(mod, stream.stream, stripdebugInfo);
        return stream.buffer.dup;
    }

    /**
        Loads bytecode
    */
    void loadByteCode(ubyte[] buffer, bool* wasDebugInfoStripped = null) {
        BinaryStream* stream = BinaryStream.create();
        stream.buffer = buffer;
        asModule_LoadByteCode(mod, stream.stream, wasDebugInfoStripped);
    }

    /**
        Gets function by declaration
    */
    Function getFunctionByDecl(string decl) {
        return new Function(engine, asModule_GetFunctionByDecl(mod, decl.toStringz));
    }

    /**
        Gets function by name
    */
    Function getFunctionByName(string name) {
        return new Function(engine, asModule_GetFunctionByName(mod, name.toStringz));
    }
}
