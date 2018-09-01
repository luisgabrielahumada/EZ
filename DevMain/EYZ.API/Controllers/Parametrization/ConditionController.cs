using Conditions.Services.Rules.Interface;
using Conditions.Services.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class ConditionController : WebApiController
    {
        private readonly IConditionsTask _process;

        public ConditionController(IConditionsTask process)
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
                data = new PagerRecord<ConditionModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
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
        public HttpResponseMessage Post([FromBody]ConditionModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.Description, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]ConditionModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.Description, item.IsActive, UpdatedId);
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
        public HttpResponseMessage ConditionPortAssigned(Guid item)
        {
            var result = _process.GetConditionPortAssigned(item);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                byAssigned = result.Item1,
                Assigned = result.Item2
            });
        }
    }
}