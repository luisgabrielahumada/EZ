using Gesi.Access.Database;
using Insight.Database;
using System;
using System.Collections.Generic;
using Tolerances.Services.Rules.Interface;
using Tolerances.Services.Rules.Model;

namespace Tolerances.Services.Rules.Task
{
    public class ToleranceServices : ITolerancesTask
    {
        public IList<ToleranceModel> Get(int PageIndex, int PageSize, out int TotalRecords)
        {
            return Database.CurrentCnn.As<ITolerances>().DB_Tolerance_List(PageIndex, PageSize, out TotalRecords);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<ITolerances>().DB_Tolerance_Delete(Token);
        }

        public ToleranceModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<ITolerances>().DB_Tolerance_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<ITolerances>().DB_Tolerance_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, int Value, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<ITolerances>().DB_Tolerance_Save(Token, Name, Value, IsActive, UpdatedId);
        }
    }
}