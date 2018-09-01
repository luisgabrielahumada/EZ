using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Terminals.Services.Rules.Interface;
using Terminals.Services.Rules.Model;

namespace Business.Api.Controllers
{
    public class TerminalController : WebApiController
    {
        private readonly ITerminalsTask _process;

        public TerminalController(ITerminalsTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize, int PortId, int? id)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<TerminalsModel>(list: _process.Get(pageIndex, pageSize, PortId, id, out _rowcount),
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
        public HttpResponseMessage Post([FromBody]TerminalsModel item)
        {
            _process.Save(item.Token, item.PortId, item.Name, item.Address, item.Contants, item.Phone, item.CityId, item.Xaxis, item.Yaxis, item.Email, item.ConditionId, item.ConditionValue, item.Products, item.IsActive, UpdatedId, item.RankRate, item.Draft, item.Dwt);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]TerminalsModel item)
        {
            _process.Save(item.Token, item.PortId, item.Name, item.Address, item.Contants, item.Phone, item.CityId, item.Xaxis, item.Yaxis, item.Email, item.ConditionId, item.ConditionValue, item.Products, item.IsActive, UpdatedId,item.RankRate, item.Draft, item.Dwt);
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
        public HttpResponseMessage GetTerminalByProducts(Guid? id)
        {
            var result = _process.GetTerminalByProducts(id, id == null ? 0 : 1);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = result
            });
        }


        [HttpGet]
        public HttpResponseMessage GetRankRate(Guid? id)
        {
            var result = _process.GetRankRate(id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = result
            });
        }
    }
}