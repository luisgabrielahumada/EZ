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
    public class Menus2Controller : WebApiController
    {
        private readonly IMenusTask _process;

        public Menus2Controller(IMenusTask process)
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
                data = new PagerRecord<MenusModel>(list: _process.Get(pageIndex, pageSize, out _rowcount),
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

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Remove([FromUri]Guid id, [FromUri]bool value)
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

        [HttpPost]
        [AccessUser(Actions.New)]
        public HttpResponseMessage Post([FromBody]MenusModel item)
        {
            //TODO: varificar por que esto no esta funcionando...
            _process.Save(Token: item.Token, UpdatedId: UpdatedId,
                        Menu: item.Menu, Help: item.Help, FilePage: item.FilePage,
                        IsActive: item.IsActive, IsHorizontal: item.IsHorizontal,
                        IsVertical: item.IsVertical, ParentId: item.ParentId,
                        IsParent: item.IsParent, IsParentMenu: item.IsParentMenu, IsAutorization: item.IsAutorization, Alias: item.Alias);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [HttpPut]
        [AccessUser(Actions.Modify)]
        public HttpResponseMessage Put(String Id, [FromBody]MenusModel item)
        {
            //TODO: varificar por que esto no esta funcionando...
            _process.Save(Token: item.Token, UpdatedId: UpdatedId, Menu: item.Menu, Help: item.Help, FilePage: item.FilePage, IsActive: item.IsActive, IsHorizontal: item.IsHorizontal, IsVertical: item.IsVertical, ParentId: item.ParentId, IsParent: item.IsParent, IsParentMenu: item.IsParentMenu, IsAutorization: item.IsAutorization, Alias: item.Alias);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage MenuOptionSession()
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.DefaultMenus(Session)
            });
        }
    }
}