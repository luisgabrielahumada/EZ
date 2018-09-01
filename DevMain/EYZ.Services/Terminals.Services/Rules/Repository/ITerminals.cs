using Terminals.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Terminals.Services.Rules.Interface
{
    public partial interface ITerminals
    {
        IList<TerminalsModel> DB_Terminal_List(int PageIndex, int PageSize, int PortId, int? ProductId, out int TotalRecords);

        TerminalsModel DB_Terminal_Get(Guid Token);

        IList<ProductByTerminalModel> DB_TerminalByProducts_Get(Guid? Token, int Type);


        List<dynamic> DB_RankRateTerminals_Get(Guid? Token);

        void DB_Terminal_Delete(Guid Token);

        void DB_Terminal_Save(Guid Token, int PortId, String Name, String Address, String Contants, String Phone, int CityId, String Xaxis, String Yaxis, String Email, int ConditionId, float ConditionValue, string Products, bool IsActive, int UpdatedId, string RankRate);

        void DB_Terminal_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}