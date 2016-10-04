module puppeteer.puppeteer_creator;

import puppeteer.puppeteer;

import puppeteer.communication.communicator;

import puppeteer.configuration.i_configuration;

import puppeteer.logging.i_puppeteer_logger;

import test.puppeteer.communication.broken_communicator;

auto getPuppeteer(IVMonitorTypes...)(string loggingPath = "puppeteerLogs")
{
    version(unittest)
    {
        alias CommunicatorT = shared BrokenCommunicator!IVMonitorTypes;
    }
    else
    {
        alias CommunicatorT = shared Communicator!IVMonitorTypes;
    }

    auto a = new shared Puppeteer!(CommunicatorT, IVMonitorTypes)
                                (new shared CommunicatorT,
                                IConfiguration!IVMonitorTypes.getInstance(),
                                IPuppeteerLogger.getInstance(loggingPath));
    return a;
}
