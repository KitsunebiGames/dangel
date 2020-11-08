import std.stdio;
import std.string;
import std.file : readText;
import as;
import as.addons.str;
import as.addons.dwrap;
import core.memory;
import std.conv;

int prop = 42;

enum TestEnum {
	A,
	B,
	C
}

struct TestStruct {
	int x = 0;

	void testFunction(string* text) {
		writeln(*text, ": ", x);
	}

	void info(Vector2* other) {
		writeln((*other).toString());
	}
}

struct Vector2 {
	float x = 0;
	float y = 0;

	Vector2 opAdd(ref Vector2 other) {
		return Vector2(other.x+this.x, other.y+this.y);
	}

	string toString() {
		return format("[%s,%s]", x, y);
	}
}

extern(C) void msgCallback(NativeMessage msg, void* data) {
	MessageInfo info = MessageInfo(msg);
	
	string severity = (cast(MessageType)info.type).text;
	writefln("[%s::%s %s/%s] %s", severity, info.section, info.row, info.col, info.message);
}

void main(string[] args)
{
	writefln("Angelscript: %s%s", getLibraryVersion(), getLibraryOptions());
	ScriptEngine engine = ScriptEngine.create();
	engine.setMessageCallback(cast(MessageCallback)&msgCallback);
	engine.registerEnum!TestEnum;

	engine.registerDStrings();
	engine.registerDStruct!(Vector2)();
	engine.registerDStruct!(TestStruct)();

	engine.registerGlobalFunction("void writenum(int)", (int num) { writeln(num); });
	engine.registerGlobalFunction("void write(string)", (string* str) { writeln(*str); });

	writefln("Function count: %s", engine.getGlobalFunctionCount());
	writefln("Property count: %s", engine.getGlobalPropertyCount());

	// Compile our script
	Module mod = engine.getModule("app", ModuleCreateFlags.AlwaysCreate);
	mod.addScriptSection(args[1], readText(args[1]));
	mod.build();
	writeln("Module built");

	ScriptContext ctx = engine.createContext();
	ctx.prepare(mod.getFunctionByDecl("void app::main()"));
	ctx.execute();
}
