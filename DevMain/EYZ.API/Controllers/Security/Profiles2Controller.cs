using Auth.Rules.Interface.Task;
using Auth.Rules.Model;
using Configurations.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebCache;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class Profiles2Controller : WebApiController
    {
        private readonly IProfilesTask _process;

        public Profiles2Controller(IProfilesTask process)
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
                data = new PagerRecord<ProfilesModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage Get(Guid id)
        {
            //TODO: la clase statica checkif tiene que retornar para los mensajes de esta forma HttpResponseMessage
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.Get(Token: id)
            });
        }

        [HttpPost]
        [AccessUser(Actions.New)]
        public HttpResponseMessage Post([FromBody]ProfilesModel item)
        {
            _process.Save(Token: item.Token, UpdatedId: UpdatedId, Profile: item.Profile, Section: item.Section, IsActive: item.IsActive);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [HttpPut]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Put([FromUri]Guid id, [FromBody]ProfilesModel item)
        {
            _process.Save(Token: id, UpdatedId: UpdatedId, Profile: item.Profile, Section: item.Section, IsActive: item.IsActive);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Remove([FromUri]Guid id, [FromUri] bool value)
        {
            _process.Remove(Token: id, IsActive: value, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpDelete]
        [AccessUser(Actions.Delete)]
        public HttpResponseMessage Remove([FromUri]Guid id)
        {
            _process.Delete(Token: id, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        [AccessUser(Actions.Other)]
        public HttpResponseMessage ClearCache()
        {
            WebCache<AccessUsersModel>.Delete(string.Format(Constants.Cache.AccessUser, Session));
            WebCache<CommonsModel>.Delete(string.Format(Constants.Cache.DropDown, Session));
            WebCache<MenusModel>.Delete(string.Format(Constants.Cache.MenuUser, Session));
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}