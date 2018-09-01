using Products.Services.Rules.Model;
using StowageFactors.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Text;

namespace StowageFactors.Services.Rules.Interface
{
    public interface IStowageFactorsTask
    {
        void Save(Guid Token, String Name, float Value, bool IsActive, int UpdatedId, List<ProductModel> Products);

        IList<StowageFactorModel> Get(int PageIndex, int PageSize, int? ProductId, out int TotalRecords);

        StowageFactorModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        Tuple<IList<ProductModel>, IList<ProductModel>> GetStowageFactorProductAssigned(Guid? Token);
    }
}