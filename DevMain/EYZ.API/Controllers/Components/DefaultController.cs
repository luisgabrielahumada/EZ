using Gesi.Core.Web.Access;
using Gesi.Core.Web.WebControllers;
using Gesi.Helper.Core.NotificationServer;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class DefaultController : WebApiController
    {
        [HttpGet]
        [AccessUser(Actions.Get)]
        [AllowAnonymous]
        public HttpResponseMessage NotificationsWeb()
        {
            Notifications.NotifyClientActivity(new { }, TypeNotifications.Notifications, $" Test de Notifications", HttpStatusCode.OK);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        [AllowAnonymous]
        public HttpResponseMessage MessagesWeb()
        {
            Notifications.NotifyClientActivity(new { }, TypeNotifications.Messages, $" Test de Messages", HttpStatusCode.OK);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}