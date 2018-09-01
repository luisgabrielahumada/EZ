using Contract.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Interface
{
    public partial interface IContract
    {
        IList<ContractModel> DB_Contract_List(int PageIndex, int PageSize, out int TotalRecords, int? IsActive);

        ContractModel DB_Contract_Get(Guid Token);

        void DB_Contract_Delete(Guid Token);

        void DB_Contract_Save(Guid Token, String Name, String Code, String Observation, DateTime AvailableFrom, String Clauses, bool IsActive, int UpdatedId);

        void DB_Contract_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}