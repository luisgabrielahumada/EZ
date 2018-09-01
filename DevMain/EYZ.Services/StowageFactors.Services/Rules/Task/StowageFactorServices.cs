using Gesi.Access.Database;
using Insight.Database;
using Products.Services.Rules.Model;
using StowageFactors.Services.Rules.Interface;
using StowageFactors.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace StowageFactors.Services.Rules.Task
{
    public class StowageFactorServices : IStowageFactorsTask
    {
        public IList<StowageFactorModel> Get(int PageIndex, int PageSize, int? ProductId, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IStowageFactors>().DB_StowageFactor_List(PageIndex, PageSize, ProductId, out TotalRecords);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IStowageFactors>().DB_StowageFactor_Delete(Token);
        }

        public StowageFactorModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IStowageFactors>().DB_StowageFactor_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IStowageFactors>().DB_StowageFactor_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, float Value, bool IsActive, int UpdatedId, List<ProductModel> Products)
        {
            Database.CurrentCnn.As<IStowageFactors>().DB_StowageFactor_Save(Token, Name, Value, IsActive, UpdatedId, string.Join(",", Products.Select(item => item.Id).ToArray()));
        }

        public Tuple<IList<ProductModel>, IList<ProductModel>> GetStowageFactorProductAssigned(Guid? Token)
        {
            var results = Database.CurrentCnn.QueryResults<ProductModel, ProductModel>("DB_StowageFactorProduct_Assigned", new { Token = Token });
            var byAssigned = results.Set1;
            var Assigned = results.Set2;
            return Tuple.Create(byAssigned, Assigned);
        }
    }
}