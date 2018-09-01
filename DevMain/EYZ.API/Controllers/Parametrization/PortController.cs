using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using Ports.Services.Rules.Interface;
using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class PortController : WebApiController
    {
        private readonly IPortsTask _process;

        public PortController(IPortsTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize, int? isActive = 1)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<PortsModel>(list: _process.Get(pageIndex, pageSize, out _rowcount, isActive),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage Get(Guid id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.Get(id)
            });
        }

        [HttpPost]
        public HttpResponseMessage Post([FromBody]PortsModel item)
        {
            _process.Save(item.Token, item.Name, item.Address, item.Phone, item.City, item.Ifo, item.Mgo, item.Terms, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]PortsModel item)
        {
            _process.Save(item.Token, item.Name, item.Address, item.Phone, item.City, item.Ifo, item.Mgo, item.Terms, item.IsActive, UpdatedId);
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

        [HttpGet]
        public HttpResponseMessage GetDistanceBetweenPorts()
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.GetDistanceBetweenPorts()
            });
        }

        [HttpPost]
        public HttpResponseMessage DistanceBetweenPorts(List<DistanceBetweenPortsModel> item)
        {
            _process.DistanceBetweenPorts(item, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}