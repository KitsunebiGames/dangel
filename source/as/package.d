module as;
import as.def;
import std.string;
public import as.engine;
public import as.mod;
public import as.func;
public import as.context;
public import as.tinf;
public import as.obj;

/**
    Gets the version of the angelscript library
*/
string getLibraryVersion() {
    return cast(string)asGetLibraryVersion().fromStringz;
}

/**
    Gets the library options of the angelscript library
*/
string getLibraryOptions() {
    return cast(string)asGetLibraryOptions().fromStringz;
}

/**
    Shorthand for CallConv.CDecl
*/
enum CDECL = CallConv.CDecl;

/**
    Shorthand for CallConv.DDecl
*/
enum DCall = CallConv.DDecl;

/**
    Shorthand for CallConv.DDeclObjLast
*/
enum DCallObjLast = CallConv.DDeclObjLast;

/**
    Shorthand for CallConv.DDeclObjFirst
*/
enum DCallObjFirst = CallConv.DDeclObjFirst;

/**
    All the error codes AngelScript can return
*/
enum ReturnCodes : asERetCodes {
	Success = asERetCodes.asSUCCESS,
	Error = asERetCodes.asERROR,
	ContextActive = asERetCodes.asCONTEXT_ACTIVE,
	ContextNotFinished = asERetCodes.asCONTEXT_NOT_FINISHED,
	ContextNotPrepared = asERetCodes.asCONTEXT_NOT_PREPARED,
	InvalidArg = asERetCodes.asINVALID_ARG,
	NoFunction = asERetCodes.asNO_FUNCTION,
	NotSupported = asERetCodes.asNOT_SUPPORTED,
	InvalidName = asERetCodes.asINVALID_NAME,
	NameTaken = asERetCodes.asNAME_TAKEN,
	InvalidDeclaration = asERetCodes.asINVALID_DECLARATION,
	InvalidObject = asERetCodes.asINVALID_OBJECT,
	InvalidType = asERetCodes.asINVALID_TYPE,
	AlreadyRegistered = asERetCodes.asALREADY_REGISTERED,
	MultipleFunctions = asERetCodes.asMULTIPLE_FUNCTIONS,
	NoModule = asERetCodes.asNO_MODULE,
	NoGlobalVar = asERetCodes.asNO_GLOBAL_VAR,
	InvalidConfiguration = asERetCodes.asINVALID_CONFIGURATION,
	InvalidInterface = asERetCodes.asINVALID_INTERFACE,
	CantBindAllFunctions = asERetCodes.asCANT_BIND_ALL_FUNCTIONS,
	LowerArrayDimensionNotRegistered = asERetCodes.asLOWER_ARRAY_DIMENSION_NOT_REGISTERED,
	WrongConfigGroup = asERetCodes.asWRONG_CONFIG_GROUP,
	ConfigGroupInUse = asERetCodes.asCONFIG_GROUP_IS_IN_USE,
	IllegalBehaviourForType = asERetCodes.asILLEGAL_BEHAVIOUR_FOR_TYPE,
	WrongCallingConv = asERetCodes.asWRONG_CALLING_CONV,
	BuildInProgress = asERetCodes.asBUILD_IN_PROGRESS,
	InitGlobalVarsFailed = asERetCodes.asINIT_GLOBAL_VARS_FAILED,
	OutOfMemory = asERetCodes.asOUT_OF_MEMORY,
	ModuleInUse = asERetCodes.asMODULE_IS_IN_USE
}

/**
    The type of a message
*/
enum MessageType {

    /**
        An info message
    */
    Info = asEMsgType.asMSGTYPE_INFORMATION,

    /**
        A warning message
    */
    Warning = asEMsgType.asMSGTYPE_WARNING,

    /**
        An error message
    */
    Error = asEMsgType.asMSGTYPE_ERROR
}

alias MessageCallback = extern(C) void function(const(asSMessageInfo)*, void*);
alias NativeMessage = const(asSMessageInfo)*;

/**
    Message info
*/
struct MessageInfo {
public:
    this(const(asSMessageInfo)* info) {
        this.section = info.section !is null ? cast(string)info.section.fromStringz : null;
        this.row = info.row;
        this.col = info.col;
        this.type = cast(MessageType)info.type;
        this.message = cast(string)info.message.fromStringz;
    }

    /**
        The section the message occured at
    */
    string section;

    /**
        The row the message occured at
    */
    int row;

    /**
        The column the message occured at
    */
    int col;

    /**
        The type of the message
    */
    MessageType type;

    /**
        The message body
    */
    string message;
}