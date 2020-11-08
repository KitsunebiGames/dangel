module as.engine;
import as.def;
import std.string;
import std.exception;
import std.traits;
import as;

class ScriptEngine {
private:
    asIScriptEngine* engine;

    ~this() {
        this.shutDownAndRelease();
    }

    this(asIScriptEngine* engine) {
        this.engine = engine;
    }

public:

    /**
        Creates a new script engine
    */
    static ScriptEngine create(asDWORD version_ = ANGELSCRIPT_VERSION) {
        return new ScriptEngine(asCreateScriptEngine(version_));
    }

    /**
        Adds reference
    */
    int addRef() {
        return asEngine_AddRef(engine);
    }

    /**
        Releases reference
    */
    int release() {
        return asEngine_Release(engine);
    }

    /**
        Shuts down the scripting engine and releases it
    */
    int shutDownAndRelease() {
        return asEngine_ShutDownAndRelease(engine);
    }

    /**
        Sets an engine property
    */
    void setProperty(asEEngineProp property, asPWORD value) {
        int err = asEngine_SetEngineProperty(engine, property, value);
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid argument");
    }

    /**
        Gets an engine property
    */
    asPWORD getProperty(asEEngineProp property) {
        return asEngine_GetEngineProperty(engine, property);
    }

    /**
        Sets the message callback

        BUG: Writing message will cause a crash currently.
    */
    void setMessageCallback(MessageCallback callback) {


        int err = asEngine_SetMessageCallback(engine, cast(asFUNCTION_t)callback, null, DCallConv);
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid argument");
        enforce(err != asERetCodes.asNOT_SUPPORTED, "Not supported");
    }

    /**
        Clears the message callback
    */
    void clearMessageCallback() {
        asEngine_ClearMessageCallback(engine);
    }

    /**
        Writes a message
    */
    void writeMessage(string section, int row, int col, MessageType type, string message) {
        asEngine_WriteMessage(engine, section.toStringz, row, col, cast(asEMsgType)type, message.toStringz);
    }

    // TODO: Jit Compiler

