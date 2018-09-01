using Owin;
using Microsoft.Owin;
using Microsoft.AspNet.SignalR;
using Gesi.Core.NotificationServer;

[assembly: OwinStartup(typeof(Gesi.API.Startup))]

namespace Gesi.API
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //// Any connection or hub wire up and configuration should go here
            app.MapSignalR<NotificationHub>("/notificationhub", new ConnectionConfiguration { EnableJSONP = true });
            app.MapSignalR();
        }
    }
}