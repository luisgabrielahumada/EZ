using Clauses.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Clauses.Services.Rules.Interface
{
    public interface IClausesTask
    {
        void Save(Guid Token, String Name, String Code, bool IsModify, bool IsActive, int UpdatedId);

        IList<ClausesModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive,Guid? ContractToken);

        ClausesModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}