using Gesi.Core.Web.Access;
using Gesi.Core.Web.Autorization;
using Gesi.Core.Web.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace Business.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Configuración y servicios de API web

            // Rutas de API web
            config.MapHttpAttributeRoutes();
            config.Filters.Add(new TryExceptionFilterAttribute());
            config.Filters.Add(new AuthorizeUserAttribute());
            config.Filters.Add(new AccessUserAttribute());

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
              routeTemplate: "api/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}