using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Tolerances.Services.Rules.Interface;
using Tolerances.Services.Rules.Model;

namespace Business.Api.Controllers
{
    public class ToleranceController : WebApiController
    {
        private readonly ITolerancesTask _process;

        public ToleranceController(ITolerancesTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<ToleranceModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
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
        public HttpResponseMessage Post([FromBody]ToleranceModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]ToleranceModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Patch([FromUri]Guid id, [FromUri] bool value)
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
    }
}