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
    public class Users2Controller : WebApiController
    {
        private readonly IUsersTask _process;

        public Users2Controller(IUsersTask process)
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
                data = new PagerRecord<UsersModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage ProfilUser()
        {
            //TODO: la clase statica checkif tiene que retornar para los mensajes de esta forma HttpResponseMessage
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.ProfileUsers(SessionId: Session)
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
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Post([FromBody]UsersModel item)
        {
            _process.Save(Token: item.Token, Login: item.Login, RoleId: item.RoleId, IsActive: item.IsActive, Name: item.Name, Email: item.Email, ProfileId: item.ProfileId, Password: item.Password, ParentId: item.ParentId, IsSysadmin: item.IsSysadmin, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [HttpPut]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Put([FromUri]Guid id, [FromBody]UsersModel item)
        {
            _process.Save(Token: item.Token, Login: item.Login, RoleId: item.RoleId, IsActive: item.IsActive, Name: item.Name, Email: item.Email, ProfileId: item.ProfileId, Password: new EncryptStrings().EncryptInfo(sSText1: item.Login, sSText2: item.Password), ParentId: item.ParentId, IsSysadmin: item.IsSysadmin, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Remove([FromUri]bool value, [FromUri]Guid id)
        {
            _process.Remove(Token: id, IsActive: value, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpDelete]
        [AccessUser(Actions.Delete)]
        public HttpResponseMessage Delete([FromUri]Guid id)
        {
            _process.Delete(Token: id, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}