module as.def;

enum ANGELSCRIPT_VERSION = 23400;

extern(C) {
	struct asIScriptEngine;
	struct asIScriptModule;
	struct asIScriptContext;
	struct asIScriptGeneric;
	struct asIScriptObject;
	struct asITypeInfo;
	struct asIScriptFunction;
	struct asIBinaryStream;
	struct asIJITCompiler;
	struct asIThreadManager;
	struct asILockableSharedBool;
}

enum asERetCodes {
	asSUCCESS                              =  0,
	asERROR                                = -1,
	asCONTEXT_ACTIVE                       = -2,
	asCONTEXT_NOT_FINISHED                 = -3,
	asCONTEXT_NOT_PREPARED                 = -4,
	asINVALID_ARG                          = -5,
	asNO_FUNCTION                          = -6,
	asNOT_SUPPORTED                        = -7,
	asINVALID_NAME                         = -8,
	asNAME_TAKEN                           = -9,
	asINVALID_DECLARATION                  = -10,
	asINVALID_OBJECT                       = -11,
	asINVALID_TYPE                         = -12,
	asALREADY_REGISTERED                   = -13,
	asMULTIPLE_FUNCTIONS                   = -14,
	asNO_MODULE                            = -15,
	asNO_GLOBAL_VAR                        = -16,
	asINVALID_CONFIGURATION                = -17,
	asINVALID_INTERFACE                    = -18,
	asCANT_BIND_ALL_FUNCTIONS              = -19,
	asLOWER_ARRAY_DIMENSION_NOT_REGISTERED = -20,
	asWRONG_CONFIG_GROUP                   = -21,
	asCONFIG_GROUP_IS_IN_USE               = -22,
	asILLEGAL_BEHAVIOUR_FOR_TYPE           = -23,
	asWRONG_CALLING_CONV                   = -24,
	asBUILD_IN_PROGRESS                    = -25,
	asINIT_GLOBAL_VARS_FAILED              = -26,
	asOUT_OF_MEMORY                        = -27,
	asMODULE_IS_IN_USE                     = -28
}

enum asEEngineProp
{
	asEP_ALLOW_UNSAFE_REFERENCES            = 1,
	asEP_OPTIMIZE_BYTECODE                  = 2,
	asEP_COPY_SCRIPT_SECTIONS               = 3,
	asEP_MAX_STACK_SIZE                     = 4,
	asEP_USE_CHARACTER_LITERALS             = 5,
	asEP_ALLOW_MULTILINE_STRINGS            = 6,
	asEP_ALLOW_IMPLICIT_HANDLE_TYPES        = 7,
	asEP_BUILD_WITHOUT_LINE_CUES            = 8,
	asEP_INIT_GLOBAL_VARS_AFTER_BUILD       = 9,
	asEP_REQUIRE_ENUM_SCOPE                 = 10,
	asEP_SCRIPT_SCANNER                     = 11,
	asEP_INCLUDE_JIT_INSTRUCTIONS           = 12,
	asEP_STRING_ENCODING                    = 13,
	asEP_PROPERTY_ACCESSOR_MODE             = 14,
	asEP_EXPAND_DEF_ARRAY_TO_TMPL           = 15,
	asEP_AUTO_GARBAGE_COLLECT               = 16,
	asEP_DISALLOW_GLOBAL_VARS               = 17,
	asEP_ALWAYS_IMPL_DEFAULT_CONSTRUCT      = 18,
	asEP_COMPILER_WARNINGS                  = 19,
	asEP_DISALLOW_VALUE_ASSIGN_FOR_REF_TYPE = 20,
	asEP_ALTER_SYNTAX_NAMED_ARGS            = 21,
	asEP_DISABLE_INTEGER_DIVISION           = 22,
	asEP_DISALLOW_EMPTY_LIST_ELEMENTS       = 23,
	asEP_PRIVATE_PROP_AS_PROTECTED          = 24,
	asEP_ALLOW_UNICODE_IDENTIFIERS          = 25,
	asEP_HEREDOC_TRIM_MODE                  = 26,

	asEP_LAST_PROPERTY
}


enum asECallConvTypes
{
	asCALL_CDECL                  = 0,
	asCALL_STDCALL                = 1,
	asCALL_THISCALL_ASGLOBAL      = 2,
	asCALL_THISCALL               = 3,
	asCALL_CDECL_OBJLAST          = 4,
	asCALL_CDECL_OBJFIRST         = 5,
	asCALL_GENERIC                = 6,
	asCALL_THISCALL_OBJLAST       = 7,
	asCALL_THISCALL_OBJFIRST      = 8,
	asCALL_DDECL                  = 9,
	asCALL_DDECL_OBJLAST          = 10,
	asCALL_DDECL_OBJFIRST         = 11,
}

