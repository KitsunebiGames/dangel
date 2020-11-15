module as.utils;
import core.memory;
import core.stdc.string : memcpy;
import core.stdc.stdlib : malloc, free;
import std.traits;
import std.range.primitives : ElementType;
import std.stdio;

/**
    A D implementation of reinterpret_cast
*/
T reinterpret_cast(T, U)(U item) if (T.sizeof == U.sizeof) {
    union cst { U x; T y; }
    return cst(item).y;
}

/**
    Allocates extra space
*/
void* cMalloc(size_t size) {
    return malloc(size);
}

/**
    Copies memory from A to B
*/
void cMemCopy(T, U)(T to, U from, size_t length) {
    memcpy(cast(void*)to, cast(void*)from, length);
}

/**
    C free routine

    Destructor will automatically be called if there is one
*/
void cFree(T)(T item) {

    // Call destructor if there's one
    destruct(item);

    // Free
    free(cast(void*)item);
}

void destruct(T)(T item) {
    // Call destructor if there is any
    static if (hasMember!(T, "__dtor")) {
        item.__dtor();
    } else static if (hasMember!(T, "dispose")) {
        item.dispose();
    }
}

/**
    Allocates the memory and runs constructors on the specified type

    Constructor arguments can be specified as well
*/
T* cCreate(T, Args...)(Args args) {
    import std.conv : emplace;

    // Allocate appropriate memory for the type
    T* mem = cast(T*)cMalloc(T.sizeof);

    // Emplace the type on the memory, running constructors if neccesary
    emplace!(T, Args)(mem, args);
    return mem;
}