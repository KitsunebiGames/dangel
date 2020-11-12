module as.addons.str;
import as.def;
import as.engine;
import core.memory;
import std.stdio;

private extern(C) {

    /**
        A proto string
    */
    union protostring {
        struct pstr_impl {
            size_t len;
            const(char)* data;
        }

        this(size_t length, const(char)* data) {
            proto = pstr_impl(length, data);
            GC.addRoot(&this);
            GC.setAttr(&this, GC.BlkAttr.NO_MOVE);
        }

        this(string str) {
            this.str = str.idup;
            GC.addRoot(&this);
            GC.setAttr(&this, GC.BlkAttr.NO_MOVE);
        }

        void release() {
            GC.removeRoot(&this);
        }

        size_t length() {
            return proto.len;
        }

        void setText(string text) {
            GC.removeRoot(cast(void*)str);
            str = text.idup;
            GC.addRoot(cast(void*)str);
        }

        pstr_impl proto;
        string str;
    }

    /**
        The cache of constant values
    */
    int[string] constantCache;

    // FACTORY
    void* getStringConstant(const(char)* data, asUINT length) {
        protostring* text = new protostring(cast(string)data[0..length]);
        
        // Handle adding references to strings
        if (text.str !in constantCache) constantCache[text.str] = 1;
        else constantCache[text.str]++;
        
        return cast(void*)text;
    }

    int releaseStringConstant(const(void)* str) {
        //writefln("Is str null? %s...", str is null);
        if (str is null) return asERetCodes.asERROR;

        auto text = cast(protostring*)str;

        // Handle releasing strings
        if (text.str !in constantCache) return asERetCodes.asERROR;
        else if (--constantCache[text.str] <= 0) constantCache.remove(text.str);

        return asERetCodes.asSUCCESS;
    }

    int getRawStringData(const(void)* istr, char* data, asUINT* length) {
        if (istr is null) return asERetCodes.asERROR;

        protostring* proto = cast(protostring*)istr;

        // If the length is not null set the length
        if (length !is null)
            *length = cast(uint)proto.length;

        // If the data pointer is not null fill the data buffer
        if (data !is null)
           data[0..proto.length] = proto.str[0..proto.length];

        // We're done
        return asERetCodes.asSUCCESS;
    }

    void strConstructor(protostring* self) {
        self = new protostring;

        GC.addRoot(self);
        GC.setAttr(self, GC.BlkAttr.NO_MOVE);
    }

    void strDestructor(protostring* self) {
        GC.removeRoot(self);
        GC.clrAttr(self, GC.BlkAttr.FINALIZE | GC.BlkAttr.NO_MOVE);
    }

    ref string strOpAssign(ref string in_, protostring* self) {
        self.setText(in_);
        return self.str;
    }

    ref string strOpAddAssign(ref string in_, protostring* self) {
        self.setText(self.str~in_);
        return self.str;
    }

    protostring* strOpAdd(protostring* lhs, ref string rhs) {
        return new protostring(lhs.str~rhs);
    }

    uint strLength(protostring* self) {
        return cast(uint)self.length;
    }

    bool strEmpty(protostring* self) {
        return self.length == 0;
    }

    void strResize(uint size, protostring* self) {
        string newString = self.str.idup;
        newString.length = size;
        self.setText(newString);
    }

    protostring* strSubstr(uint start, uint length, protostring* self) {

        // TODO: Slice via code points?
        return new protostring(self.str[start..start+length]);
    }
}

/**
    Makes a copy of a string on the heap and gets a pointer to it
*/
string* toAS(string text) {
    protostring* proto = new protostring(text.idup);
    return &proto.str;
}

/**
    Registers D UTF-8 strings
*/
void registerDStrings(ScriptEngine engine) {
    engine.registerObjectType("string", string.sizeof, asEObjTypeFlags.asOBJ_VALUE | asEObjTypeFlags.asOBJ_APP_CLASS_CDAK);
    engine.registerStringFactory("string", &getStringConstant, &releaseStringConstant, &getRawStringData);
    engine.registerObjectBehaviour("string", asEBehaviours.asBEHAVE_CONSTRUCT, "void f()", &strConstructor, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectBehaviour("string", asEBehaviours.asBEHAVE_DESTRUCT, "void f()", &strDestructor, asECallConvTypes.asCALL_CDECL_OBJLAST);

    engine.registerObjectMethod("string", "string &opAssign(const string &in)", &strOpAssign, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectMethod("string", "string &opAddAssign(const string &in)", &strOpAddAssign, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectMethod("string", "string &opAdd(const string &in)", &strOpAdd, asECallConvTypes.asCALL_CDECL_OBJFIRST);

    engine.registerObjectMethod("string", "uint length() const", &strLength, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectMethod("string", "bool isEmpty() const", &strEmpty, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectMethod("string", "void resize(uint size) const", &strResize, asECallConvTypes.asCALL_CDECL_OBJLAST);
    engine.registerObjectMethod("string", "string &substr(uint start, uint length)", &strSubstr, asECallConvTypes.asCALL_CDECL_OBJLAST);
}