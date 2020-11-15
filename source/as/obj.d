module as.obj;
import as.def;
import as.engine;
import std.string;

enum TypeFlags : asEObjTypeFlags {
    Ref = asEObjTypeFlags.asOBJ_REF,
    Value = asEObjTypeFlags.asOBJ_VALUE,
    GC = asEObjTypeFlags.asOBJ_GC,
    POD = asEObjTypeFlags.asOBJ_POD,
    NoHandle = asEObjTypeFlags.asOBJ_NOHANDLE,
    Scoped = asEObjTypeFlags.asOBJ_SCOPED,
    Template = asEObjTypeFlags.asOBJ_TEMPLATE,
    ASHandle = asEObjTypeFlags.asOBJ_ASHANDLE,
    Class = asEObjTypeFlags.asOBJ_APP_CLASS,
    ClassConstruct = asEObjTypeFlags.asOBJ_APP_CLASS_CONSTRUCTOR,
    ClassDestruct = asEObjTypeFlags.asOBJ_APP_CLASS_DESTRUCTOR,
    ClassAssign = asEObjTypeFlags.asOBJ_APP_CLASS_ASSIGNMENT,
    ClassCopyConstruct = asEObjTypeFlags.asOBJ_APP_CLASS_COPY_CONSTRUCTOR,
    C = asEObjTypeFlags.asOBJ_APP_CLASS_C,
    CD = asEObjTypeFlags.asOBJ_APP_CLASS_CD,
    CA = asEObjTypeFlags.asOBJ_APP_CLASS_CA,
    CK = asEObjTypeFlags.asOBJ_APP_CLASS_CK,
    CDA = asEObjTypeFlags.asOBJ_APP_CLASS_CDA,
    CDK = asEObjTypeFlags.asOBJ_APP_CLASS_CDK,
    CAK = asEObjTypeFlags.asOBJ_APP_CLASS_CAK,
    CDAK = asEObjTypeFlags.asOBJ_APP_CLASS_CDAK,
    D = asEObjTypeFlags.asOBJ_APP_CLASS_D,
    DA = asEObjTypeFlags.asOBJ_APP_CLASS_DA,
    DK = asEObjTypeFlags.asOBJ_APP_CLASS_DK,
    DAK = asEObjTypeFlags.asOBJ_APP_CLASS_DAK,
    A = asEObjTypeFlags.asOBJ_APP_CLASS_A,
    AK = asEObjTypeFlags.asOBJ_APP_CLASS_AK,
    K = asEObjTypeFlags.asOBJ_APP_CLASS_K,
    Primitive = asEObjTypeFlags.asOBJ_APP_PRIMITIVE,
    Float = asEObjTypeFlags.asOBJ_APP_FLOAT,
    Array = asEObjTypeFlags.asOBJ_APP_ARRAY,
    AllInts = asEObjTypeFlags.asOBJ_APP_CLASS_ALLINTS,
    AllFloats = asEObjTypeFlags.asOBJ_APP_CLASS_ALLFLOATS,
    NoCount = asEObjTypeFlags.asOBJ_NOCOUNT,
    Align8 = asEObjTypeFlags.asOBJ_APP_CLASS_ALIGN8,
    ImplicitHandle = asEObjTypeFlags.asOBJ_IMPLICIT_HANDLE,
    ValidFlagsMask = asEObjTypeFlags.asOBJ_MASK_VALID_FLAGS,

    // Internal flags
    ScriptObject = asEObjTypeFlags.asOBJ_SCRIPT_OBJECT,
    Shared = asEObjTypeFlags.asOBJ_SHARED,
    NoInherit = asEObjTypeFlags.asOBJ_NOINHERIT,
    FuncDef = asEObjTypeFlags.asOBJ_FUNCDEF,
    ListPattern = asEObjTypeFlags.asOBJ_LIST_PATTERN,
    Enum = asEObjTypeFlags.asOBJ_ENUM,
    TemplateSubtype = asEObjTypeFlags.asOBJ_TEMPLATE_SUBTYPE,
    TypeDef = asEObjTypeFlags.asOBJ_TYPEDEF,
    Abstract = asEObjTypeFlags.asOBJ_ABSTRACT,
    Align16 = asEObjTypeFlags.asOBJ_APP_ALIGN16
}

enum Behaviours : asEBehaviours {
	// Value object memory management
	Construct = asEBehaviours.asBEHAVE_CONSTRUCT,
	ListConstruct = asEBehaviours.asBEHAVE_LIST_CONSTRUCT,
	Destruct = asEBehaviours.asBEHAVE_DESTRUCT,

	// Reference object memory management
	Factory = asEBehaviours.asBEHAVE_FACTORY,
	ListFactory = asEBehaviours.asBEHAVE_LIST_FACTORY,
	AddRef = asEBehaviours.asBEHAVE_ADDREF,
	Release = asEBehaviours.asBEHAVE_RELEASE,
	GetWeakrefFlag = asEBehaviours.asBEHAVE_GET_WEAKREF_FLAG,

	// Object operators
	TemplateCallback = asEBehaviours.asBEHAVE_TEMPLATE_CALLBACK,

	// Garbage collection behaviours
	FirstGC = asEBehaviours.asBEHAVE_FIRST_GC,
	GetRefCount = asEBehaviours.asBEHAVE_GETREFCOUNT,
	SetGCFlag = asEBehaviours.asBEHAVE_SETGCFLAG,
	GetGCFlag = asEBehaviours.asBEHAVE_GETGCFLAG,
	EnumRefs = asEBehaviours.asBEHAVE_ENUMREFS,
	ReleaseRefs = asEBehaviours.asBEHAVE_RELEASEREFS,
	LastGC = asEBehaviours.asBEHAVE_LAST_GC,

	BehaveMax = asEBehaviours.asBEHAVE_MAX
}

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
        assert(err != asERetCodes.asINVALID_ARG, "prop is too large");
        return err;
    }

    /**
        Get the name of a property
    */
    string getPropertyName(asUINT prop) {
        return cast(string) asObject_GetPropertyName(obj, prop).fromStringz;
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
        assert(err != asERetCodes.asINVALID_ARG, "Argument is null");
        assert(err != asERetCodes.asINVALID_TYPE, "Types of objects didn't match");
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