enum asEObjTypeFlags
{
	asOBJ_REF                        = (1<<0),
	asOBJ_VALUE                      = (1<<1),
	asOBJ_GC                         = (1<<2),
	asOBJ_POD                        = (1<<3),
	asOBJ_NOHANDLE                   = (1<<4),
	asOBJ_SCOPED                     = (1<<5),
	asOBJ_TEMPLATE                   = (1<<6),
	asOBJ_ASHANDLE                   = (1<<7),
	asOBJ_APP_CLASS                  = (1<<8),
	asOBJ_APP_CLASS_CONSTRUCTOR      = (1<<9),
	asOBJ_APP_CLASS_DESTRUCTOR       = (1<<10),
	asOBJ_APP_CLASS_ASSIGNMENT       = (1<<11),
	asOBJ_APP_CLASS_COPY_CONSTRUCTOR = (1<<12),
	asOBJ_APP_CLASS_C                = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR),
	asOBJ_APP_CLASS_CD               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_DESTRUCTOR),
	asOBJ_APP_CLASS_CA               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT),
	asOBJ_APP_CLASS_CK               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_CDA              = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT),
	asOBJ_APP_CLASS_CDK              = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_CAK              = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_CDAK             = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_CONSTRUCTOR + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_D                = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_DESTRUCTOR),
	asOBJ_APP_CLASS_DA               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT),
	asOBJ_APP_CLASS_DK               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_DAK              = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_DESTRUCTOR + asOBJ_APP_CLASS_ASSIGNMENT + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_A                = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_ASSIGNMENT),
	asOBJ_APP_CLASS_AK               = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_ASSIGNMENT + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_CLASS_K                = (asOBJ_APP_CLASS + asOBJ_APP_CLASS_COPY_CONSTRUCTOR),
	asOBJ_APP_PRIMITIVE              = (1<<13),
	asOBJ_APP_FLOAT                  = (1<<14),
	asOBJ_APP_ARRAY                  = (1<<15),
	asOBJ_APP_CLASS_ALLINTS          = (1<<16),
	asOBJ_APP_CLASS_ALLFLOATS        = (1<<17),
	asOBJ_NOCOUNT                    = (1<<18),
	asOBJ_APP_CLASS_ALIGN8           = (1<<19),
	asOBJ_IMPLICIT_HANDLE            = (1<<20),
	asOBJ_MASK_VALID_FLAGS           = 0x1FFFFF,
	// Internal flags
	asOBJ_SCRIPT_OBJECT              = (1<<21),
	asOBJ_SHARED                     = (1<<22),
	asOBJ_NOINHERIT                  = (1<<23),
	asOBJ_FUNCDEF                    = (1<<24),
	asOBJ_LIST_PATTERN               = (1<<25),
	asOBJ_ENUM                       = (1<<26),
	asOBJ_TEMPLATE_SUBTYPE           = (1<<27),
	asOBJ_TYPEDEF                    = (1<<28),
	asOBJ_ABSTRACT                   = (1<<29),
	asOBJ_APP_ALIGN16                = (1<<30)
}

enum asEBehaviours
{
	// Value object memory management
	asBEHAVE_CONSTRUCT,
	asBEHAVE_LIST_CONSTRUCT,
	asBEHAVE_DESTRUCT,

	// Reference object memory management
	asBEHAVE_FACTORY,
	asBEHAVE_LIST_FACTORY,
	asBEHAVE_ADDREF,
	asBEHAVE_RELEASE,
	asBEHAVE_GET_WEAKREF_FLAG,

	// Object operators
	asBEHAVE_TEMPLATE_CALLBACK,

	// Garbage collection behaviours
	asBEHAVE_FIRST_GC,
	 asBEHAVE_GETREFCOUNT = asBEHAVE_FIRST_GC,
	 asBEHAVE_SETGCFLAG,
	 asBEHAVE_GETGCFLAG,
	 asBEHAVE_ENUMREFS,
	 asBEHAVE_RELEASEREFS,
	asBEHAVE_LAST_GC = asBEHAVE_RELEASEREFS,

	asBEHAVE_MAX
}

enum asEContextState
{
	asEXECUTION_FINISHED      = 0,
	asEXECUTION_SUSPENDED     = 1,
	asEXECUTION_ABORTED       = 2,
	asEXECUTION_EXCEPTION     = 3,
	asEXECUTION_PREPARED      = 4,
	asEXECUTION_UNINITIALIZED = 5,
	asEXECUTION_ACTIVE        = 6,
	asEXECUTION_ERROR         = 7
}

enum asEMsgType
{
	asMSGTYPE_ERROR       = 0,
	asMSGTYPE_WARNING     = 1,
	asMSGTYPE_INFORMATION = 2
}

enum asEGCFlags
{
	asGC_FULL_CYCLE      = 1,
	asGC_ONE_STEP        = 2,
	asGC_DESTROY_GARBAGE = 4,
	asGC_DETECT_GARBAGE  = 8
}

enum asETokenClass
{
	asTC_UNKNOWN    = 0,
	asTC_KEYWORD    = 1,
	asTC_VALUE      = 2,
	asTC_IDENTIFIER = 3,
	asTC_COMMENT    = 4,
	asTC_WHITESPACE = 5
}

enum asETypeIdFlags
{
	asTYPEID_VOID           = 0,
	asTYPEID_BOOL           = 1,
	asTYPEID_INT8           = 2,
	asTYPEID_INT16          = 3,
	asTYPEID_INT32          = 4,
	asTYPEID_INT64          = 5,
	asTYPEID_UINT8          = 6,
	asTYPEID_UINT16         = 7,
	asTYPEID_UINT32         = 8,
	asTYPEID_UINT64         = 9,
	asTYPEID_FLOAT          = 10,
	asTYPEID_DOUBLE         = 11,
	asTYPEID_OBJHANDLE      = 0x40000000,
	asTYPEID_HANDLETOCONST  = 0x20000000,
	asTYPEID_MASK_OBJECT    = 0x1C000000,
	asTYPEID_APPOBJECT      = 0x04000000,
	asTYPEID_SCRIPTOBJECT   = 0x08000000,
	asTYPEID_TEMPLATE       = 0x10000000,
	asTYPEID_MASK_SEQNBR    = 0x03FFFFFF
}

enum asETypeModifiers
{
	asTM_NONE     = 0,
	asTM_INREF    = 1,
	asTM_OUTREF   = 2,
	asTM_INOUTREF = 3,
	asTM_CONST    = 4
}

enum asEGMFlags
{
	asGM_ONLY_IF_EXISTS       = 0,
	asGM_CREATE_IF_NOT_EXISTS = 1,
	asGM_ALWAYS_CREATE        = 2
}

enum
{
	asCOMP_ADD_TO_MODULE = 1
}

