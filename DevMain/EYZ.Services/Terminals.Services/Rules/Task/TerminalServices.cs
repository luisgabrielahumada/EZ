using Gesi.Access.Database;
using Insight.Database;
using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Terminals.Services.Rules.Interface;
using Terminals.Services.Rules.Model;

namespace Terminals.Services.Rules.Task
{
    public class TerminalServices : ITerminalsTask
    {
        public IList<TerminalsModel> Get(int PageIndex, int PageSize, int PortId, int? ProductId, out int TotalRecords)
        {
            return Database.CurrentCnn.As<ITerminals>().DB_Terminal_List(PageIndex, PageSize, PortId, ProductId, out TotalRecords);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<ITerminals>().DB_Terminal_Delete(Token);
        }

        public TerminalsModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<ITerminals>().DB_Terminal_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<ITerminals>().DB_Terminal_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, int PortId, String Name, String Address, String Contants, String Phone, int CityId, String Xaxis, String Yaxis, String Email, int ConditionId, float Value, List<ProductByTerminalModel> Products, bool IsActive, int UpdatedId,List<RankRate> RankRate, float Draft, float Dwt)
        {
            Database.CurrentCnn.As<ITerminals>().DB_Terminal_Save(Token, PortId, Name, Address, Contants, Phone, CityId, Xaxis, Yaxis, Email, ConditionId, Value, string.Join("X", Products.Select(item => $"{item.Id}|{item.LoadingRate}|{item.UnLoadingRate}|{item.IsActive}").ToArray()), IsActive, UpdatedId,
                                                                  string.Join("X", RankRate.Select(item => $"{item.Minimum}|{item.Maximum}|{item.Rate}").ToArray()), Draft, Dwt);
        }

        public Tuple<IList<ProductModel>, IList<ProductModel>> GetTerminalProductAssigned(Guid Token)
        {
            var results = Database.CurrentCnn.QueryResults<ProductModel, ProductModel>("DB_TerminalProduct_Assigned", new { Token = Token });
            var byAssigned = results.Set1;
            var Assigned = results.Set2;
            return Tuple.Create(byAssigned, Assigned);
        }

        public IList<ProductByTerminalModel> GetTerminalByProducts(Guid? Token, int Type)
        {
            return Database.CurrentCnn.As<ITerminals>().DB_TerminalByProducts_Get(Token, Type);
        }

        public List<dynamic> GetRankRate(Guid? Token)
        {
            return Database.CurrentCnn.As<ITerminals>().DB_RankRateTerminals_Get(Token);
        }
    }
}