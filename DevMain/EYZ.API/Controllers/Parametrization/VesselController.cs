using Bussines.ViewModel;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using Gesi.Helper.Core.NotificationServer;
using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Web.Http;
using Vessel.Services.Rules.Interface;
using Vessel.Services.Rules.Model;

namespace Business.Api.Controllers
{
    public class VesselController : WebApiController
    {
        private readonly IVesselTask _process;
        private readonly IPropertyVesselTask _property;

        public VesselController(IVesselTask process, IPropertyVesselTask property)
        {
            _process = process;
            _property = property;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize)
        {
            int _rowcount = 0;
            var data = new PagerRecord<dynamic>(list: _process.Get(pageIndex, pageSize, UpdatedId, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage GetToken(Guid id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.GetToken(id)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage Get(int id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.Get(id)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage PropertyToVessel(Guid? id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _property.PropertyToVessel(id, UpdatedId, UpdatedId)
            });
        }

        [HttpPost]
        public HttpResponseMessage Post([FromBody]VesselModel item)
        {
            _process.Save(item.Token, item.Name, item.Description, item.Phone, item.Email, item.Contact, item.CityId, item.Speed, item.TypeId,
                          item.Capacity, item.Demurrage, item.RateLoading, item.RateUnloading, item.IfoConsumed, item.MgoConsumed, item.Products, item.Property, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]VesselModel item)
        {
            _process.Save(item.Token, item.Name, item.Description, item.Phone, item.Email, item.Contact, item.CityId, item.Speed, item.TypeId,
                          item.Capacity, item.Demurrage, item.RateLoading, item.RateUnloading, item.IfoConsumed, item.MgoConsumed, item.Products, item.Property, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Remove([FromUri]Guid id, [FromUri] bool value)
        {
            _process.Remove(id, value, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpDelete]
        [AccessUser(Actions.Delete)]
        public HttpResponseMessage Delete([FromUri]Guid id)
        {
            _process.Delete(id, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        public HttpResponseMessage AddAvailableOpenVessels([FromBody]AvaliableVesselModel item)
        {
            _process.AddAvailableOpenVessels(item.Token, item.NextOpeningOn, item.NextOpeningPort, item.CurrentPortId, item.CurrentTerminalId, UpdatedId);
            Notifications.NotifyClientActivity(new { }, "Other", $"Update Next Opening {item.NextOpeningOn}", HttpStatusCode.OK, 32);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        public HttpResponseMessage VesselChange([FromBody]VesselModel item)
        {
           var notifications= _process.Changes(item.Token, item.RateLoading, UpdatedId);
            foreach (var data in notifications)
            {
                Notifications.NotifyClientActivity(data, TypeNotifications.Notifications, $"To change Daily Hire for this vessel {data.Name} {string.Format("{0:C}", data.RateLoading)}", HttpStatusCode.OK, data.Owner);
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        public HttpResponseMessage AvailableOpenVessels(Guid id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.AvailableOpenVessels(id, UpdatedId)
            });
        }

        [HttpGet]
        public HttpResponseMessage VesselProductAssigned(Guid? id)
        {
            var result = _process.GetVesselProductAssigned(id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                byAssigned = result.Item1,
                Assigned = result.Item2
            });
        }
        [HttpGet]
        public HttpResponseMessage UpdateRequestForThisVessel(Guid id)
        {
            Thread longThread = new Thread(() => _process.UpdateRequestForThisVessel(id, UpdatedId));
            longThread.Start();
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}