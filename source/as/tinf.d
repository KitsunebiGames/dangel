module as.tinf;
import as.def;
import as.engine;
import as.mod;
import std.exception;
import std.string;

/**
    Angelscript type info
*/
class Type {
private:
    ScriptEngine engine;
    Module mod;

    ~this() {
        this.engine = null;
    }

package(as):
    asITypeInfo* info;

    this(ScriptEngine engine, asITypeInfo* info) {
        this.engine = engine;
        this.mod = new Module(engine, asTypeInfo_GetModule(info));
        this.info = info;
    }

    this(ScriptEngine engine, Module mod, asITypeInfo* info) {
        this.engine = engine;
        this.mod = mod;
        this.info = info;
    }

public:
    /**
        Gets the scripting engine this type belongs to
    */
    ScriptEngine getEngine() {
        return engine;
    }

    /**
        Gets the config group this type belongs to
    */
    string getConfigGroup() {
        return cast(string)asTypeInfo_GetConfigGroup(info).fromStringz;
    }

    /**
        Gets this type's access mask
    */
    asDWORD getAccessMask() {
        return asTypeInfo_GetAccessMask(info);
    }

    /**
        Gets the module this type belongs to
    */
    Module getModule() {
        return mod;
    }

    /**
        Add a reference to this type
    */
    int addRef() {
        return asTypeInfo_AddRef(info);
    }

    /**
        Release a reference from this type
    */
    int release() {
        return asTypeInfo_Release(info);
    }

    /**
        Gets the name of this type
    */
    string getName() {
        return cast(string)asTypeInfo_GetName(info).fromStringz;
    }

    /**
        Gets this type's namespace
    */
    string getNamespace() {
        return cast(string)asTypeInfo_GetNamespace(info).fromStringz;
    }

    /**
        Gets this type's base type

        This method will return null if this type has no base type
    */
    Type getBaseType() {
        auto baseType = asTypeInfo_GetBaseType(info);
        return baseType !is null ? new Type(engine, baseType) : null;
    } 
    
    /**
        Gets whether this type derives from the specified other type
    */
    bool derivesFrom(Type other) {
        return asTypeInfo_DerivesFrom(info, other.info);
    }

    /**
        Gets this type's flags
    */
    asDWORD getFlags() {
        return asTypeInfo_GetFlags(info);
    }

    /**
        Gets the size in bytes of this type
    */
    asUINT getSize() {
        return asTypeInfo_GetSize(info);
    }

    /**
        Gets this type's type id
    */
    int getTypeId() {
        return asTypeInfo_GetTypeId(info);
    }

    /**
        Gets the id the specified subtype
    */
    int getSubTypeId(asUINT subtypeIndex) {
        return asTypeInfo_GetSubTypeId(info, subtypeIndex);
    }

    /**
        Gets the subtype by its index

        Returns null if there's no subtype at that index
    */
    Type getSubType(asUINT subtypeIndex) {
        auto subType = asTypeInfo_GetSubType(info, subtypeIndex);
        return subType !is null ? new Type(engine, subType) : null;
    }

    /**
        Gets the amount of subtypes this type has
    */
    asUINT getSubTypeCount() {
        return asTypeInfo_GetSubTypeCount(info);
    }

    /**
        Gets the amount of interfaces this type implements
    */
    asUINT getInterfaceCount() {
        return asTypeInfo_GetInterfaceCount(info);
    }

    /**
        Gets the interface at the specified index

        Returns null if there's no interface at that index
    */
    Type getInterface(asUINT index) {
        auto iface = asTypeInfo_GetInterface(info, index);
        return iface !is null ? new Type(engine, iface) : null;
    }

    /**
        Gets whether this type implements the specified interface
    */
    bool implements(Type other) {
        return asTypeInfo_Implements(info, other.info);
    }
}