    /**
        Register a global function
    */
    void registerGlobalFunction(T)(string declaration, T func, void* aux = null) if (isFunctionPointer!T) {
        int err = asEngine_RegisterGlobalFunction(engine, declaration.toStringz, cast(asFUNCTION_t)func, DCallConv, aux);
        enforce(err != asERetCodes.asNOT_SUPPORTED, "Not supported");
        enforce(err != asERetCodes.asWRONG_CALLING_CONV, "Wrong calling convetion");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Function declaration is invalid");
        enforce(err != asERetCodes.asNAME_TAKEN, "Function name is already taken");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "Function is already registered");
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid argument");
    }

    /**
        Gets the amount of global functions
    */
    asUINT getGlobalFunctionCount() {
        return asEngine_GetGlobalFunctionCount(engine);
    }
    
    /**
        Gets a global function by its index
    */
    Function getGlobalFunctionByIndex(uint index) {
        return new Function(this, asEngine_GetGlobalFunctionByIndex(engine, index));
    }
    
    /**
        Gets a global function by its declaration
    */
    Function getGlobalFunctionByDecl(string decl) {
        return new Function(this, asEngine_GetGlobalFunctionByDecl(engine, decl.toStringz));
    }

    /**
        Registers a global property
    */
    void registerGlobalProperty(T)(string declaration, ref T pointer) {
        int err = asEngine_RegisterGlobalProperty(engine, declaration.toStringz, cast(void*)&pointer);
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Declaration is invalid");
        enforce(err != asERetCodes.asINVALID_TYPE, "Declaration type is invalid");
        enforce(err != asERetCodes.asINVALID_ARG, "Reference is null");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name is already taken");
    }

    /**
        Gets the count of global properties
    */
    asUINT getGlobalPropertyCount() {
        return asEngine_GetGlobalPropertyCount(engine);
    }

    /**
        Gets a global property by its index
    */
    void getGlobalPropertyByIndex(uint index, ref string name, ref string namespace, ref int typeId, ref bool isConst, ref string configGroup, void* ptr, ref asDWORD accessMask) {
        const(char)* c_name;
        const(char)* c_namespace;
        int c_typeId;
        bool c_isConst;
        const(char)* c_configGroup;
        void* c_ptr;
        asDWORD c_accessMask;

        int err = asEngine_GetGlobalPropertyByIndex(engine, index, &c_name, &c_namespace, &c_typeId, &c_isConst, &c_configGroup, &c_ptr, &c_accessMask);
        // TODO: Report errors
        
        // move all this data to the appropriate place
        name = cast(string)c_name.fromStringz.idup;
        namespace = cast(string)c_namespace.fromStringz.idup;
        typeId = c_typeId;
        isConst = c_isConst;
        configGroup = cast(string)c_configGroup.fromStringz.idup;
        ptr = c_ptr;
        accessMask = c_accessMask;
    }

    /**
        Gets the index of a global property by its name
    */
    int getGlobalPropertyIndexByName(string name) {
        return asEngine_GetGlobalPropertyIndexByName(engine, name.toStringz);
    }

    /**
        Gets the index of a global property by its declaration
    */
    int getGlobalPropertyIndexByDecl(string decl) {
        return asEngine_GetGlobalPropertyIndexByDecl(engine, decl.toStringz);
    }

    /**
        Registers an object type
    */
    void registerObjectType(string name, int byteSize, asDWORD flags) {
        asEngine_RegisterObjectType(engine, name.toStringz, byteSize, flags);
    }

    /**
        Registers a property for an object
    */
    void registerObjectProperty(string obj, string decl, int byteOffset) {
        asEngine_RegisterObjectProperty(engine, obj.toStringz, decl.toStringz, byteOffset);
    }

    /**
        Registers a method for an object
    */
    void registerObjectMethod(T)(string obj, string decl, T func, asDWORD callConv = DCallConv, void* aux = null) if (isFunctionPointer!T) {
        asEngine_RegisterObjectMethod(engine, obj.toStringz, decl.toStringz, cast(asFUNCTION_t)func, callConv, aux);
    }

    /**
        Registers a behaviour for an object
    */
    void registerObjectBehaviour(T)(string dataType, asEBehaviours behaviour, string decl, T func, asDWORD callConv = DCallConv, void* aux = null) if (isFunctionPointer!T) {
        asEngine_RegisterObjectBehaviour(engine, dataType.toStringz, behaviour, decl.toStringz, cast(asFUNCTION_t)func, callConv, aux);
    }

    // TODO: String Factory and Default Array Type

    /**
        Registers a string factory type with the specified creation functions
    */
    void registerStringFactory(string type, asGETSTRINGCONSTFUNC_t getStr, asRELEASESTRINGCONSTFUNC_t releaseStr, asGETRAWSTRINGDATAFUNC_t getRawStr) {
        asEngine_RegisterStringFactory(engine, type.toStringz, getStr, releaseStr, getRawStr);
    }

    /**
        Registers a D enum in Angelscript
    */
    void registerEnum(T)() if (is(T == enum)) {
        mixin("import ", moduleName!T, ";");
        registerEnum(T.stringof);
        static foreach(member; __traits(allMembers, T)) {
            registerEnumValue(T.stringof, member, cast(int)mixin(T.stringof, ".", member));
        }
    }

    /**
        Registers an enum
    */
    void registerEnum(string type) {
        int err = asEngine_RegisterEnum(engine, type.toStringz);
        enforce(err != asERetCodes.asINVALID_NAME, "Invalid name");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "Already registered");
        enforce(err != asERetCodes.asERROR, "Couldn't parse type");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name already taken");
    }

    /**
        Registers a value for the enum
    */
    void registerEnumValue(string type, string name, int value) {
        int err = asEngine_RegisterEnumValue(engine, type.toStringz, name.toStringz, value);
        enforce(err != asERetCodes.asWRONG_CONFIG_GROUP, "Wrong config group");
        enforce(err != asERetCodes.asINVALID_TYPE, "Invalid type");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "Already registered");
    }

    /**
        Gets the amount of enums registered
    */
    asUINT getEnumCount() {
        return asEngine_GetEnumCount(engine);
    }


    /**
        Sets the default namespace
    */
    void setDefaultNamespace(string namespace) {
        int err = asEngine_SetDefaultNamespace(engine, namespace.toStringz);
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid namespace");
    }

    /**
        Gets the default namespace
    */
    string getDefaultNamespace() {
        return cast(string)asEngine_GetDefaultNamespace(engine).fromStringz;
    }

    /**
        Gets a module in the engine by name
    */
    Module getModule(string name, ModuleCreateFlags flags = ModuleCreateFlags.OnlyIfExists) {
        return new Module(this, asEngine_GetModule(engine, name.toStringz, flags));
    }

    /**
        Gets a module in the engine by index
    */
    Module getModule(asUINT index) {
        return new Module(this, asEngine_GetModuleByIndex(engine, index));
    }

    /**
        Discards a module by name
        Note: Any class instances of the module in question will be rendered invalid.
    */
    void discardModule(string name) {
        asEngine_DiscardModule(engine, name.toStringz);
    }

    /**
        Gets the count of modules
    */
    asUINT getModuleCount() {
        return asEngine_GetModuleCount(engine);
    }

    /**
        Get a function by its ID in the engine
    */
    Function getFunctionById(int funcId) {
        return new Function(this, asEngine_GetFunctionById(engine, funcId));
    }

    /**
        Creates a new script context
    */
    ScriptContext createContext() {
        return new ScriptContext(this, asEngine_CreateContext(engine));
    }
}