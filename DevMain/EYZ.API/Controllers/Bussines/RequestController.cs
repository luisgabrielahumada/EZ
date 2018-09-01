using Bussines.ViewModel;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.WebControllers;
using Gesi.Helper.Core.NotificationServer;
using Request.Services.Rules.Interface;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class RequestController : WebApiController
    {
        private readonly IRequestTask _process;

        public RequestController(IRequestTask process)
        {
            _process = process;
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Step1(RequestView data)
        {
            var id = _process.Step(data.Token, data.ProductId, data.StowageFactorId, data.StowageFactor, data.QuantityId, data.Quantity, data.ToleranceId, data.Terms, data.LoadingConditionId, data.UnLoadingConditionId, data.LoadPortId,
                                   data.LoadTerminalId, data.LoadingRate, data.DischargePortId, data.DischargeTerminalId, data.UnLoadingRate, data.StartLaycan, data.EndLaycan, UpdatedId);

            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                id = id
            });
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Step2(Guid id, RequestView data)
        {
            var item = _process.Step2(id, data.Status, data.Continue, UpdatedId);
            //var info = _process.GetRequest(id, UpdatedId, 0);
            //Notifications.NotifyClientActivity(info, TypeNotifications.Notifications, $"New Request", HttpStatusCode.OK);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = item
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(Guid id, int VesselId = 0)
        {
            var data = _process.GetRequest(id, UpdatedId, VesselId);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpPost]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Continue(Guid token, List<Guid> id)
        {
            var onwers = _process.Continue(token, id, UpdatedId);
            foreach (var item in onwers)
            {
                Notifications.NotifyClientActivity(item, TypeNotifications.Notifications, $"Select Vessel", HttpStatusCode.OK, item.Owner);
            }
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage ChangeStatusRequest(Guid id, RequestView data)
        {
            var onwers = _process.ChangeStatusRequest(id, data.Status, UpdatedId);
            foreach (var item in onwers)
            {
                Notifications.NotifyClientActivity(item, TypeNotifications.Notifications, $"Update Request for Owner Vessel", HttpStatusCode.OK, item.Owner);
            }
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage VariableLiquidation(Guid id)
        {
            var data = _process.VariableLiquidation(id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }


        [HttpPost]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage UpdateVariableLiquidation(Guid id, ItemLiquidation data)
        {
            _process.UpdateVariableLiquidation(id,data.RateLoading,data.RateUnLoading,data.ValueLoadingCondition,data.ValueUnLoadingCondition,data.Quantity,data.IfoLoadPort,data.MgoLoadPort,data.LoadingRate,data.UnLoadingRate, data.VesselSpeed, data.VesselIfoConsumed, data.VesselMgoConsumed, UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}