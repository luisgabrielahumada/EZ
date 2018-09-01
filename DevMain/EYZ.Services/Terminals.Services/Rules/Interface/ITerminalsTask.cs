using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;
using Terminals.Services.Rules.Model;

namespace Terminals.Services.Rules.Interface
{
    public interface ITerminalsTask
    {
        void Save(Guid Token, int PortId, String Name, String Address, String Contants, String Phone, int CityId, String Xaxis, String Yaxis, String Email, int ConditionId, float Value, List<ProductByTerminalModel> Products, bool IsActive, int UpdatedId, List<RankRate> RankRate, float Draft, float Dwt);

        IList<TerminalsModel> Get(int PageIndex, int PageSize, int PortId, int? ProductId, out int TotalRecords);

        TerminalsModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        Tuple<IList<ProductModel>, IList<ProductModel>> GetTerminalProductAssigned(Guid Token);

        IList<ProductByTerminalModel> GetTerminalByProducts(Guid? Token, int Type);

        List<dynamic> GetRankRate(Guid? Token);
    }
}