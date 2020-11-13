module as.stream;
import as.def;
import core.stdc.string : memcpy;
import core.stdc.stdlib : free;

struct BinaryStream {
private:
    size_t readOffset;

package(as):
    asIBinaryStream* stream;

public:

    /**
        Creates a new stream
    */
    static BinaryStream* create() {
        BinaryStream* bstr = new BinaryStream;
        bstr.stream = asStream_Create(&binaryRead, &binaryWrite, bstr);
        return bstr;
    }

    /**
        Destructor
    */
    ~this() {
        free(stream);
    }

    /**
        Rewinds back to the beginning of the buffer
    */
    void rewind() {
        readOffset = 0;
    }

    /**
        Gets how far has been read in to the buffer
    */
    size_t tell() {
        return readOffset;
    }

    /**
        The buffer
    */
    ubyte[] buffer;
}

package(as) {
extern(C):
    int binaryRead(void* ptr, asUINT size, void* param) {
        BinaryStream* stream = cast(BinaryStream*)param;

        assert(size <= stream.buffer.length, "Tried copying contents larger than buffer");

        // Copy stream data to ptr
        memcpy(ptr, &stream.buffer[stream.readOffset], size);

        // Increase read offset
        stream.readOffset += size;

        // No errors
        return 0;
    }

    int binaryWrite(const(void)* ptr, asUINT size, void* param) {
        BinaryStream* stream = cast(BinaryStream*)param;
        
        // Resize data to fit
        size_t start = stream.buffer.length;
        stream.buffer.length += size;

        // Get the stream data
        memcpy(&stream.buffer[start], ptr, size);

        // No errors
        return 0;
    }
}