enum asEFuncType
{
	asFUNC_DUMMY     =-1,
	asFUNC_SYSTEM    = 0,
	asFUNC_SCRIPT    = 1,
	asFUNC_INTERFACE = 2,
	asFUNC_VIRTUAL   = 3,
	asFUNC_FUNCDEF   = 4,
	asFUNC_IMPORTED  = 5,
	asFUNC_DELEGATE  = 6
}

alias asBYTE = ubyte;
alias asWORD = ushort;
alias asDWORD = uint;
alias asQWORD = ulong;
alias asPWORD = size_t;
alias asINT64 = long;
alias asBOOL = bool;
alias asUINT = uint;

@system extern(C) {
	alias asFUNCTION_t 					= void function();
	alias asBINARYREADFUNC_t 			= void function(void* ptr, asUINT size, void* param);
	alias asBINARYWRITEFUNC_t 			= void function(const(void)* ptr, asUINT size, void* param);
	alias asGENFUNC_t 					= void function(asIScriptGeneric*);
	alias asALLOCFUNC_t 				= void* function(size_t);
	alias asFREEFUNC_t 					= void function(void*);
	alias asCLEANENGINEFUNC_t 			= void function(asIScriptEngine*);
	alias asCLEANMODULEFUNC_t 			= void function(asIScriptModule*);
	alias asCLEANCONTEXTFUNC_t 			= void function(asIScriptContext*);
	alias asCLEANFUNCTIONFUNC_t 		= void function(asIScriptFunction*);
	alias asCLEANTYPEINFOFUNC_t 		= void function(asITypeInfo*);
	alias asCLEANSCRIPTOBJECTFUNC_t 	= void function(asIScriptObject*);
	alias asREQUESTCONTEXTFUNC_t 		= asIScriptContext* function(asIScriptEngine*, void*);
	alias asRETURNCONTEXTFUNC_t 		= void function(asIScriptEngine*, asIScriptContext*, void*);
	alias asMESSAGECALLBACKFUNC_t 		= void function(asSMessageInfo* msg, void*);

	alias asGETSTRINGCONSTFUNC_t		= void* function(const(char)* data, asUINT length);
	alias asRELEASESTRINGCONSTFUNC_t 	= int function(const(void)* str);
	alias asGETRAWSTRINGDATAFUNC_t		= int function(const(void)* str, char* data, asUINT* length);
}

struct asSMessageInfo {
	const(char)* 	section;
	int				row;
	int				col;
	asEMsgType		type;
	const(char)*	message;
}

