using Gesi.Access.Database;
using Insight.Database;
using Products.Services.Rules.Model;
using Quantity.Services.Rules.Interface;
using Quantity.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Quantity.Services.Rules.Task
{
    public class QuantityServices : IQuantityTask
    {
        public IList<QuantityModel> Get(int PageIndex, int PageSize, int? ProductId, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IQuantity>().DB_Quantity_List(PageIndex, PageSize, ProductId, out TotalRecords);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IQuantity>().DB_Quantity_Delete(Token);
        }

        public QuantityModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IQuantity>().DB_Quantity_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IQuantity>().DB_Quantity_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, float Quantity, bool IsActive, int UpdatedId, List<ProductModel> Products)
        {
            Database.CurrentCnn.As<IQuantity>().DB_Quantity_Save(Token, Name, Quantity, IsActive, UpdatedId, string.Join(",", Products.Select(item => item.Id).ToArray()));
        }

        public Tuple<IList<ProductModel>, IList<ProductModel>> GetQuantityProductAssigned(Guid? Token)
        {
            var results = Database.CurrentCnn.QueryResults<ProductModel, ProductModel>("DB_QuantityProduct_Assigned", new { Token = Token });
            var byAssigned = results.Set1;
            var Assigned = results.Set2;
            return Tuple.Create(byAssigned, Assigned);
        }
    }
}