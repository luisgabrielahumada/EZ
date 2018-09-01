using Auth.Rules.Interface.Task;
using Auth.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Businness.Api.Controllers
{
    public class Auth2Controller : WebApiController
    {
        private readonly IAccesUsersTask _process;

        public Auth2Controller(IAccesUsersTask process)
        {
            _process = process;
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage Login([FromBody]UsersModel item)
        {
            var results = _process.LoginValidate(Login: item.Login, Password: new EncryptStrings().EncryptInfo(sSText1: item.Login, sSText2: item.Password));
            var item2 = new Gesi.Core.Web.Model.SessionUsersModel
            {
                Creation = results.Creation,
                Expiration = results.Expiration,
                IsActive = results.IsActive,
                Name = results.Name,
                Profile = results.Profile,
                ProfileId = results.ProfileId,
                SessionId = results.SessionId,
                Token = results.Token,
                Updated = results.Updated,
                UpdatedId = results.UpdatedId,
                UserId = results.UserId,
                Section = results.Section
            };
            var data = SessionTokenJWT(item2);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data
            });
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage SignOut()
        {
            _process.SSUsersSessionDelete(Session);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage RefreshToken([FromBody]UsersModel item)
        {
            var data = _process.SSUsersSessionValidate(item.Login, Session);
            var item2 = new Gesi.Core.Web.Model.SessionUsersModel
            {
                Creation = data.Creation,
                Expiration = data.Expiration,
                IsActive = data.IsActive,
                Name = data.Name,
                Profile = data.Profile,
                ProfileId = data.ProfileId,
                SessionId = data.SessionId,
                Token = data.Token,
                Updated = data.Updated,
                UpdatedId = data.UpdatedId,
                UserId = data.UserId
            };
            var result = this.SessionTokenJWT(item2);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                result
            });
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage ResetPassword()
        {
            _process.UsersPasswordReset(SessionId: Session, UpdatedId: UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpPost]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage ChangePassword([FromBody]UsersModel item)
        {
            _process.UsersChangePassword(item.Login, item.Newpassword, item.Confirmpassword, item.Passwordold, item.Password, Session, UpdatedId, item.Comments);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage RecoveryPassword([FromBody]UsersModel item)
        {
            _process.UsersRecoveryPassword(Email: item.Email, UpdatedId: UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpPost]
        [AllowAnonymous]
        // POST: api/Countries
        public HttpResponseMessage RegisterUser([FromBody]UsersModel item)
        {
            //Database.CurrentCnn.As<IAppDatabase>().App_Users_Save(Token: item.Token, Login: item.Login, RoleId: item.RoleId, IsActive: item.IsActive, Name: item.Name, Email: item.Email, ProfileId: item.ProfileId, Password: new EncryptStrings().EncryptInfo(sSText1: item.Login, sSText2: item.Password), ParentId: item.ParentId, IsSysadmin: item.IsSysadmin, UpdatedId: UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}