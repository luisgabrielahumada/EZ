using Tolerances.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Tolerances.Services.Rules.Interface
{
    public partial interface ITolerances
    {
        IList<ToleranceModel> DB_Tolerance_List(int PageIndex, int PageSize, out int TotalRecords);

        ToleranceModel DB_Tolerance_Get(Guid Token);

        void DB_Tolerance_Delete(Guid Token);

        void DB_Tolerance_Save(Guid Token, String Name, int Value, bool IsActive, int UpdatedId);

        void DB_Tolerance_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}