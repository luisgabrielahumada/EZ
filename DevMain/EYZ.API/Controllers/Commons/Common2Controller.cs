using Bussines.Helper;
using Configurations.Rules.Interface.Task;
using Configurations.Rules.Model;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebCache;
using Gesi.Core.Web.WebControllers;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class Common2Controller : WebApiController
    {
        private readonly ICommonsTask _process;

        public Common2Controller(ICommonsTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage Get(string type, string parameter, int? id)
        {
            var data = WebCache<IList<CommonsModel>>.Get(string.Format(Constants.Cache.DropDown, type));
            if (data == null)
            {
                data = _process.DropDown(type, parameter, id);
                WebCache<IList<CommonsModel>>.Add(Constants.Cache.DropDown, data, DateTimeOffset.Now.AddDays(1));
            }
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage Get(string type, int? id)
        {
            var data = WebCache<IList<CommonsModel>>.Get(string.Format(Constants.Cache.DropDown, type));
            if (data == null)
            {
                data = _process.DropDown(type, id);
                WebCache<IList<CommonsModel>>.Add(Constants.Cache.DropDown, data, DateTimeOffset.Now.AddDays(1));
            }
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = data
            });
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage GetTerms()
        {
            var result = EnumExtensions.GetEnumListKeyValue<Term>();
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = result
            });
        }
    }
}