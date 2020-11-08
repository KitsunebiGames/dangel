module as.context;
import as.def;
import as.engine;
import as.func;

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
        asContext_Prepare(ctx, func.func);
    }

    /**
        Un-prepares this context
    */
    void unprepare() {
        asContext_Unprepare(ctx);
    }

    /**
        Executes this context
    */
    void execute() {
        asContext_Execute(ctx);
    }

    /**
        Aborts this context
    */
    void abort() {
        asContext_Abort(ctx);
    }

    /**
        Suspends this context
    */
    void suspend() {
        asContext_Suspend(ctx);
    }

    /**
        Gets the current state of the context
    */
    asEContextState getState() {
        return asContext_GetState(ctx);
    }

    void pushState() {
        asContext_PushState(ctx);
    }

    void popState() {
        asContext_PopState(ctx);
    }

    bool isNested(ref uint nestCount) {
        return asContext_IsNested(ctx, &nestCount);
    }

    void setObject(void* obj) {
        asContext_SetObject(ctx, obj);
    }

    void* setUserData(void* data) {
        return asContext_SetUserData(ctx, data);
    }

    void* getUserData() {
        return asContext_GetUserData(ctx);
    }
}