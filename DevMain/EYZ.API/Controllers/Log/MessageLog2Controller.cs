using Auth.Rules.Interface.Task;
using Auth.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class MessageLog2Controller : WebApiController
    {
        private readonly IMessageLogTask _process;

        public MessageLog2Controller(IMessageLogTask process)
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
                data = new PagerRecord<MessageLogModel>(list: _process.MessageLog(pageIndex, pageSize, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage Get(Guid id)
        {
            //TODO: la clase statica checkif tiene que retornar para los mensajes de esta forma HttpResponseMessage

            var row = _process.Get(Token: id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                item = row
            });
        }

        [HttpDelete]
        [AccessUser(Actions.Delete)]
        public HttpResponseMessage Delete([FromUri]Guid id)
        {
            _process.Delete(Token: id);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}