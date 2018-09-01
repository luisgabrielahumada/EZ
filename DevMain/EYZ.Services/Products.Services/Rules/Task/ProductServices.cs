using Gesi.Access.Database;
using Insight.Database;
using Products.Services.Rules.Interface;
using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Products.Services.Rules.Task
{
    public class ProductServices : IProductsTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IProducts>().DB_Product_Delete(Token);
        }

        public IList<ProductModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? isActive)
        {
            return Database.CurrentCnn.As<IProducts>().DB_Product_List(PageIndex, PageSize, out TotalRecords, isActive);
        }

        public ProductModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IProducts>().DB_Product_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IProducts>().DB_Product_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, string Description, int TypeId, bool IsActive, int UpdatedId, string Measure, string MeasureQuantity)
        {
            Database.CurrentCnn.As<IProducts>().DB_Product_Save(Token, Name, Description, TypeId, IsActive, UpdatedId, Measure, MeasureQuantity);
        }
    }
}