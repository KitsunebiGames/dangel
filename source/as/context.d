module as.context;
import as.def;
import as.engine;
import as.func;

enum ContextState : asEContextState {
	Finished = asEContextState.asEXECUTION_FINISHED,
	Suspended = asEContextState.asEXECUTION_SUSPENDED,
	Aborted = asEContextState.asEXECUTION_ABORTED,
	Exception = asEContextState.asEXECUTION_EXCEPTION,
	Prepared = asEContextState.asEXECUTION_PREPARED,
	Uninitialized = asEContextState.asEXECUTION_UNINITIALIZED,
	Active = asEContextState.asEXECUTION_ACTIVE,
	Error = asEContextState.asEXECUTION_ERROR
}

/**
    A script execution context
*/
class ScriptContext {
private:
    ScriptEngine engine;

    ~this() {
        // Make sure we don't try to destroy the engine
        this.engine = null;

        // Release the context
        asContext_Release(ctx);
    }

package(as):
    asIScriptContext* ctx;
    
    this(ScriptEngine engine, asIScriptContext* ctx) {
        this.engine = engine;
        this.ctx = ctx;
    }

public:
    /**
        Adds a reference to this script context
    */
    int addRef() {
        return asContext_AddRef(ctx);
    }

    /**
        Releases a reference to this script context
    */
    int release() {
        return asContext_Release(ctx);
    }

    /**
        Gets the script engine this context belongs to
    */
    ScriptEngine getEngine() {
        return engine;
    }

    /**
        Prepares this context
    */
    void prepare(Function func) {
        int err = asContext_Prepare(ctx, func.func);
        assert(err != asERetCodes.asCONTEXT_ACTIVE, "The context is still active or suspended");
        assert(err != asERetCodes.asNO_FUNCTION, "Function pointer is null");
        assert(err != asERetCodes.asINVALID_ARG, "Function is from a different engine than context");
        assert(err != asERetCodes.asOUT_OF_MEMORY, "Context ran out of memory while allocating call stack");
    }

    /**
        Un-prepares this context
    */
    void unprepare() {
        int err = asContext_Unprepare(ctx);
        assert(err != asERetCodes.asCONTEXT_ACTIVE, "The context is still active or suspended");
    }

    /**
        Executes this context
    */
    ContextState execute() {
        int err = asContext_Execute(ctx);
        assert(err != asERetCodes.asCONTEXT_NOT_PREPARED, "The context is still active or not suspended");
        return cast(ContextState)err;
    }

    /**
        Aborts this context
    */
    void abort() {
        int err = asContext_Abort(ctx);
        assert(err != asERetCodes.asERROR, "Invalid context");
    }

    /**
        Suspends this context
    */
    void suspend() {
       int err = asContext_Suspend(ctx);
        assert(err != asERetCodes.asERROR, "Invalid context");
    }

    /**
        Gets the current state of the context
    */
    ContextState getState() {
        return cast(ContextState)asContext_GetState(ctx);
    }

    /**
        Backups current state and prepares state for a nested call
    */
    void pushState() {
        int err = asContext_PushState(ctx);
        assert(err != asERetCodes.asERROR, "Context not active");
        assert(err != asERetCodes.asOUT_OF_MEMORY, "Could not allocate memory for state");
    }

    /**
        Restores previous execution state
    */
    void popState() {
        int err = asContext_PopState(ctx);
        assert(err != asERetCodes.asERROR, "Could not restore state");
    }

    /**
        Gets whether the context has any nested calls
    */
    bool isNested(ref uint nestCount) {
        return asContext_IsNested(ctx, &nestCount);
    }

    /**
        Sets object for class method call
    */
    void setObject(void* obj) {
        asContext_SetObject(ctx, obj);
    }

    /**
        Sets a base type argument

        Notes:
        To set object argument values, use setArgObject
        To set variable arguments, use setArgVarType
    */
    void setArg(T)(asUINT arg, T value) {
        static if (isPointer!T) {
            int err = asContext_SetArgAddress(ctx, arg, value);
        } else static if (T.sizeof == 1) {
            int err = asContext_SetArgByte(ctx, arg, cast(ubyte)value);
        } else static if (T.sizeof == 2) {
            int err = asContext_SetArgWord(ctx, arg, cast(asWORD)value);
        } else static if (T.sizeof == 4) {
            int err = asContext_SetArgDWord(ctx, arg, cast(asDWORD)value);
        } else static if (T.sizeof == 8) {
            int err = asContext_SetArgQWord(ctx, arg, cast(asQWORD)value);
        } else static if (is(T : float)) {
            int err = asContext_SetArgFloat(ctx, arg, value);
        } else static if (is(T : double)) {
            int err = asContext_SetArgDouble(ctx, arg, value);
        } else {
            assert(0, "Type not supported by setArg");
        }
        assert(err != asERetCodes.asCONTEXT_NOT_PREPARED, "The context is not in a prepared state");
        assert(err != asERetCodes.asINVALID_ARG, "Argument is outside function argument bounds");
        assert(err != asERetCodes.asINVALID_TYPE, "Value type does not fit argument type");
    }

    /**
        Sets object/handle argument value
    */
    void setArgObject(asUINT arg, void* value) {
        int err = asContext_SetArgObject(ctx, arg, value);
        assert(err != asERetCodes.asCONTEXT_NOT_PREPARED, "The context is not in a prepared state");
        assert(err != asERetCodes.asINVALID_ARG, "Argument is outside function argument bounds");
        assert(err != asERetCodes.asINVALID_TYPE, "Argument is not a object or handle");
    }

    /**
        Sets the variable argument value and type
    */
    void setArgVarType(T)(asUINT arg, T* ptr, int typeId) {
        int err = asContext_SetArgVarType(ctx, arg, ptr, typeId);
        assert(err != asERetCodes.asCONTEXT_NOT_PREPARED, "The context is not in a prepared state");
        assert(err != asERetCodes.asINVALID_ARG, "Argument is outside function argument bounds");
        assert(err != asERetCodes.asINVALID_TYPE, "Argument is not a variable type");
    }

    /**
        Gets the address of an argument
    */
    void* getAddressOfArg(asUINT arg) {
        return asContext_GetAddressOfArg(ctx, arg);
    }

    /**
        Gets the size of the callstack
    */
    asUINT getCallstackSize() {
        return asContext_GetCallstackSize(ctx);
    }

    /**
        Gets the line number based on stackLevel which the context is currently executing
    */
    int getLineNumber(asUINT stackLevel = 0) {
        return getLineNumber(stackLevel, null);
    }
    
    /**
        Gets the line number, column and sectino name based on stackLevel which the context is currently executing
    */
    int getLineNumber(asUINT stackLevel, int* column) {
        
        // Get the line number and extra stuff
        int ln = asContext_GetLineNumber(ctx, stackLevel, column, null);
        return ln;
    }

    /**
        Sets the user data
    */
    void* setUserData(void* data) {
        return asContext_SetUserData(ctx, data);
    }

    /**
        Gets the user data
    */
    void* getUserData() {
        return asContext_GetUserData(ctx);
    }
}