@trusted extern(C) {
	// Engine
	asIScriptEngine *asCreateScriptEngine(asDWORD version_);
	const(char)      *asGetLibraryVersion();
	const(char)      *asGetLibraryOptions();

	// Context
	asIScriptContext *asGetActiveContext();

	// Thread support
	int               asPrepareMultithread(asIThreadManager *externalMgr);
	void              asUnprepareMultithread();
	asIThreadManager* asGetThreadManager();
	void              asAcquireExclusiveLock();
	void              asReleaseExclusiveLock();
	void              asAcquireSharedLock();
	void              asReleaseSharedLock();
	int               asAtomicInc(ref int value);
	int               asAtomicDec(ref int value);
	int               asThreadCleanup();

	// Memory management
	int   asSetGlobalMemoryFunctions(asALLOCFUNC_t allocFunc, asFREEFUNC_t freeFunc);
	int   asResetGlobalMemoryFunctions();
	void *asAllocMem(size_t size);
	void  asFreeMem(void *mem);

	// Auxiliary
	asILockableSharedBool *asCreateLockableSharedBool();

	///////////////////////////////////////////
	// asIScriptEngine
	
	// Memory management
	int                asEngine_AddRef(asIScriptEngine *e);
	int                asEngine_Release(asIScriptEngine *e);
	int                asEngine_ShutDownAndRelease(asIScriptEngine *e);

	// Engine properties
	int                asEngine_SetEngineProperty(asIScriptEngine *e, asEEngineProp property, asPWORD value);
	asPWORD            asEngine_GetEngineProperty(asIScriptEngine *e, asEEngineProp property);

	// Compiler messages
	int                asEngine_SetMessageCallback(asIScriptEngine *e, asFUNCTION_t callback, void *obj, asDWORD callConv);
	int                asEngine_ClearMessageCallback(asIScriptEngine *e);
	int                asEngine_WriteMessage(asIScriptEngine *e, const(char) *section, int row, int col, asEMsgType type, const(char) *message);

	// JIT Compiler
	int                asEngine_SetJITCompiler(asIScriptEngine *e, asIJITCompiler *compiler);
	asIJITCompiler *   asEngine_GetJITCompiler(asIScriptEngine *e);

	// Global functions
	int                asEngine_RegisterGlobalFunction(asIScriptEngine *e, const(char) *declaration, asFUNCTION_t funcPointer, asDWORD callConv, void *auxiliary);
	asUINT             asEngine_GetGlobalFunctionCount(asIScriptEngine *e);
	asIScriptFunction* asEngine_GetGlobalFunctionByIndex(asIScriptEngine *e, asUINT index);
	asIScriptFunction* asEngine_GetGlobalFunctionByDecl(asIScriptEngine *e, const(char) *declaration);

	// Global properties
	int                asEngine_RegisterGlobalProperty(asIScriptEngine *e, const(char) *declaration, void *pointer);
	asUINT             asEngine_GetGlobalPropertyCount(asIScriptEngine *e);
	int                asEngine_GetGlobalPropertyByIndex(asIScriptEngine *e, asUINT index, const(char) **name, const(char) **nameSpace, int *typeId, asBOOL *isConst, const(char) **configGroup, void **pointer, asDWORD *accessMask);
	int                asEngine_GetGlobalPropertyIndexByName(asIScriptEngine *e, const(char) *name);
	int                asEngine_GetGlobalPropertyIndexByDecl(asIScriptEngine *e, const(char) *decl);

	// Object types
	int                asEngine_RegisterObjectType(asIScriptEngine *e, const(char) *name, int byteSize, asDWORD flags);
	int                asEngine_RegisterObjectProperty(asIScriptEngine *e, const(char) *obj, const(char) *declaration, int byteOffset);
	int                asEngine_RegisterObjectMethod(asIScriptEngine *e, const(char) *obj, const(char) *declaration, asFUNCTION_t funcPointer, asDWORD callConv, void *auxiliary);
	int                asEngine_RegisterObjectBehaviour(asIScriptEngine *e, const(char) *datatype, asEBehaviours behaviour, const(char) *declaration, asFUNCTION_t funcPointer, asDWORD callConv, void *auxiliary);
	int                asEngine_RegisterInterface(asIScriptEngine *e, const(char) *name);
	int                asEngine_RegisterInterfaceMethod(asIScriptEngine *e, const(char) *intf, const(char) *declaration);
	asUINT             asEngine_GetObjectTypeCount(asIScriptEngine *e);
	asITypeInfo *      asEngine_GetObjectTypeByIndex(asIScriptEngine *e, asUINT index);

	// String factory
	int                asEngine_RegisterStringFactory(asIScriptEngine *e, const(char) *datatype, asGETSTRINGCONSTFUNC_t getStr, asRELEASESTRINGCONSTFUNC_t releaseStr, asGETRAWSTRINGDATAFUNC_t getRawStr);
	int                asEngine_GetStringFactoryReturnTypeId(asIScriptEngine *e, asDWORD *flags);

	// Default array type
	int                asEngine_RegisterDefaultArrayType(asIScriptEngine *e, const(char) *type);
	int                asEngine_GetDefaultArrayTypeId(asIScriptEngine *e);

	// Enums
	int                asEngine_RegisterEnum(asIScriptEngine *e, const(char) *type);
	int                asEngine_RegisterEnumValue(asIScriptEngine *e, const(char) *type, const(char) *name, int value);
	asUINT             asEngine_GetEnumCount(asIScriptEngine *e);
	asITypeInfo *      asEngine_GetEnumByIndex(asIScriptEngine *e, asUINT index);

	// Funcdefs
	int                asEngine_RegisterFuncdef(asIScriptEngine *e, const(char) *decl);
	asUINT             asEngine_GetFuncdefCount(asIScriptEngine *e);
	asITypeInfo *      asEngine_GetFuncdefByIndex(asIScriptEngine *e, asUINT index);

	// Typedefs
	int                asEngine_RegisterTypedef(asIScriptEngine *e, const(char) *type, const(char) *decl);
	asUINT             asEngine_GetTypedefCount(asIScriptEngine *e);
	asITypeInfo *      asEngine_GetTypedefByIndex(asIScriptEngine *e, asUINT index);

	// Configuration groups
	int                asEngine_BeginConfigGroup(asIScriptEngine *e, const(char) *groupName);
	int                asEngine_EndConfigGroup(asIScriptEngine *e);
	int                asEngine_RemoveConfigGroup(asIScriptEngine *e, const(char) *groupName);
	asDWORD            asEngine_SetDefaultAccessMask(asIScriptEngine *e, asDWORD defaultMask);
	int                asEngine_SetDefaultNamespace(asIScriptEngine *e, const(char) *nameSpace);
	const(char) *       asEngine_GetDefaultNamespace(asIScriptEngine *e);

	// Script modules
	asIScriptModule *  asEngine_GetModule(asIScriptEngine *e, const(char)* module_, asEGMFlags flag);
	int                asEngine_DiscardModule(asIScriptEngine *e, const(char)* module_);
	asUINT             asEngine_GetModuleCount(asIScriptEngine *e);
	asIScriptModule *  asEngine_GetModuleByIndex(asIScriptEngine *e, asUINT index);

	// Script functions
	asIScriptFunction *asEngine_GetFunctionById(asIScriptEngine *e, int funcId);

	// Type identification
	int                asEngine_GetTypeIdByDecl(asIScriptEngine *e, const(char) *decl);
	const(char) *       asEngine_GetTypeDeclaration(asIScriptEngine *e, int typeId, asBOOL includeNamespace);
	int                asEngine_GetSizeOfPrimitiveType(asIScriptEngine *e, int typeId);
	asITypeInfo   *asEngine_GetTypeInfoById(asIScriptEngine *e, int typeId);
	asITypeInfo   *asEngine_GetTypeInfoByName(asIScriptEngine *e, const(char) *name);
	asITypeInfo   *asEngine_GetTypeInfoByDecl(asIScriptEngine *e, const(char) *decl);

	// Script execution
	asIScriptContext *     asEngine_CreateContext(asIScriptEngine *e);
	void *                 asEngine_CreateScriptObject(asIScriptEngine *e, asITypeInfo *type);
	void *                 asEngine_CreateScriptObjectCopy(asIScriptEngine *e, void *obj, asITypeInfo *type);
	void *                 asEngine_CreateUninitializedScriptObject(asIScriptEngine *e, asITypeInfo *type);
	asIScriptFunction *    asEngine_CreateDelegate(asIScriptEngine *e, asIScriptFunction *func, void *obj);
	int                    asEngine_AssignScriptObject(asIScriptEngine *e, void *dstObj, void *srcObj, asITypeInfo *type);
	void                   asEngine_ReleaseScriptObject(asIScriptEngine *e, void *obj, asITypeInfo *type);
	void                   asEngine_AddRefScriptObject(asIScriptEngine *e, void *obj, asITypeInfo *type);
	int                    asEngine_RefCastObject(asIScriptEngine *e, void *obj, asITypeInfo *fromType, asITypeInfo *toType, void **newPtr, bool useOnlyImplicitCast);
	asILockableSharedBool *asEngine_GetWeakRefFlagOfScriptObject(asIScriptEngine *e, void *obj, asITypeInfo *type);

	// Context pooling
	asIScriptContext      *asEngine_RequestContext(asIScriptEngine *e);
	void                   asEngine_ReturnContext(asIScriptEngine *e, asIScriptContext *ctx);
	int                    asEngine_SetContextCallbacks(asIScriptEngine *e, asREQUESTCONTEXTFUNC_t requestCtx, asRETURNCONTEXTFUNC_t returnCtx, void *param);

	// String interpretation
	asETokenClass      asEngine_ParseToken(asIScriptEngine *e, const(char) *string, size_t stringLength, asUINT *tokenLength);

	// Garbage collection
	int                asEngine_GarbageCollect(asIScriptEngine *e, asDWORD flags);
	void               asEngine_GetGCStatistics(asIScriptEngine *e, asUINT *currentSize, asUINT *totalDestroyed, asUINT *totalDetected, asUINT *newObjects, asUINT *totalNewDestroyed);
	int                asEngine_NotifyGarbageCollectorOfNewObject(asIScriptEngine *e, void *obj, asITypeInfo *type);
	int                asEngine_GetObjectInGC(asIScriptEngine *e, asUINT idx, asUINT *seqNbr, void **obj, asITypeInfo **type);
	void               asEngine_GCEnumCallback(asIScriptEngine *e, void *obj);

	// User data
	void *             asEngine_SetUserData(asIScriptEngine *e, void *data, asPWORD type);
	void *             asEngine_GetUserData(asIScriptEngine *e, asPWORD type);
	void               asEngine_SetEngineUserDataCleanupCallback(asIScriptEngine *e, asCLEANENGINEFUNC_t callback, asPWORD type);
	void               asEngine_SetModuleUserDataCleanupCallback(asIScriptEngine *e, asCLEANMODULEFUNC_t callback);
	void               asEngine_SetContextUserDataCleanupCallback(asIScriptEngine *e, asCLEANCONTEXTFUNC_t callback);
	void               asEngine_SetFunctionUserDataCleanupCallback(asIScriptEngine *e, asCLEANFUNCTIONFUNC_t callback);
	void               asEngine_SetTypeInfoUserDataCleanupCallback(asIScriptEngine *e, asCLEANTYPEINFOFUNC_t callback, asPWORD type);
	void               asEngine_SetScriptObjectUserDataCleanupCallback(asIScriptEngine *e, asCLEANSCRIPTOBJECTFUNC_t callback, asPWORD type);

	///////////////////////////////////////////
	// asIScriptModule

	asIScriptEngine   *asModule_GetEngine(asIScriptModule *m);
	void               asModule_SetName(asIScriptModule *m, const(char) *name);
	const(char)        *asModule_GetName(asIScriptModule *m); 
	void               asModule_Discard(asIScriptModule *m);

	// Compilation
	int                asModule_AddScriptSection(asIScriptModule *m, const(char) *name, const(char) *code, size_t codeLength, int lineOffset);
	int                asModule_Build(asIScriptModule *m);
	int                asModule_CompileFunction(asIScriptModule *m, const(char) *sectionName, const(char) *code, int lineOffset, asDWORD compileFlags, asIScriptFunction **outFunc);
	int                asModule_CompileGlobalVar(asIScriptModule *m, const(char) *sectionName, const(char) *code, int lineOffset);
	asDWORD            asModule_SetAccessMask(asIScriptModule *m, asDWORD accessMask);
	int                asModule_SetDefaultNamespace(asIScriptModule *m,const(char) *nameSpace);
	const(char)        *asModule_GetDefaultNamespace(asIScriptModule *m);

	// Functions
	asUINT             asModule_GetFunctionCount(asIScriptModule *m);
	asIScriptFunction *asModule_GetFunctionByIndex(asIScriptModule *m, asUINT index);
	asIScriptFunction *asModule_GetFunctionByDecl(asIScriptModule *m, const(char) *decl);
	asIScriptFunction *asModule_GetFunctionByName(asIScriptModule *m, const(char) *name); 
	int                asModule_RemoveFunction(asIScriptModule *m, asIScriptFunction *func);

	// Global variables
	int                asModule_ResetGlobalVars(asIScriptModule *m, asIScriptContext *ctx);
	asUINT             asModule_GetGlobalVarCount(asIScriptModule *m);
	int                asModule_GetGlobalVarIndexByName(asIScriptModule *m, const(char) *name);
	int                asModule_GetGlobalVarIndexByDecl(asIScriptModule *m, const(char) *decl);
	const(char)        *asModule_GetGlobalVarDeclaration(asIScriptModule *m, asUINT index, asBOOL includeNamespace);
	int                asModule_GetGlobalVar(asIScriptModule *m, asUINT index, const(char) **name, const(char) **nameSpace, int *typeId, asBOOL *isConst);
	void              *asModule_GetAddressOfGlobalVar(asIScriptModule *m, asUINT index);
	int                asModule_RemoveGlobalVar(asIScriptModule *m, asUINT index);

	// Type identification
	asUINT             asModule_GetObjectTypeCount(asIScriptModule *m);
	asITypeInfo       *asModule_GetObjectTypeByIndex(asIScriptModule *m, asUINT index);
	int                asModule_GetTypeIdByDecl(asIScriptModule *m, const(char) *decl);
	asITypeInfo       *asModule_GetTypeInfoByName(asIScriptModule *m, const(char) *name);
	asITypeInfo       *asModule_GetTypeInfoByDecl(asIScriptModule *m, const(char) *decl);

	// Enums
	asUINT             asModule_GetEnumCount(asIScriptModule *m);
	asITypeInfo *      asModule_GetEnumByIndex(asIScriptModule *m, asUINT index);

	// Typedefs
	asUINT             asModule_GetTypedefCount(asIScriptModule *m);
	asITypeInfo *      asModule_GetTypedefByIndex(asIScriptModule *m, asUINT index);

	// Dynamic binding between modules
	asUINT             asModule_GetImportedFunctionCount(asIScriptModule *m);
	int                asModule_GetImportedFunctionIndexByDecl(asIScriptModule *m, const(char) *decl);
	const(char)        *asModule_GetImportedFunctionDeclaration(asIScriptModule *m, asUINT importIndex);
	const(char)        *asModule_GetImportedFunctionSourceModule(asIScriptModule *m, asUINT importIndex);
	int                asModule_BindImportedFunction(asIScriptModule *m, asUINT importIndex, asIScriptFunction *func);
	int                asModule_UnbindImportedFunction(asIScriptModule *m, asUINT importIndex);
	int                asModule_BindAllImportedFunctions(asIScriptModule *m);
	int                asModule_UnbindAllImportedFunctions(asIScriptModule *m);

	// Bytecode saving and loading
	int                asModule_SaveByteCode(asIScriptModule *m, asIBinaryStream* out_, asBOOL stripDebugInfo);
	int                asModule_LoadByteCode(asIScriptModule *m, asIBinaryStream* in_, asBOOL *wasDebugInfoStripped);

	// User data
	void              *asModule_SetUserData(asIScriptModule *m, void *data);
	void              *asModule_GetUserData(asIScriptModule *m);

	///////////////////////////////////////////
	// asIScriptContext

	// Memory management
	int              asContext_AddRef(asIScriptContext *c);
	int              asContext_Release(asIScriptContext *c);

	// Miscellaneous
	asIScriptEngine *asContext_GetEngine(asIScriptContext *c);

	// Execution
	int              asContext_Prepare(asIScriptContext *c, asIScriptFunction *func);
	int              asContext_Unprepare(asIScriptContext *c);
	int              asContext_Execute(asIScriptContext *c);
	int              asContext_Abort(asIScriptContext *c);
	int              asContext_Suspend(asIScriptContext *c);
	asEContextState  asContext_GetState(asIScriptContext *c);
	int              asContext_PushState(asIScriptContext *c);
	int              asContext_PopState(asIScriptContext *c);
	asBOOL           asContext_IsNested(asIScriptContext *c, asUINT *nestCount);

	// Object pointer for calling class methods
	int              asContext_SetObject(asIScriptContext *c, void *obj);

	// Arguments
	int              asContext_SetArgByte(asIScriptContext *c, asUINT arg, asBYTE value);
	int              asContext_SetArgWord(asIScriptContext *c, asUINT arg, asWORD value);
	int              asContext_SetArgDWord(asIScriptContext *c, asUINT arg, asDWORD value);
	int              asContext_SetArgQWord(asIScriptContext *c, asUINT arg, asQWORD value);
	int              asContext_SetArgFloat(asIScriptContext *c, asUINT arg, float value);
	int              asContext_SetArgDouble(asIScriptContext *c, asUINT arg, double value);
	int              asContext_SetArgAddress(asIScriptContext *c, asUINT arg, void *addr);
	int              asContext_SetArgObject(asIScriptContext *c, asUINT arg, void *obj);
	int              asContext_SetArgVarType(asIScriptContext *c, asUINT arg, void *ptr, int typeId);
	void *           asContext_GetAddressOfArg(asIScriptContext *c, asUINT arg);

	// Return value
	asBYTE           asContext_GetReturnByte(asIScriptContext *c);
	asWORD           asContext_GetReturnWord(asIScriptContext *c);
	asDWORD          asContext_GetReturnDWord(asIScriptContext *c);
	asQWORD          asContext_GetReturnQWord(asIScriptContext *c);
	float            asContext_GetReturnFloat(asIScriptContext *c);
	double           asContext_GetReturnDouble(asIScriptContext *c);
	void *           asContext_GetReturnAddress(asIScriptContext *c);
	void *           asContext_GetReturnObject(asIScriptContext *c);
	void *           asContext_GetAddressOfReturnValue(asIScriptContext *c);

	// Exception handling
	int                asContext_SetException(asIScriptContext *c, const(char) *string);
	int                asContext_GetExceptionLineNumber(asIScriptContext *c, int *column, const(char) **sectionName);
	asIScriptFunction *asContext_GetExceptionFunction(asIScriptContext *c);
	const(char) *       asContext_GetExceptionString(asIScriptContext *c);
	int                asContext_SetExceptionCallback(asIScriptContext *c, asFUNCTION_t callback, void *obj, int callConv);
	void               asContext_ClearExceptionCallback(asIScriptContext *c);

	// Debugging
	int                asContext_SetLineCallback(asIScriptContext *c, asFUNCTION_t callback, void *obj, int callConv);
	void               asContext_ClearLineCallback(asIScriptContext *c);
	asUINT             asContext_GetCallstackSize(asIScriptContext *c);
	asIScriptFunction *asContext_GetFunction(asIScriptContext *c, asUINT stackLevel);
	int                asContext_GetLineNumber(asIScriptContext *c, asUINT stackLevel, int *column, const(char) **sectionName);
	int                asContext_GetVarCount(asIScriptContext *c, asUINT stackLevel);
	const(char) *       asContext_GetVarName(asIScriptContext *c, asUINT varIndex, asUINT stackLevel);
	const(char) *       asContext_GetVarDeclaration(asIScriptContext *c, asUINT varIndex, asUINT stackLevel, asBOOL includeNamespace);
	int                asContext_GetVarTypeId(asIScriptContext *c, asUINT varIndex, asUINT stackLevel);
	void *             asContext_GetAddressOfVar(asIScriptContext *c, asUINT varIndex, asUINT stackLevel);
	asBOOL             asContext_IsVarInScope(asIScriptContext *c, asUINT varIndex, asUINT stackLevel);
	int                asContext_GetThisTypeId(asIScriptContext *c, asUINT stackLevel);
	void *             asContext_GetThisPointer(asIScriptContext *c, asUINT stackLevel);
	asIScriptFunction *asContext_GetSystemFunction(asIScriptContext *c);

	// User data
	void *           asContext_SetUserData(asIScriptContext *c, void *data);
	void *           asContext_GetUserData(asIScriptContext *c);

	///////////////////////////////////////////
	// asIScriptGeneric

	// Miscellaneous
	asIScriptEngine   *asGeneric_GetEngine(asIScriptGeneric *g);
	asIScriptFunction *asGeneric_GetFunction(asIScriptGeneric *g);
	void              *asGeneric_GetAuxiliary(asIScriptGeneric *g);

	// Object
	void *           asGeneric_GetObject(asIScriptGeneric *g);
	int              asGeneric_GetObjectTypeId(asIScriptGeneric *g);

	// Arguments
	int              asGeneric_GetArgCount(asIScriptGeneric *g);
	int              asGeneric_GetArgTypeId(asIScriptGeneric *g, asUINT arg, asDWORD *flags);
	asBYTE           asGeneric_GetArgByte(asIScriptGeneric *g, asUINT arg);
	asWORD           asGeneric_GetArgWord(asIScriptGeneric *g, asUINT arg);
	asDWORD          asGeneric_GetArgDWord(asIScriptGeneric *g, asUINT arg);
	asQWORD          asGeneric_GetArgQWord(asIScriptGeneric *g, asUINT arg);
	float            asGeneric_GetArgFloat(asIScriptGeneric *g, asUINT arg);
	double           asGeneric_GetArgDouble(asIScriptGeneric *g, asUINT arg);
	void *           asGeneric_GetArgAddress(asIScriptGeneric *g, asUINT arg);
	void *           asGeneric_GetArgObject(asIScriptGeneric *g, asUINT arg);
	void *           asGeneric_GetAddressOfArg(asIScriptGeneric *g, asUINT arg);

	// Return value
	int              asGeneric_GetReturnTypeId(asIScriptGeneric *g, asDWORD *flags);
	int              asGeneric_SetReturnByte(asIScriptGeneric *g, asBYTE val);
	int              asGeneric_SetReturnWord(asIScriptGeneric *g, asWORD val);
	int              asGeneric_SetReturnDWord(asIScriptGeneric *g, asDWORD val);
	int              asGeneric_SetReturnQWord(asIScriptGeneric *g, asQWORD val);
	int              asGeneric_SetReturnFloat(asIScriptGeneric *g, float val);
	int              asGeneric_SetReturnDouble(asIScriptGeneric *g, double val);
	int              asGeneric_SetReturnAddress(asIScriptGeneric *g, void *addr);
	int              asGeneric_SetReturnObject(asIScriptGeneric *g, void *obj);
	void *           asGeneric_GetAddressOfReturnLocation(asIScriptGeneric *g);

	///////////////////////////////////////////
	// asIScriptObject

	// Memory management
	int                    asObject_AddRef(asIScriptObject *s);
	int                    asObject_Release(asIScriptObject *s);
	asILockableSharedBool *asObject_GetWeakRefFlag(asIScriptObject *s);

	// Type info
	int            asObject_GetTypeId(asIScriptObject *s);
	asITypeInfo *  asObject_GetObjectType(asIScriptObject *s);

	// Class properties
	asUINT           asObject_GetPropertyCount(asIScriptObject *s);
	int              asObject_GetPropertyTypeId(asIScriptObject *s, asUINT prop);
	const(char) *     asObject_GetPropertyName(asIScriptObject *s, asUINT prop);
	void *           asObject_GetAddressOfProperty(asIScriptObject *s, asUINT prop);

	// Miscellaneous
	asIScriptEngine *asObject_GetEngine(asIScriptObject *s);
	int              asObject_CopyFrom(asIScriptObject *s, asIScriptObject *other);

	// User data
	void *asObject_SetUserData(asIScriptObject *s, void *data, asPWORD type);
	void *asObject_GetUserData(asIScriptObject *s, asPWORD type);

	///////////////////////////////////////////
	// asITypeInfo

	// Miscellaneous
	asIScriptEngine *asTypeInfo_GetEngine(asITypeInfo *o);
	const(char)      *asTypeInfo_GetConfigGroup(asITypeInfo *o);
	asDWORD          asTypeInfo_GetAccessMask(asITypeInfo *o);
	asIScriptModule *asTypeInfo_GetModule(asITypeInfo *o);

	// Memory management
	int              asTypeInfo_AddRef(const asITypeInfo *o);
	int              asTypeInfo_Release(const asITypeInfo *o);

	// Type info
	const(char)      *asTypeInfo_GetName(const asITypeInfo *o);
	const(char)      *asTypeInfo_GetNamespace(const asITypeInfo *o);
	asITypeInfo     *asTypeInfo_GetBaseType(const asITypeInfo *o);
	asBOOL           asTypeInfo_DerivesFrom(const asITypeInfo *o, const asITypeInfo *objType);
	asDWORD          asTypeInfo_GetFlags(const asITypeInfo *o);
	asUINT           asTypeInfo_GetSize(const asITypeInfo *o);
	int              asTypeInfo_GetTypeId(const asITypeInfo *o);
	int              asTypeInfo_GetSubTypeId(const asITypeInfo *o, asUINT subTypeIndex);
	asITypeInfo     *asTypeInfo_GetSubType(const asITypeInfo *o, asUINT subTypeIndex);
	asUINT           asTypeInfo_GetSubTypeCount(const asITypeInfo *o);

	// Interfaces
	asUINT           asTypeInfo_GetInterfaceCount(const asITypeInfo *o);
	asITypeInfo     *asTypeInfo_GetInterface(const asITypeInfo *o, asUINT index);
	asBOOL           asTypeInfo_Implements(const asITypeInfo *o, const asITypeInfo *objType); 

	// Factories
	asUINT             asTypeInfo_GetFactoryCount(const asITypeInfo *o);
	asIScriptFunction *asTypeInfo_GetFactoryByIndex(const asITypeInfo *o, asUINT index);
	asIScriptFunction *asTypeInfo_GetFactoryByDecl(const asITypeInfo *o, const(char) *decl);

	// Methods
	asUINT             asTypeInfo_GetMethodCount(const asITypeInfo *o);
	asIScriptFunction *asTypeInfo_GetMethodByIndex(const asITypeInfo *o, asUINT index, asBOOL getVirtual);
	asIScriptFunction *asTypeInfo_GetMethodByName(const asITypeInfo *o, const(char) *name, asBOOL getVirtual);
	asIScriptFunction *asTypeInfo_GetMethodByDecl(const asITypeInfo *o, const(char) *decl, asBOOL getVirtual);

	// Properties
	asUINT      asTypeInfo_GetPropertyCount(const asITypeInfo *o);
	int         asTypeInfo_GetProperty(const asITypeInfo *o, asUINT index, const(char) **name, int *typeId, asBOOL *isPrivate, asBOOL *isProtected, int *offset, asBOOL *isReference, asDWORD *accessMask);
	const(char) *asTypeInfo_GetPropertyDeclaration(const asITypeInfo *o, asUINT index);

	// Behaviours
	asUINT             asTypeInfo_GetBehaviourCount(const asITypeInfo *o);
	asIScriptFunction *asTypeInfo_GetBehaviourByIndex(const asITypeInfo *o, asUINT index, asEBehaviours *outBehaviour);

	// Child types
	asUINT       asTypeInfo_GetChildFuncdefCount(asITypeInfo *o);
	asITypeInfo *asTypeInfo_GetChildFuncdef(asITypeInfo *o, asUINT index);
	asITypeInfo *asTypeInfo_GetParentType(asITypeInfo *o);

	// Enums
	asUINT      asTypeInfo_GetEnumValueCount(asITypeInfo *o);
	const(char) *asTypeInfo_GetEnumValueByIndex(asITypeInfo *o, asUINT index, int *outValue);

	// Typedef
	int asTypeInfo_GetTypedefTypeId(asITypeInfo *o);

	// Funcdef
	asIScriptFunction *asTypeInfo_GetFuncdefSignature(asITypeInfo *o);

	// User data
	void            *asTypeInfo_SetUserData(asITypeInfo *o, void *data, asPWORD type);
	void            *asTypeInfo_GetUserData(asITypeInfo *o, asPWORD type);


	///////////////////////////////////////////
	// asIScriptFunction

	asIScriptEngine *asFunction_GetEngine(const asIScriptFunction *f);

	// Memory management
	int              asFunction_AddRef(const asIScriptFunction *f);
	int              asFunction_Release(const asIScriptFunction *f);

	// Miscellaneous
	int              asFunction_GetId(const asIScriptFunction *f);
	asEFuncType      asFunction_GetFuncType(const asIScriptFunction *f);
	const(char)      *asFunction_GetModuleName(const asIScriptFunction *f);
	asIScriptModule *asFunction_GetModule(const asIScriptFunction *f);
	const(char)      *asFunction_GetScriptSectionName(const asIScriptFunction *f);
	const(char)      *asFunction_GetConfigGroup(const asIScriptFunction *f);
	asDWORD          asFunction_GetAccessMask(const asIScriptFunction *f);
	void            *asFunction_GetAuxiliary(const asIScriptFunction *f);

	// Function signature
	asITypeInfo     *asFunction_GetObjectType(const asIScriptFunction *f);
	const(char)      *asFunction_GetObjectName(const asIScriptFunction *f);
	const(char)      *asFunction_GetName(const asIScriptFunction *f);
	const(char)      *asFunction_GetNamespace(const asIScriptFunction *f);
	const(char)      *asFunction_GetDeclaration(const asIScriptFunction *f, asBOOL includeObjectName, asBOOL includeNamespace);
	asBOOL           asFunction_IsReadOnly(const asIScriptFunction *f);
	asBOOL           asFunction_IsPrivate(const asIScriptFunction *f);
	asBOOL           asFunction_IsProtected(const asIScriptFunction *f);
	asBOOL           asFunction_IsFinal(const asIScriptFunction *f);
	asBOOL           asFunction_IsOverride(const asIScriptFunction *f);
	asBOOL           asFunction_IsShared(const asIScriptFunction *f);
	asUINT           asFunction_GetParamCount(const asIScriptFunction *f);
	int              asFunction_GetParam(const asIScriptFunction *f, asUINT index, int *typeId, asDWORD *flags, const(char) **name, const(char) **defaultArg);
	int              asFunction_GetReturnTypeId(const asIScriptFunction *f);

	// Type id for function pointers
	int              asFunction_GetTypeId(const asIScriptFunction *f);
	asBOOL           asFunction_IsCompatibleWithTypeId(const asIScriptFunction *f, int typeId);

	// Delegates
	void              *asFunction_GetDelegateObject(const asIScriptFunction *f);
	asITypeInfo       *asFunction_GetDelegateObjectType(const asIScriptFunction *f);
	asIScriptFunction *asFunction_GetDelegateFunction(const asIScriptFunction *f);

	// Debug information
	asUINT           asFunction_GetVarCount(const asIScriptFunction *f);
	int              asFunction_GetVar(const asIScriptFunction *f, asUINT index, const(char) **name, int *typeId);
	const(char) *     asFunction_GetVarDecl(const asIScriptFunction *f, asUINT index, asBOOL includeNamespace);
	int              asFunction_FindNextLineWithCode(const asIScriptFunction *f, int line);

	// For JIT compilation
	asDWORD         *asFunction_GetByteCode(asIScriptFunction *f, asUINT *length);

	// User data
	void            *asFunction_SetUserData(asIScriptFunction *f, void *userData);
	void            *asFunction_GetUserData(const asIScriptFunction *f);
}