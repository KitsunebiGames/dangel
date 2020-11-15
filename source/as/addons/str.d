module as.addons.str;
import core.memory;
import std.stdio;
import std.conv : emplace;
import as;
import as.utils;


/*
    String Factory
    The string factory can use the GC because the strings are allocated via refcount
*/
private extern(C) {
    
    // String references
    struct StrRef {
        int refs;
        string data;
    }

    // Small type that allows moving strings on to the GC heap
    struct StrPtr { string data; }

    /**
        The cache of constant values
    */
    StrRef[string] constantCache;

    // FACTORY
    void* getStringConstant(const(char)* data, uint length) {
        string text = (cast(string)data[0..length]).idup;

        // Handle adding references to strings
        if (text !in constantCache) constantCache[text] = StrRef(1, text);
        else constantCache[text].refs++;

        return cast(void*)&constantCache[text].data;
    }

    int releaseStringConstant(const(void)* str) {
        if (str is null) return ReturnCodes.Error;

        string text = *cast(string*)str;

        // Handle releasing strings
        if (text !in constantCache) return ReturnCodes.Error;
        else if (--constantCache[text].refs <= 0) constantCache.remove(text);

        return ReturnCodes.Success;
    }

    int getRawStringData(const(void)* istr, char* data, uint* length) {
        if (istr is null) return ReturnCodes.Error;

        string str = *cast(string*)istr;

        // If the length is not null set the length
        if (length !is null)
            *length = cast(uint)str.length;

        // If the data pointer is not null fill the data buffer
        if (data !is null) data[0..str.length] = str[0..str.length];

        // We're done
        return ReturnCodes.Success;
    }
}

/**
    An AngelScript compatible string
*/
struct ASString {
private:
    size_t length_;
    const(char)* str_;

public:

    /**
        Creates an empty string with specified length
    */
    this(size_t length) {
        this.length_ = length;
        this.str_ = cast(const(char)*)cMalloc(length);
    }

    /**
        Creates an ASString based on a D string

        GC memory will be copied out
    */
    this(string str) {

        this.str_ = cast(const(char)*)cMalloc(str.length);
        this.length_ = str.length;

        // Copy memory from GC string to non-GC memory
        cMemCopy(this.str_, str.ptr, str.length);
    }

    /**
        Creates an ASString based on a D string

        GC memory will be copied out
    */
    this(ASString str) {
        this.length_ = str.length_;
        this.str_ = cast(const(char)*)cMalloc(str.length_);

        // Copy memory from GC string to non-GC memory
        cMemCopy(this.str_, str.str_, str.length_);
    }

    /**
        Disposes this ASString
    */
    void dispose() {
        cFree(str_);
    }

    /**
        Overrides string assignment
    */
    void opAssign(ref string str) {

        // Free old memory if need be
        if (length_ > 0) cFree(str_);

        this.str_ = cast(const(char)*)cMalloc(str.length);
        this.length_ = str.length;

        // Copy memory from GC string to non-GC memory
        cMemCopy(this.str_, str.ptr, str.length);
    }

    /**
        Overrides string assignment
    */
    void opAssign(ASString str) {

        // Free old memory if need be
        if (length_ > 0) {
            cFree(str_);
        }

        this.str_ = cast(const(char)*)cMalloc(str.length_);
        this.length_ = str.length_;

        // Copy memory from GC string to non-GC memory
        cMemCopy(this.str_, str.str_, str.length_);
    }

    /**
        Returns a new string based on this and an other string
    */
    ASString opBinary(string op = "~")(ref ASString rhs) {

        // Allocates the ASString on the stack
        ASString newStr = ASString(this.length_+rhs.length_);

        // Copy the data from both strings in order
        cMemCopy(newStr.str_, str_, length_);
        cMemCopy(newStr.str_+length_, rhs.str_, rhs.length_);
        return newStr;
    }

    /**
        Allows appending strings
    */
    ASString opOpAssign(string op="~=")(ref ASString rhs) {
        auto nstr = (this~rhs);

        // Data is copied
        this = nstr;

        // Destruct the temporary string
        destruct(nstr);
        return this;
    }

    void resize(size_t length) {

        // Cache old data so we can copy later
        auto oldData = this.str_;

        // Realloate
        this.str_ = cast(const(char)*)cMalloc(length);

        // Copy the string data from the old string based on whether the old or new size is the smallest
        cMemCopy(this.str_, oldData, length < this.length_ ? length : length_);

        // Free the memory for the old data
        cFree(oldData);
    }
    
