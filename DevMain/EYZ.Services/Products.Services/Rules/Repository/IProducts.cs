using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Products.Services.Rules.Interface
{
    public partial interface IProducts
    {
        IList<ProductModel> DB_Product_List(int PageIndex, int PageSize, out int TotalRecords, int? isActive);

        ProductModel DB_Product_Get(Guid Token);

        void DB_Product_Delete(Guid Token);

        void DB_Product_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);

        void DB_Product_Save(Guid Token, string Name, string Description, int TypeId, bool IsActive, int UpdatedId, string Measure, string MeasureQuantity);
    }
}