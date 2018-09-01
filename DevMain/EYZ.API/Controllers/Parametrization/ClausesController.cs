using Clauses.Services.Rules.Interface;
using Clauses.Services.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class ClausesController : WebApiController
    {
        private readonly IClausesTask _process;

        public ClausesController(IClausesTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize, int? isActive=-1, Guid? ContractToken=null)
        {
            int _rowcount = 0;
            var data = _process.Get(pageIndex, pageSize, out _rowcount, isActive, ContractToken);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<ClausesModel>(list: data,
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
        public HttpResponseMessage Post([FromBody]ClausesModel item)
        {
            _process.Save(item.Token, item.Name, item.Code,item.IsModify, item.IsActive, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]ClausesModel item)
        {
            _process.Save(item.Token, item.Name, item.Code, item.IsModify, item.IsActive, UpdatedId);
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
    }
}