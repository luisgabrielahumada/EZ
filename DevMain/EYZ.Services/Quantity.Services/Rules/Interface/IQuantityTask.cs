using Products.Services.Rules.Model;
using Quantity.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Text;

namespace Quantity.Services.Rules.Interface
{
    public interface IQuantityTask
    {
        void Save(Guid Token, string Name, float Quantity, bool IsActive, int UpdatedId, List<ProductModel> Products);

        IList<QuantityModel> Get(int PageIndex, int PageSize, int? ProductId, out int TotalRecords);

        QuantityModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        Tuple<IList<ProductModel>, IList<ProductModel>> GetQuantityProductAssigned(Guid? Token);
    }
}