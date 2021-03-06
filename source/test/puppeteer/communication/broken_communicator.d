module test.puppeteer.communication.broken_communicator;

import puppeteer.puppeteer;

import puppeteer.communication.is_communicator;
import puppeteer.communication.communication_exception;

public shared class BrokenCommunicator(IVTypes...)
{
    static assert(isCommunicator!(shared typeof(this), IVTypes));

    @property
    bool isCommunicationOngoing()
    {
        return false;
    }

    bool startCommunication()(string devFilename, BaudRate baudRate, Parity parity)
    {
        return false;
    }

    void endCommunication()
    {
        throw new CommunicationException("Broken Communicator is always broken");
    }

    void setPWMValue(ubyte pin, ubyte pwmValue) {enforceCommunicationOngoing();}

    void setAIMonitor(ubyte pin, bool shouldMonitor) {enforceCommunicationOngoing();}

    void setOnAIUpdateCallback(OnAIUpdateCallback callback)
    {

    }

    void setIVMonitor(IVType)(ubyte varIndex, bool shouldMonitor) {enforceCommunicationOngoing();}

    void setOnIVUpdateCallback(IVType)(OnIVUpdateCallback!IVType callback)
    {

    }

    private void enforceCommunicationOngoing()
    {
        enforce(isCommunicationOngoing);
    }
}
