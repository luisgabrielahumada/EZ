using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Types.Services.Rules.Interface;

namespace Business.Api.Controllers
{
    public class TypeController : WebApiController
    {
        private readonly ITypeTask _process;

        public TypeController(ITypeTask process)
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
                data = new PagerRecord<dynamic>(list: _process.Get(pageIndex, pageSize, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }
    }
}