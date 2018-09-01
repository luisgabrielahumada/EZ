using Auth.Rules.Interface.Task;
using Auth.Rules.Model;
using Gesi.Core.Web.Access;
using Gesi.Core.Web.WebControllers;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class Permissions2Controller : WebApiController
    {
        private readonly IPermissionsTask _process;
        private readonly IMenusTask _menu;

        public Permissions2Controller(IPermissionsTask process, IMenusTask menu)
        {
            _process = process;
            _menu = menu;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        [AllowAnonymous]
        public HttpResponseMessage AssignCheckPermissions()
        {
            var result = _process.AssignCheckPermissions(Session);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = result.Item1,
                orfans = result.Item2
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage CheckProfilePermissions(Guid id, int value)
        {
            var set = _process.ProfilesCheckPermissionsGet(MenuId: value);
            var row = _menu.Get(Token: id);

            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = set,
                item = row
            });
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage CheckUsersPermissions([FromUri]Guid id, int value, int id2)
        {
            var set = _process.UsersCheckPermissionsGet(MenuId: value, ProfileId: id2);
            var row = _menu.Get(Token: id);

            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = set,
                item = row
            });
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage CheckPermissionsApply([FromBody]ProfilesMenusModel item)
        {
            _process.CheckPermissionsApplySave(ProfileIdmenu: item.ProfileMenuId, ParentId: item.ParentId,
                                                                                                                    IsVertical: item.IsVertical,
                                                                                                                    IsHorizontal: item.IsHorizontal,
                                                                                                                    IsActive: item.IsActive,
                                                                                                                    ProfileId: item.ProfileId,
                                                                                                                    MenuId: item.MenuId,
                                                                                                                    IsView: item.IsView,
                                                                                                                    IsNew: item.IsNew,
                                                                                                                    IsEdit: item.IsEdit,
                                                                                                                    IsAutorization: item.IsAutorization,
                                                                                                                    IsStatus: item.IsStatus,
                                                                                                                    IsModify: item.IsModify,
                                                                                                                    IsSpecial: item.IsSpecial,
                                                                                                                    IsDelete: item.IsDelete);

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage CheckPermissionsApplyUsers([FromBody]AccessUsersModel item)
        {
            _process.CheckPermissionsApplyUsersSave(UserId_access: item.UserAcces,
                                                                                                                    ProfileId: item.ProfileId,
                                                                                                                    UserId: item.UserId,
                                                                                                                    MenuId: item.MenuId,
                                                                                                                    IsView: item.IsView,
                                                                                                                    IsNew: item.IsNew,
                                                                                                                    IsEdit: item.IsEdit,
                                                                                                                    IsAutorization: item.IsAutorization,
                                                                                                                    IsStatus: item.IsStatus,
                                                                                                                    IsModify: item.IsModify,
                                                                                                                    IsSpecial: item.IsSpecial,
                                                                                                                    IsDelete: item.IsDelete);

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage CheckPermissionsApplyProfile([FromUri]Guid id, [FromUri]  int value, [FromUri]int id2)
        {
            _process.CheckPermissionsApplyProfileSave(MenuId: value, ProfileId: id2);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage CheckPermissionsApplyUser(Guid id, [FromUri]int value, [FromUri]int id2, int userId)
        {
            _process.CheckNewUsersPermissionsApplySave(MenuId: value, ProfileId: id2, UserId: userId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage RemoveUsersPermissions([FromUri]int id)
        {
            _process.CheckRemoveUsersPermissionsApplyDelete(UserId_access: id, UpdatedId: UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage RemoveProfilesPermissions([FromUri]int id)
        {
            _process.CheckRemoveProfilesPermissionsApplyDelete(ProfileMenuId: id, UpdatedId: UpdatedId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}