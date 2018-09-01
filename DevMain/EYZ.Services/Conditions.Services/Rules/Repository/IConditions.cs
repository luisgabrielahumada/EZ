using Conditions.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Conditions.Services.Rules.Interface
{
    public partial interface IConditions
    {
        IList<ConditionModel> DB_Condition_List(int PageIndex, int PageSize, out int TotalRecords);

        ConditionModel DB_Condition_Get(Guid Token);

        void DB_Condition_Delete(Guid Token);

        void DB_Condition_Save(Guid Token, String Name, float value, String Description, bool IsActive, int UpdatedId);

        void DB_Condition_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}