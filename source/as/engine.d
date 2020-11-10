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
        int err = asEngine_SetMessageCallback(engine, cast(asFUNCTION_t)callback, null, CDECL);
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
        int err = asEngine_RegisterGlobalFunction(engine, declaration.toStringz, cast(asFUNCTION_t)func, DCall, aux);
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
        enforce(err != asERetCodes.asINVALID_ARG, "Index is too large");
        
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
        int err = asEngine_GetGlobalPropertyIndexByName(engine, name.toStringz);
        enforce(err != asERetCodes.asNO_GLOBAL_VAR, "No matching property was found");
        return err;
    }

    /**
        Gets the index of a global property by its declaration
    */
    int getGlobalPropertyIndexByDecl(string decl) {
        int err = asEngine_GetGlobalPropertyIndexByDecl(engine, decl.toStringz);
        enforce(err != asERetCodes.asNO_GLOBAL_VAR, "No matching property was found");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Invalid declaration");
        return err;
    }

    /**
        Registers an object type
    */
    void registerObjectType(string name, int byteSize, asDWORD flags) {
        int err = asEngine_RegisterObjectType(engine, name.toStringz, byteSize, flags);
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid flags");
        enforce(err != asERetCodes.asINVALID_NAME, "Invalid name");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "An object with the same name already exists");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name is already taken by an other symbol");
        enforce(err != asERetCodes.asLOWER_ARRAY_DIMENSION_NOT_REGISTERED, "Registered array type element must be a primitive or registered type");
        enforce(err != asERetCodes.asINVALID_TYPE, "Array type was malformed");
        enforce(err != asERetCodes.asNOT_SUPPORTED, "Array type is not supported or already in use.");
    }

    /**
        Registers a property for an object
    */
    void registerObjectProperty(string obj, string decl, int byteOffset) {
        int err = asEngine_RegisterObjectProperty(engine, obj.toStringz, decl.toStringz, byteOffset);
        enforce(err != asERetCodes.asWRONG_CONFIG_GROUP, "Object type was registered in a different config group");
        enforce(err != asERetCodes.asINVALID_OBJECT, "obj does not specify an object type");
        enforce(err != asERetCodes.asINVALID_TYPE, "obj parameter syntax invalid");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name conflicts with other members");
    }

    /**
        Registers a method for an object
    */
    void registerObjectMethod(T)(string obj, string decl, T func, asDWORD callConv = DCall, void* aux = null) if (isFunctionPointer!T) {
        int err = asEngine_RegisterObjectMethod(engine, obj.toStringz, decl.toStringz, cast(asFUNCTION_t)func, callConv, aux);
        enforce(err != asERetCodes.asWRONG_CONFIG_GROUP, "Object type was registered in a different config group");
        enforce(err != asERetCodes.asNOT_SUPPORTED, "The calling convention is not supported");
        enforce(err != asERetCodes.asINVALID_TYPE, "obj parameter syntax invalid");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Invalid declaration");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name conflicts with other members");
        enforce(err != asERetCodes.asWRONG_CALLING_CONV, "The function's calling convention is not compatible with callConv");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "The method is already registered with the same parameter list");
        enforce(err != asERetCodes.asINVALID_ARG, "aux pointer was not set according to calling convention");
    }

    /**
        Registers a behaviour for an object
    */
    void registerObjectBehaviour(T)(string obj, asEBehaviours behaviour, string decl, T func, asDWORD callConv = DCall, void* aux = null) if (isFunctionPointer!T) {
        int err = asEngine_RegisterObjectBehaviour(engine, obj.toStringz, behaviour, decl.toStringz, cast(asFUNCTION_t)func, callConv, aux);
        enforce(err != asERetCodes.asWRONG_CONFIG_GROUP, "Object type was registered in a different config group");
        enforce(err != asERetCodes.asINVALID_ARG, "obj not set, global behaviour given in behaviour or the objForThiscall pointer wasn't set correctly");
        enforce(err != asERetCodes.asWRONG_CALLING_CONV, "The function's calling convention is not compatible with callConv");
        enforce(err != asERetCodes.asNOT_SUPPORTED, "The calling convention or behaviour signature is not supported");
        enforce(err != asERetCodes.asINVALID_TYPE, "Invalid obj parameter");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Invalid declaration");
        enforce(err != asERetCodes.asILLEGAL_BEHAVIOUR_FOR_TYPE, "Illegal behaviour for type");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "The method is already registered with the same parameter list");
    }

    /**
        Registers a new interface
    */
    void registerInterface(string name) {
        int err = asEngine_RegisterInterface(engine, name.toStringz);
        enforce(err != asERetCodes.asINVALID_NAME, "Name is null or reserved keyword");
        enforce(err != asERetCodes.asALREADY_REGISTERED, "Object type with this name already exists");
        enforce(err != asERetCodes.asERROR, "Name is not a proper identifier");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name is already used elsewhere");
    }

    /**
        Registers an interface method
    */
    void registerInterfaceMethod(string intf, string decl) {
        int err = asEngine_RegisterInterfaceMethod(engine, intf.toStringz, decl.toStringz);
        enforce(err != asERetCodes.asWRONG_CONFIG_GROUP, "Interface was registered in a different config group");
        enforce(err != asERetCodes.asINVALID_TYPE, "intf is not an interface");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Invalid declaration");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name is already taken");
    }

    /**
        Gets the count of the objects in the engine
    */
    asUINT getObjectTypeCount() {
        return asEngine_GetObjectTypeCount(engine);
    }

    /**
        Gets the type info of an object by its index
    */
    Type getObjectTypeByIndex(asUINT index) {
        auto type = asEngine_GetObjectTypeByIndex(engine, index);
        return type !is null ? new Type(this, type) : null;
    }

    /**
        Registers a string factory type with the specified creation functions
    */
    void registerStringFactory(string type, asGETSTRINGCONSTFUNC_t getStr, asRELEASESTRINGCONSTFUNC_t releaseStr, asGETRAWSTRINGDATAFUNC_t getRawStr) {
        int err = asEngine_RegisterStringFactory(engine, type.toStringz, getStr, releaseStr, getRawStr);
        enforce(err != asERetCodes.asINVALID_ARG, "The factory is null");
        enforce(err != asERetCodes.asINVALID_TYPE, "Type is not valid or it is a reference/handle.");
    }

    /**
        Gets the return type id of the string type the factory returns
    */
    asUINT getStringFactoryReturnTypeId(asDWORD* flags = null) {
        asUINT err = asEngine_GetStringFactoryReturnTypeId(engine, flags);
        enforce(err != asERetCodes.asNO_FUNCTION, "String factory has not been registered");
        return err;
    }

    /**
        Registers the default array type
    */
    void registerDefaultArrayType(string type) {
        int err = asEngine_RegisterDefaultArrayType(engine, type.toStringz);
        enforce(err != asERetCodes.asINVALID_TYPE, "Type is not a template type");
    }

    /**
        Gets the type id of the default array type
    */
    int getDefaultArrayTypeId() {
        int err = asEngine_GetDefaultArrayTypeId(engine);
        enforce(err != asERetCodes.asINVALID_TYPE, "Array type has not been registered");
        return err;
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
        Gets the type of an enum by its index
    */
    Type getEnumByindex(asUINT index) {
        auto type = asEngine_GetEnumByIndex(engine, index);
        return type !is null ? new Type(this, type) : null;
    }

    void registerFuncDef(string decl) {
        int err = asEngine_RegisterFuncdef(engine, decl.toStringz);
        enforce(err != asERetCodes.asINVALID_ARG, "Declaration not given");
        enforce(err != asERetCodes.asINVALID_DECLARATION, "Invalid function definition");
        enforce(err != asERetCodes.asNAME_TAKEN, "Name conflicts with an other name");
    }

    /**
        Gets the amount of enums registered
    */
    asUINT getFuncdefConut() {
        return asEngine_GetFuncdefCount(engine);
    }

    /**
        Gets the type of a fundef by its index
    */
    Type getFuncdefByIndex(asUINT index) {
        auto type = asEngine_GetFuncdefByIndex(engine, index);
        return type !is null ? new Type(this, type) : null;
    }

    /**
        Starts a new dynamic configuration group
    */
    void beginConfigGroup(string groupName) {
        int err = asEngine_BeginConfigGroup(engine, groupName.toStringz);
        enforce(err != asERetCodes.asNAME_TAKEN, "Group name is already in use");
        enforce(err != asERetCodes.asNOT_SUPPORTED, "Nested configuration groups isn't supported");
    }

    /**
        Ends the configuration group
    */
    void endConfigGroup() {
        int err = asEngine_EndConfigGroup(engine);
        enforce(err != asERetCodes.asERROR, "No configuration groups to end");
    }

    /**
        Removes a configuration group
    */
    void removeConfigGroup(string groupName) {
        int err = asEngine_RemoveConfigGroup(engine, groupName.toStringz);
        enforce(err != asERetCodes.asCONFIG_GROUP_IS_IN_USE, "Group is in use and can't be removed");
    }

    /**
        Sets the access mask that should be used for subsequent registered entities
    */
    asDWORD setDefaultAccessMask(asDWORD defaultMask) {
        return asEngine_SetDefaultAccessMask(engine, defaultMask);
    }

    /**
        Sets the default namespace
    */
    void setDefaultNamespace(string nameSpace) {
        int err = asEngine_SetDefaultNamespace(engine, nameSpace.toStringz);
        enforce(err != asERetCodes.asINVALID_ARG, "Invalid namespace");
    }

    /**
        Gets the current default namespace
    */
    string getDefaultNamespace() {
        return cast(string)asEngine_GetDefaultNamespace(engine).fromStringz;
    }

    /**
        Gets a module in the engine by name
    */
    Module getModule(string name, ModuleCreateFlags flags = ModuleCreateFlags.OnlyIfExists) {
        auto mod = asEngine_GetModule(engine, name.toStringz, flags);
        return mod !is null ? new Module(this, mod) : null;
    }

    /**
        Gets a module in the engine by index
    */
    Module getModule(asUINT index) {
        auto mod = asEngine_GetModuleByIndex(engine, index);
        return mod !is null ? new Module(this, mod) : null;
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