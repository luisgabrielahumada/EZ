﻿using Gesi.Core.Web.Access;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using StowageFactors.Services.Rules.Interface;
using StowageFactors.Services.Rules.Model;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class StowageFactorController : WebApiController
    {
        private readonly IStowageFactorsTask _process;

        public StowageFactorController(IStowageFactorsTask process)
        {
            _process = process;
        }

        [HttpGet]
        [AccessUser(Actions.Get)]
        public HttpResponseMessage Get(int pageIndex, int pageSize, int? id)
        {
            int _rowcount = 0;
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = new PagerRecord<StowageFactorModel>(list: _process.Get(pageIndex, pageSize, id, out _rowcount),
                                                page: pageIndex,
                                                pageSize: pageSize,
                                                allItemsCount: _rowcount)
            });
        }

        [HttpGet]
        [AccessUser(Actions.Edit)]
        public HttpResponseMessage Get(Guid id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                data = _process.Get(id)
            });
        }

        [HttpPost]
        public HttpResponseMessage Post([FromBody]StowageFactorModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.IsActive, UpdatedId, item.Product);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPut]
        public HttpResponseMessage Put(Guid id, [FromBody]StowageFactorModel item)
        {
            _process.Save(item.Token, item.Name, item.Value, item.IsActive, UpdatedId, item.Product);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPatch]
        [AccessUser(Actions.Status)]
        public HttpResponseMessage Remove([FromUri]Guid id, [FromUri] bool value)
        {
            _process.Remove(id, value, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpDelete]
        [AccessUser(Actions.Delete)]
        public HttpResponseMessage Delete([FromUri]Guid id)
        {
            _process.Delete(id, UpdatedId);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        public HttpResponseMessage StowageFactorProductAssigned(Guid? id)
        {
            var result = _process.GetStowageFactorProductAssigned(id);
            return Request.CreateResponse(HttpStatusCode.OK, new
            {
                byAssigned = result.Item1,
                Assigned = result.Item2
            });
        }
    }
}