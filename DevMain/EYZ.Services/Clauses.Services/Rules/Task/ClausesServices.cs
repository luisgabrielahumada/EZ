using Clauses.Services.Rules.Interface;
using Clauses.Services.Rules.Model;
using Gesi.Access.Database;
using Insight.Database;
using System;
using System.Collections.Generic;

namespace Clauses.Services.Rules.Task
{
    public class ClausesServices : IClausesTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IClauses>().DB_Clauses_Delete(Token);
        }

        public IList<ClausesModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive, Guid? ContractToken)
        {
            return Database.CurrentCnn.As<IClauses>().DB_Clauses_List(PageIndex, PageSize, out TotalRecords, IsActive, ContractToken);
        }

        public ClausesModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IClauses>().DB_Clauses_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IClauses>().DB_Clauses_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, String Name, String Code, bool IsModify, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IClauses>().DB_Clauses_Save(Token, Name, Code, IsModify, IsActive, UpdatedId);
        }
    }
}