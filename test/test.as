namespace app {
    void main() {
        string test = "ASDF";
        write("Test");

        TestStruct strukt;
        strukt.x = 42;
        strukt.testFunction(test);

        Vector2 veca;
        veca.x = 1.5;
        veca.y = 1.5;

        Vector2 vecb;
        vecb.x = 1.5;
        vecb.y = 1.5;
        strukt.info(veca);
        strukt.info(vecb);

        Vector2 vecc;
        vecc = veca+vecb;

        strukt.info(vecc);
    }
}