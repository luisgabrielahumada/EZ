using Bussines.ViewModel;
using Contract.Services.Rules.Interface;
using Contract.Services.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.WebControllers;
using Gesi.Helper.Core.NotificationServer;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class NegotiationController : WebApiController
    {
        private readonly INegotiationTask _process;

        public NegotiationController(INegotiationTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage List(int pageIndex, int pageSize)
        {
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(Guid id)
        {
            var data= _process.Get(id);
            return Request.CreateResponse(HttpStatusCode.OK, new {
                negotiation = data
            });
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Continue(NegotiationModel data)
        {
            _process.Continue(data.ServiceLiquidationToken, data.Clauses, true, UpdatedId);
            Notifications.NotifyClientActivity(data, "Other", $"Negotiation begin for request", HttpStatusCode.OK, UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage History(Guid id)
        {
            var data = _process.History(id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                negotiation = data
            });
        }
        
    }
}