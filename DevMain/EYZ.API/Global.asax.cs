using EYZ.Infrastructure;
using System.Web.Http;

namespace Business.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
            GlobalConfiguration.Configuration.Formatters.Remove(GlobalConfiguration.Configuration.Formatters.XmlFormatter);
            NinjectBindingsConfigurator.Start();
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}