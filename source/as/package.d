module as;
import as.def;
import std.string;
public import as.engine;
public import as.mod;
public import as.func;
public import as.context;
public import as.tinf;
public import as.obj;

enum CDECL = asECallConvTypes.asCALL_CDECL;
enum DCall = asECallConvTypes.asCALL_DDECL;
enum DCallObjLast = asECallConvTypes.asCALL_DDECL_OBJLAST;
enum DCallObjFirst = asECallConvTypes.asCALL_DDECL_OBJFIRST;

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