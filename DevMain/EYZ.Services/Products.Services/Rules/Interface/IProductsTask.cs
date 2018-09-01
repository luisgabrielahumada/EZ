using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Text;

namespace Products.Services.Rules.Interface
{
    public interface IProductsTask
    {
        void Save(Guid Token, string Name, string Description, int TypeId, bool IsActive, int UpdatedId, string Measure, string MeasureQuantity);

        IList<ProductModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? isActive);

        ProductModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}