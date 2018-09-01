using Contract.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Interface
{
    public partial interface INegotiation
    {
        IList<NegotiationModel> DB_Negotiation_List(int PageIndex, int PageSize, out int TotalRecords, int? IsActive);
        NegotiationModel DB_Negotiation_Get(Guid Token);
        NegotiationModel DB_NegotiationHistory_Get(Guid Token);
        void DB_Negotiation_Delete(Guid Token);
        int DB_Negotiation_Save(Guid ServiceLiquidationToken, bool IsActive, int UpdatedId);
        void DB_Negotiation_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
        void DB_DetailNegotiation_Save(int id, int NegotiationsOfRequestId, string observation, bool IsModify, bool IsActive, int UpdatedId);
    }
}