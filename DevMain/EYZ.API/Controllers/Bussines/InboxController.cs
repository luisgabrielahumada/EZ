using Bussines.ViewModel;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using Gesi.Helper.Core.NotificationServer;
using Request.Services.Rules.Interface;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class InboxController : WebApiController
    {
        private readonly IRequestTask _process;

        public InboxController(IRequestTask process)
        {
            _process = process;
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage RequesForServices(int pageIndex, int pageSize, RequestView data)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<dynamic>(list: _process.RequesForServices(pageIndex, pageSize, UpdatedId, UpdatedId, out _rowcount, data.ProductId, data.StowageFactorId, data.QuantityId, data.LoadingConditionId, data.UnLoadingConditionId, data.LoadPortId, data.LoadTerminalId,
                                                                                    data.DischargePortId, data.DischargeTerminalId, data.StartLaycan, data.EndLaycan),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage InboxCustomer(int pageIndex, int pageSize, RequestView data)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<dynamic>(list: _process.InboxCustomerRequest(pageIndex, pageSize, UpdatedId, UpdatedId, out _rowcount, data.ProductId, data.StowageFactorId, data.QuantityId, data.LoadPortId, data.LoadTerminalId,
                                                                                    data.DischargePortId, data.DischargeTerminalId, data.StartLaycan, data.EndLaycan, data.Status),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage InboxVessel(int pageIndex, int pageSize, RequestView data)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<dynamic>(list: _process.InboxVesselRequest(pageIndex, pageSize, UpdatedId, UpdatedId, out _rowcount, data.ProductId, data.StowageFactorId, data.QuantityId, data.LoadPortId, data.LoadTerminalId,
                                                                                    data.DischargePortId, data.DischargeTerminalId, data.StartLaycan, data.EndLaycan, data.Status),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage ServiceLiquidationsForRquest(int pageIndex, int pageSize, Guid token)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<dynamic>(list: _process.ServiceLiquidationsForRquest(pageIndex, pageSize, token, UpdatedId, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage ItemsLiquidationForServices(Guid id)
        {
            var data = _process.ItemsLiquidationForServices(id, UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpPost]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage ChangeStatus(Guid id, ItemLiquidation data)
        {
            var onwers = _process.ChangeStatus(id, data.Status, data.PriceMT, UpdatedId);
            foreach (var item in onwers)
            {
                Notifications.NotifyClientActivity(item, TypeNotifications.Notifications, $"Send Request for Vessel to Customer", HttpStatusCode.OK, item.Owner);
            }
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }
    }
}