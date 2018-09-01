using Clauses.Services.Rules.Model;
using Contract.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Interface
{
    public interface IContractTask
    {
        void Save(Guid Token, String Name, String  Code, String Observation, DateTime AvailableFrom, List<ClausesModel> ContractClauses, bool IsActive, int UpdatedId);

        IList<ContractModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive);

        ContractModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}