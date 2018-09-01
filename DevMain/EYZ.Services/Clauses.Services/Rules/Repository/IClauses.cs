using Clauses.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Clauses.Services.Rules.Interface
{
    public partial interface IClauses
    {
        IList<ClausesModel> DB_Clauses_List(int PageIndex, int PageSize, out int TotalRecords, int? IsActive, Guid? ContractToken);

        ClausesModel DB_Clauses_Get(Guid Token);

        void DB_Clauses_Delete(Guid Token);

        void DB_Clauses_Save(Guid Token, String Name, String Code, bool IsModify, bool IsActive, int UpdatedId);

        void DB_Clauses_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}