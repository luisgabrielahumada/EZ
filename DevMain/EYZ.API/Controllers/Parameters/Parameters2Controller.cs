using Configurations.Rules.Interface.Task;
using Configurations.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class Parameters2Controller : WebApiController
    {
        private readonly IParametersTask _process;

        public Parameters2Controller(IParametersTask process)
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
                data = new PagerRecord<ParametersModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        // GET: api/Cities/5
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage Get(int id)
        {
            //TODO: la clase statica checkif tiene que retornar para los mensajes de esta forma HttpResponseMessage
            //CheckIf.CheckIsNull(id, "Id de la ciudad no puede ser Null");
            throw new NotSupportedException();
        }

        [HttpPost]
        // POST: api/Cities
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Post([FromBody]ParametersModel item)
        {
            _process.Save(item.ParameterId, item.ValueId, UpdatedId);

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}