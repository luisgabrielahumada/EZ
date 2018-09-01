using Gesi.Core.Web.Access;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class DashBoardController : WebApiController
    {
        [HttpGet]
        [AccessUser(Actions.Get)]
        [AllowAnonymous]
        public HttpResponseMessage Get(int pageIndex, int pageSize)
        {
            throw new NotImplementedException();
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        [AllowAnonymous]
        public HttpResponseMessage Get()
        {
            throw new NotImplementedException();
        }
    }
}