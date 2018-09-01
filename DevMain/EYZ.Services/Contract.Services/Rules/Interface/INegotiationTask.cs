using Clauses.Services.Rules.Model;
using Contract.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Interface
{
    public interface INegotiationTask
    {
        void Continue(Guid Token,List<NegotiationClauseModel> Clauses, bool IsActive, int UpdatedId);

        IList<NegotiationModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive);

        NegotiationModel Get(Guid Token);

        NegotiationModel History(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}