module as.obj;
import as.def;
import as.engine;
import std.string;
import std.exception;

class ScriptObject {
private:
    ScriptEngine engine;

    ~this() {
        this.engine = null;
    }

package(as):
    asIScriptObject* obj;

    this(ScriptEngine engine, asIScriptObject* obj) {
        this.engine = engine;
        this.obj = obj;
    }

public:

    /**
        Gets the engine this object belongs to
    */
    ScriptEngine getEngine() {
        return engine;
    }

    /**
        Adds a reference to this object
    */
    int addRef() {
        return asObject_AddRef(obj);
    }

    /**
        Releases a reference to this object
    */
    int release() {
        return asObject_Release(obj);
    }

    /**
        Get the count of properties in this object
    */
    asUINT getPropertyCount() {
        return asObject_GetPropertyCount(obj);
    }

    /**
        Get the type ID of a property
    */
    int getPropertyTypeId(asUINT prop) {
        int err = asObject_GetPropertyTypeId(obj, prop);
        enforce(err != asERetCodes.asINVALID_ARG, "prop is too large");
        return err;
    }

    /**
        Get the name of a property
    */
    string getPropertyName(asUINT prop) {
        return cast(string)asObject_GetPropertyName(obj, prop).fromStringz;
    }

    /**
        Get the address of a property
    */
    void* getPropertyAddress(asUINT prop) {
        return asObject_GetAddressOfProperty(obj, prop);
    }
    
    /**
        Copy content from an other object of the same type
    */
    void copyFrom(ScriptObject other) {
        int err = asObject_CopyFrom(obj, other.obj);
        enforce(err != asERetCodes.asINVALID_ARG, "Argument is null");
        enforce(err != asERetCodes.asINVALID_TYPE, "Types of objects didn't match");
    }

    /**
        Sets the user data associated with this object
    */
    void* setUserData(void* data, asPWORD type) {
        return asObject_SetUserData(obj, data, type);
    }

    /**
        Gets the user data associated with this object
    */
    void* getUserData(asPWORD type) {
        return asObject_GetUserData(obj, type);
    }

}