    ASString substr(uint start, uint count) {
        ASString ret;

        if (start < length_ && count != 0) {

            // -1 = To end of string
            if (count < 0 || start+count > length_) {
                count = cast(uint)length_-start;
            }

            ret.length_ = count;
            ret.str_ = cast(const(char)*)cMalloc(count);
            cMemCopy(ret.str_, &str_[start], count);
        }
        return ret;
    }

    /**
        Gets the length of the string
    */
    size_t length() {
        return length_;
    }

    /**
        Gets whether the string is empty
    */
    bool isEmpty() {
        return length_ == 0;
    }

    /**
        Reinterprets this as a D string

        Do note that ASStrings are *not* garbage collected memory.
    */
    string toString() const {
        return reinterpret_cast!string(this);
    }
}

private {
    void asStringConstruct(ASString* memory) {
        emplace!ASString(memory);
        memory.length_ = 0;
    }

    void asStringCopyConstruct(ref ASString other, ASString* memory) {
        emplace!ASString(memory);
        *memory = other;
    }

    void asStringDestruct(ASString* memory) {
        destruct(memory);
    }

    ASString* asStringAssign(ASString* in_, ASString* this_) {
        *this_ = *in_;
        return this_;
    }

    ASString* asStringAddAssign(ASString* in_, ASString* this_) {
        *this_ ~= *in_;
        return this_;
    }

    ASString* asStringAdd(ref ASString this_, ref ASString rhs) {
        // Allocates the ASString on the heap
        ASString* newStr = cCreate!ASString(this_.length_+rhs.length_);

        // Copy the data from both strings in order
        cMemCopy(newStr.str_, this_.str_, this_.length_);
        cMemCopy(newStr.str_+this_.length_, rhs.str_, rhs.length_);
        return newStr;
    }

    ASString* asSubstr(uint start, uint count, ref ASString this_) {
        // Allocates the ASString on the heap
        auto substr = this_.substr(start, count);
        scope(exit) substr.dispose();

        return cCreate!ASString(substr);
    }
}

/**
    Allocates a string on the GC
*/
string* StringPtr(string text) {
    StrPtr* strref = new StrPtr(text);
    return &strref.data;
}

void registerDStrings(ScriptEngine engine) {
    engine.registerObjectType("string", ASString.sizeof, TypeFlags.Value | TypeFlags.CDAK);
    engine.registerStringFactory("string", &getStringConstant, &releaseStringConstant, &getRawStringData);

    // Register constructor and destructor
    engine.registerObjectBehaviour("string", Behaviours.Construct, "void f()", &asStringConstruct, CallConv.DDeclObjLast);
    engine.registerObjectBehaviour("string", Behaviours.Construct, "void f(const string &in)", &asStringCopyConstruct, CallConv.DDeclObjLast);
    engine.registerObjectBehaviour("string", Behaviours.Destruct, "void f()", &asStringDestruct, CallConv.DDeclObjLast);

    engine.registerObjectMethod("string", "string &opAssign(const string &in)", &asStringAssign, CallConv.DDeclObjLast);
    engine.registerObjectMethod("string", "string &opAddAssign(const string &in) const", &asStringAddAssign, CallConv.DDeclObjLast);
    engine.registerObjectMethod("string", "string &opAdd(const string &in) const", &asStringAdd, CallConv.DDeclObjFirst);

    engine.registerObjectMethod("string", "uint length() const", &ASString.length, CallConv.DDeclObjFirst);
    engine.registerObjectMethod("string", "bool isEmpty() const", &ASString.isEmpty, CallConv.DDeclObjFirst);
    engine.registerObjectMethod("string", "uint resize(uint size) const", &ASString.resize, CallConv.DDeclObjFirst);
    engine.registerObjectMethod("string", "string &substr(uint start = 0, uint count = -1) const", &asSubstr, CallConv.DDeclObjLast);

    // Conversion functionality
    import std.conv : text;
    engine.registerGlobalFunction("string &intToString(int64 value)", (long value) { return StringPtr(value.text); });
    engine.registerGlobalFunction("string &uintToString(uint64 value)", (ulong value) { return StringPtr(value.text); });
    engine.registerGlobalFunction("string &floatToString(double value)", (double value) { return StringPtr(value.text); });
}