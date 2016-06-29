module test.puppeteer.puppeteer_test;

mixin template test()
{
    unittest
    {
        // Test for supported types
        assert(__traits(compiles, Puppeteer!()));
        assert(__traits(compiles, Puppeteer!short));
        assert(!__traits(compiles, Puppeteer!float));
        assert(!__traits(compiles, Puppeteer!(short, float)));
        assert(!__traits(compiles, Puppeteer!(short, void)));

        class Foo
        {
            void pinListener(ubyte pin, float receivedValue, float adaptedValue, long msecs) shared
            {

            }

            void varListener(T)(ubyte var, T receivedValue, T adaptedValue, long msecs) shared
            {

            }
        }

        auto a = new Puppeteer!short("fileName");
        auto foo = new shared Foo;

        assertThrown!CommunicationException(a.endCommunication());
        assertThrown!CommunicationException(a.addPinListener(0, &foo.pinListener));
        assertThrown!CommunicationException(a.removePinListener(0, &foo.pinListener));
        assertThrown!CommunicationException(a.addVariableListener!short(0, &foo.varListener!short));
        assertThrown!CommunicationException(a.removeVariableListener!short(0, &foo.varListener!short));
    }

    unittest
    {
        import std.json;
        import std.file;
        import std.format : format;

        auto a = new Puppeteer!short("filename");
        a.setAnalogInputValueAdapter(0, "x");
        a.setAnalogInputValueAdapter(3, "5+x");
        a.setVarMonitorValueAdapter!short(1, "-x");
        a.setVarMonitorValueAdapter!short(5, "x-3");

        JSONValue ai = JSONValue(["0" : "x", "3" : "5+x"]);
        JSONValue shorts = JSONValue(["1" : "-x", "5" : "x-3"]);
        JSONValue vars = JSONValue(["short" : shorts]);
        JSONValue mockConfig = JSONValue([configAIAdaptersKey : ai, configVarAdaptersKey : vars]);

        assert(a.generateConfigString() == mockConfig.toPrettyString());

        enum testResDir = "test_out";
        enum configFilename1 = testResDir ~ "/config1.test";

        if(!exists(testResDir))
            mkdir(testResDir);
        else
            assert(isDir(testResDir), format("Please remove the '%s' file so the tests can run", testResDir));

        assert(a.saveConfig(configFilename1));

        auto b = new Puppeteer!short("filename");

        b.loadConfig(configFilename1);

        assert(b.generateConfigString() == mockConfig.toPrettyString());

        auto c = new Puppeteer!()("filename");
        assertThrown!InvalidConfigurationException(c.loadConfig(configFilename1));

        auto d = new Puppeteer!()("filename");
        d.setAnalogInputValueAdapter(0, "2*x");
        d.setAnalogInputValueAdapter(5, "-3*x");

        enum configFilename2 = testResDir ~ "/config2.test";

        assert(d.saveConfig(configFilename2));

        auto e = new Puppeteer!short("filename");

        assert(e.loadConfig(configFilename2));

        assert(d.generateConfigString() == e.generateConfigString());
    }
}
