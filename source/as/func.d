module as.func;
import as.def;
import as.engine;
import as.mod;
import std.string;

enum FuncType : asEFuncType {
    /**
        A dummy no-op function
    */
    Dummy = asEFuncType.asFUNC_DUMMY,

    /**
        A system function
    */
    System = asEFuncType.asFUNC_SYSTEM,

    /**
        A script function
    */
    Script = asEFuncType.asFUNC_SCRIPT,

    /**
        A interface function declaration
    */
    Interface = asEFuncType.asFUNC_INTERFACE,

    /**
        A virtual function
    */
    Virtual = asEFuncType.asFUNC_VIRTUAL,

    /**
        A function definition
    */
    FuncDef = asEFuncType.asFUNC_FUNCDEF,

    /**
        An imported function
    */
    Imported = asEFuncType.asFUNC_IMPORTED,

    /**
        A function delegate
    */
    Delegate = asEFuncType.asFUNC_DELEGATE
}

class Function {
private:
    ScriptEngine engine;
    Module mod;

    ~this() {
        // Avoid garbage collecting the engine
        this.engine = null;
        this.mod = null;
    }

package(as):
    asIScriptFunction* func;

    this(ScriptEngine engine, asIScriptFunction* func) {
        this.engine = engine;
        this.mod = new Module(engine, asFunction_GetModule(func));
        this.func = func;
    }

    this(ScriptEngine engine, Module mod, asIScriptFunction* func) {
        this.engine = engine;
        this.mod = mod;
        this.func = func;
    }

public:

    /**
        Gets the scripting engine this module belongs to
    */
    ScriptEngine getEngine() {
        return engine;
    }

    /**
        Gets the module this function belongs to
    */
    Module getModule() {
        return mod;
    }

    /**
        Adds a reference to this function
    */
    int addRef() {
        return asFunction_AddRef(func);
    }

    /**
        Releases a reference from this function
    */
    int release() {
        return asFunction_Release(func);
    }

    /**
        Gets the ID of this function
    */
    int getId() {
        return asFunction_GetId(func);
    }

    /**
        Gets this function's function type
    */
    FuncType getFuncType() {
        return cast(FuncType)asFunction_GetFuncType(func);
    }

    /**
        Gets the module this function belongs to
    */
    string getModuleName() {
        return cast(string)asFunction_GetModuleName(func).fromStringz;
    }

    /**
        Gets the name of the script section this function belongs to
    */
    string getScriptSectionName() {
        return cast(string)asFunction_GetScriptSectionName(func).fromStringz;
    }

    /**
        Gets the config group this function belongs to
    */
    string getConfigGroup() {
        return cast(string)asFunction_GetConfigGroup(func).fromStringz;
    }

    /**
        Gets this function's access mask
    */
    asDWORD getAccessMask() {
        return asFunction_GetAccessMask(func);
    }

    /**
        Gets this function's auxiliary
    */
    void* getAuxiliary() {
        return asFunction_GetAuxiliary(func);
    }
}