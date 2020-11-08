module as.addons.dwrap;
import as.def;
import as.engine;
import core.memory;
import core.stdc.stdlib : free;
import std.traits;
import std.format;
import std.string;
import std.stdio;

private {
    extern(C) void constructClassOrStruct(T)(T* self) {
        import std.conv : emplace;
        emplace!T(self);
    }

    extern(C) void destructClassOrStruct(T)(T* self) {
        destroy(self);
    }

    extern(C) T structAssign(T)(ref T in_, ref T self) {
        writeln(self, " ", in_);
        self = in_;
        return self;
    }

    string toASType(string typeName) {
        switch(typeName) {

            case "string":
            case "int":
            case "float":
            case "double": return typeName;

            case "ubyte": return "byte";
            case "ushort": return "uint16";
            case "uint": return "uint";
            case "ulong": return "uint64";
            default: {
                while (typeName.endsWith("*")) {
                    typeName.length--;
                }
                return typeName;
            }
        }
    }

    string buildArgList(alias T)() {
        string[] o;
        static foreach(param; Parameters!T) {
            o ~= toASType(param.stringof);
        }
        return o.length == 0 ? "" : o.join(", ");
    }
}

void registerDStruct(T, string namespace = "")(ScriptEngine engine) if (is(T == struct)) {
    mixin("import ", moduleName!T, ";");

    static if (namespace.length != 0) {
        string prevNamespace = engine.getDefaultNamespace();
        scope(exit) engine.setDefaultNamespace(prevNamespace);
        
        // Set up namespace
        engine.setDefaultNamespace(namespace);
    }
    
    engine.registerObjectType(T.stringof, T.sizeof, asEObjTypeFlags.asOBJ_VALUE | asEObjTypeFlags.asOBJ_APP_CLASS_CDAK);
    engine.registerObjectBehaviour(
        T.stringof,
        asEBehaviours.asBEHAVE_CONSTRUCT, 
        "void f()",
        cast(asFUNCTION_t)&constructClassOrStruct!T, 
        DCallConvClass, 
        null
    );

    engine.registerObjectBehaviour(
        T.stringof,
        asEBehaviours.asBEHAVE_DESTRUCT, 
        "void f()",
        cast(asFUNCTION_t)&destructClassOrStruct!T, 
        DCallConvClass, 
        null
    );
    engine.registerObjectMethod(
        T.stringof, 
        "%s &opAssign(const %s &in)".format(T.stringof, T.stringof), 
        &structAssign!T, 
        DCallConvClassR
    );
    

    static foreach(member; __traits(allMembers, T)) {
        {
            alias mInstance = mixin(T.stringof, ".", member);
            enum visibility = __traits(getProtection, mInstance);
            static if (visibility == "public" || visibility == "static") {
                static if (is(typeof(mInstance) == function)) {
                    {
                        string retType = (ReturnType!mInstance).stringof;

                        engine.registerObjectMethod(T.stringof, "%s %s(%s)".format(toASType(retType), member, buildArgList!mInstance()), cast(asFUNCTION_t)&mInstance, DCallConvClassR, null);
                    }
                } else static if(!is(typeof(mInstance) == struct) && !is(typeof(mInstance) == class)) {
                    engine.registerObjectProperty(T.stringof, "%s %s".format(toASType(typeof(mInstance).stringof), member), mInstance.offsetof);
                } else static if(is(typeof(mInstance) == struct)) {
                    // TODO: Auto register structs if needed
                }
            }
        }
    }

}
